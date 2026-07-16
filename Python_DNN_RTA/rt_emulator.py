"""
DNN emulator for a radiative transfer forward model.

Input per profile:
    - N-level profiles (N fixed via sigma-coordinate interpolation, e.g. 100)
      of: T, humidity, O3, CO2, CH4, N2O   -> shape (n_levels, 6)
    - Scalars: surface temperature, surface pressure, view angle
    - Spectral: surface emissivity, one value per output channel (M-length,
      same wavenumber grid as the target radiances) -- compressed via its
      own PCA, same idea as the output compression below, and fed in as a
      handful of coefficients rather than a raw M-length vector.

Output per profile:
    - M radiances (M ~ 500-2500), compressed via PCA to a small
      coefficient vector that the network actually predicts.

Pipeline:
    1. Interpolate raw profiles (variable N, variable surface pressure)
       onto a fixed sigma grid.
    2. Log-transform gas concentrations, z-score everything.
    3. Convert target radiances -> brightness temperature (optional but recommended).
    4. PCA-compress both the target BT spectra AND the input emissivity
       spectra (both are smooth/low-rank across channels).
    5. Train a CNN+MLP network: profile -> encoder, [scalars + emissivity
       PCA coeffs] -> scalar branch, concat -> trunk -> predicted BT PCA coeffs.
    6. Reconstruct full spectrum via the (fixed or fine-tuned) PCA decoder.
"""

import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from sklearn.decomposition import PCA


# ---------------------------------------------------------------------------
# 1. Preprocessing utilities
# ---------------------------------------------------------------------------

def interp_profile_to_sigma_grid(pressure, values, ref_sigma):
    """Interpolate one profile (arbitrary N levels, arbitrary surface
    pressure) onto a fixed SIGMA grid, sigma = p / p_surface.

    This is the terrain-following approach used operationally in NWP
    (ECMWF/GFS-style hybrid-sigma levels). It's necessary -- not just
    convenient -- whenever surface pressure varies a lot across your
    training set (ocean p_surf ~1013 hPa vs. high terrain like Everest
    ~325 hPa vs. below-sea-level sites like the Dead Sea ~1067 hPa).
    A fixed pressure grid would require inventing atmosphere that
    doesn't exist below high terrain, or truncating it away.

    sigma=0 is always TOA, sigma=1 is always the surface, for every
    profile regardless of actual surface pressure -- so every profile
    maps onto the same fixed number of levels with no extrapolation.

    pressure : raw pressure levels for this profile (Pa or hPa, N_i long)
    values   : the variable on those same levels (N_i long)
    ref_sigma: fixed sigma grid to interpolate onto, e.g. np.linspace(0,1,100)
               (bias more points toward sigma->0 and sigma->1 if you want
               more resolution at TOA and near-surface, since that's where
               most RT-relevant structure lives)
    """
    p_surf = pressure[-1]  # assumes levels ordered TOA -> surface
    sigma_src = pressure / p_surf
    # avoid log(0) at TOA; sigma=0 exactly maps to value at sigma_src[0]
    return np.interp(ref_sigma, sigma_src, values)


def make_reference_sigma_grid(n_levels, concentrate_near_surface=True):
    """A reasonable default sigma grid: denser near sigma=1 (surface,
    where most absorption/temperature structure lives); near sigma=0
    is fine linear since the upper atmosphere is smooth in sigma space."""
    if concentrate_near_surface:
        lin = np.linspace(0, 1, n_levels)
        return lin ** 1.5  # denser spacing near 1 without excluding sigma=0
    return np.linspace(0, 1, n_levels)


GAS_VARS = ["humidity", "o3", "co2", "ch4", "n2o"]  # log-transformed
LINEAR_VARS = ["temperature"]                        # not log-transformed


class ProfileNormalizer:
    """Fits mean/std per (variable, level) on the training set and applies
    the same transform at inference time. Persist this object (pickle) so
    you apply *exactly* the same normalization in production.
    """

    def __init__(self):
        self.stats = {}  # var_name -> (mean[n_levels], std[n_levels])
        self.scalar_stats = {}  # name -> (mean, std)

    def fit_profiles(self, profiles: dict):
        # profiles: {var_name: array of shape (n_samples, n_levels)}
        for var, arr in profiles.items():
            x = np.log(np.clip(arr, 1e-12, None)) if var in GAS_VARS else arr
            self.stats[var] = (x.mean(axis=0), x.std(axis=0) + 1e-12)

    def transform_profiles(self, profiles: dict):
        out = []
        for var in LINEAR_VARS + GAS_VARS:
            arr = profiles[var]
            x = np.log(np.clip(arr, 1e-12, None)) if var in GAS_VARS else arr
            mean, std = self.stats[var]
            out.append((x - mean) / std)
        # stack -> (n_samples, n_levels, n_vars)
        return np.stack(out, axis=-1)

    def fit_scalars(self, scalars: dict):
        for name, arr in scalars.items():
            self.scalar_stats[name] = (arr.mean(), arr.std() + 1e-12)

    def transform_scalars(self, scalars: dict):
        out = []
        for name in scalars:
            mean, std = self.scalar_stats[name]
            out.append((scalars[name] - mean) / std)
        return np.stack(out, axis=-1)


def planck_bt(radiance, wavenumber_cm1):
    """Invert Planck's law: radiance (mW/m2/sr/cm-1) -> brightness temp (K).
    Vectorized over channels. Adjust constants if your radiance units differ.
    """
    c1 = 1.191042e-5   # mW/m2/sr/cm-4
    c2 = 1.4387752     # K*cm
    nu = wavenumber_cm1
    return c2 * nu / np.log(1.0 + (c1 * nu**3) / radiance)


def bt_to_radiance(bt, wavenumber_cm1):
    c1 = 1.191042e-5
    c2 = 1.4387752
    nu = wavenumber_cm1
    return (c1 * nu**3) / (np.exp(c2 * nu / bt) - 1.0)


# ---------------------------------------------------------------------------
# 2. Output compression (PCA)
# ---------------------------------------------------------------------------

class SpectralCompressor:
    """PCA compressor for any smooth per-channel spectrum -- used for both
    the target BT spectra and the input emissivity spectra. Both are highly
    redundant across adjacent channels, so a handful of components captures
    nearly all the variance. Fit a SEPARATE instance for each (different
    physical quantities, different optimal n_components -- emissivity
    spectra are typically even smoother than BT and may need only 5-10
    components vs. 20-50 for radiance).

    Note: whatever spectrum you compress must be defined on a fixed,
    consistent wavenumber/channel grid across all profiles. If your
    emissivity is provided on a different (e.g. coarser) grid than the
    output channels, interpolate it onto the output channel grid first.
    """

    def __init__(self, n_components=32):
        self.pca = PCA(n_components=n_components)
        self._coeff_mean = None
        self._coeff_std = None

    def fit(self, spectra):
        self.pca.fit(spectra)
        coeffs = self.pca.transform(spectra)
        self._coeff_mean = coeffs.mean(axis=0)
        self._coeff_std = coeffs.std(axis=0) + 1e-12

    def encode(self, spectra, standardize=False):
        coeffs = self.pca.transform(spectra)
        if standardize:
            coeffs = (coeffs - self._coeff_mean) / self._coeff_std
        return coeffs

    def decode(self, coeffs, standardize=False):
        if standardize:
            coeffs = coeffs * self._coeff_std + self._coeff_mean
        return self.pca.inverse_transform(coeffs)

    @property
    def components_torch(self):
        return torch.tensor(self.pca.components_, dtype=torch.float32)

    @property
    def mean_torch(self):
        return torch.tensor(self.pca.mean_, dtype=torch.float32)


# ---------------------------------------------------------------------------
# 3. Dataset
# ---------------------------------------------------------------------------

class RTDataset(Dataset):
    def __init__(self, profile_tensor, scalar_tensor, pca_coeff_tensor):
        self.profiles = torch.tensor(profile_tensor, dtype=torch.float32)
        self.scalars = torch.tensor(scalar_tensor, dtype=torch.float32)
        self.targets = torch.tensor(pca_coeff_tensor, dtype=torch.float32)

    def __len__(self):
        return len(self.profiles)

    def __getitem__(self, idx):
        return self.profiles[idx], self.scalars[idx], self.targets[idx]


# ---------------------------------------------------------------------------
# 4. Model
# ---------------------------------------------------------------------------

class ProfileEncoder(nn.Module):
    """1D-CNN over the vertical dimension. Input (batch, n_vars, n_levels)."""

    def __init__(self, n_vars, n_levels, out_dim=128):
        super().__init__()
        self.net = nn.Sequential(
            nn.Conv1d(n_vars, 32, kernel_size=5, padding=2),
            nn.ReLU(),
            nn.Conv1d(32, 64, kernel_size=5, padding=2),
            nn.ReLU(),
            nn.AdaptiveAvgPool1d(1),  # global pool over levels
        )
        # also keep a flattened path so the head sees level-resolved info,
        # not just a pooled summary
        self.flatten_proj = nn.Linear(64 * 1, out_dim)

    def forward(self, x):
        # x: (batch, n_levels, n_vars) -> (batch, n_vars, n_levels)
        x = x.transpose(1, 2)
        feat = self.net(x).squeeze(-1)  # (batch, 64)
        return self.flatten_proj(feat)


class RTEmulator(nn.Module):
    def __init__(self, n_levels, n_profile_vars, n_scalars, n_pca_components,
                 pca_components=None, pca_mean=None, finetune_decoder=False):
        super().__init__()
        self.encoder = ProfileEncoder(n_profile_vars, n_levels, out_dim=128)
        self.scalar_mlp = nn.Sequential(
            nn.Linear(n_scalars, 32), nn.ReLU()
        )
        self.trunk = nn.Sequential(
            nn.Linear(128 + 32, 256), nn.ReLU(),
            nn.Linear(256, 256), nn.ReLU(),
            nn.Linear(256, n_pca_components),
        )

        # PCA decoder as a linear layer, initialized from sklearn's PCA fit.
        # finetune_decoder=False keeps it physically grounded (recommended
        # to start); set True later if you want to squeeze out more accuracy.
        n_channels = pca_components.shape[1] if pca_components is not None else None
        self.decoder = nn.Linear(n_pca_components, n_channels, bias=True)
        if pca_components is not None:
            with torch.no_grad():
                self.decoder.weight.copy_(pca_components.T)
                self.decoder.bias.copy_(pca_mean)
        self.decoder.weight.requires_grad = finetune_decoder
        self.decoder.bias.requires_grad = finetune_decoder

    def forward(self, profiles, scalars):
        p = self.encoder(profiles)
        s = self.scalar_mlp(scalars)
        coeffs = self.trunk(torch.cat([p, s], dim=-1))
        bt_hat = self.decoder(coeffs)
        return bt_hat, coeffs


# ---------------------------------------------------------------------------
# 5. Training loop
# ---------------------------------------------------------------------------

def train(model, train_loader, val_loader, epochs=100, lr=1e-3, device="cuda"):
    model = model.to(device)
    opt = torch.optim.Adam(model.parameters(), lr=lr)
    sched = torch.optim.lr_scheduler.ReduceLROnPlateau(opt, patience=5, factor=0.5)
    loss_fn = nn.MSELoss()

    best_val = float("inf")
    for epoch in range(epochs):
        model.train()
        train_loss = 0.0
        for profiles, scalars, target_coeffs in train_loader:
            profiles, scalars, target_coeffs = (
                profiles.to(device), scalars.to(device), target_coeffs.to(device)
            )
            opt.zero_grad()
            _, pred_coeffs = model(profiles, scalars)
            loss = loss_fn(pred_coeffs, target_coeffs)
            loss.backward()
            opt.step()
            train_loss += loss.item() * profiles.size(0)
        train_loss /= len(train_loader.dataset)

        model.eval()
        val_loss = 0.0
        with torch.no_grad():
            for profiles, scalars, target_coeffs in val_loader:
                profiles, scalars, target_coeffs = (
                    profiles.to(device), scalars.to(device), target_coeffs.to(device)
                )
                _, pred_coeffs = model(profiles, scalars)
                val_loss += loss_fn(pred_coeffs, target_coeffs).item() * profiles.size(0)
        val_loss /= len(val_loader.dataset)
        sched.step(val_loss)

        if val_loss < best_val:
            best_val = val_loss
            torch.save(model.state_dict(), "best_model.pt")

        if epoch % 5 == 0:
            print(f"epoch {epoch:3d}  train {train_loss:.5f}  val {val_loss:.5f}")

    return model


# ---------------------------------------------------------------------------
# 6. Example wiring (fill in with your actual data loading)
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    # --- placeholders: replace with your real data loading ---
    n_samples, n_levels, n_channels = 50_000, 100, 1000
    n_pca = 32

    # In real usage, before this point you'd have, per raw profile i:
    #   raw_pressure_i   (N_i values, N_i in [75,100], TOA -> surface, hPa)
    #   raw_temperature_i, raw_humidity_i, ... (N_i values each)
    # and you'd do, for every profile and every variable:
    #
    #   ref_sigma = make_reference_sigma_grid(n_levels=100)
    #   interp_temperature_i = interp_profile_to_sigma_grid(
    #       raw_pressure_i, raw_temperature_i, ref_sigma)
    #
    # ...building up fixed-length (100,) arrays per profile per variable,
    # then stacking across all profiles into the (n_samples, n_levels)
    # arrays that `raw_profiles` below represents. Also record
    # raw_pressure_i[-1] (the actual surface pressure) into scalars_raw
    # as shown below -- that's what recovers the physical information
    # that the sigma coordinate alone strips out.

    raw_profiles = {
        "temperature": np.random.randn(n_samples, n_levels) * 20 + 250,
        "humidity": np.abs(np.random.randn(n_samples, n_levels)) + 1e-3,
        "o3": np.abs(np.random.randn(n_samples, n_levels)) * 1e-6 + 1e-8,
        "co2": np.full((n_samples, n_levels), 400.0),
        "ch4": np.full((n_samples, n_levels), 1.8),
        "n2o": np.full((n_samples, n_levels), 0.3),
    }
    scalars_raw = {
        "surf_temp": np.random.randn(n_samples) * 15 + 288,
        "surf_pressure": np.random.uniform(325.0, 1067.0, n_samples),  # hPa;
            # e.g. Everest ~325, ocean ~1013, Dead Sea ~1067 -- CRITICAL now
            # that profiles are on a sigma grid, since sigma alone doesn't
            # tell the network the actual pressure (-> line broadening) at
            # a given level.
        "view_angle_secant": 1.0 / np.cos(np.random.uniform(0, 1.0, n_samples)),
    }
    wavenumbers = np.linspace(650, 1200, n_channels)
    radiance_raw = np.random.uniform(50, 150, (n_samples, n_channels))
    bt_raw = planck_bt(radiance_raw, wavenumbers)

    # Emissivity: spectral, one value per output channel, SAME wavenumber
    # grid as the radiances/BT above. In real data this typically comes
    # from a surface emissivity atlas/model already on (or interpolatable
    # to) your instrument's channel grid.
    n_emis_pca = 8
    emissivity_raw = np.clip(
        0.95 + 0.03 * np.random.randn(n_samples, n_channels), 0.5, 1.0
    )

    # --- normalize inputs ---
    normalizer = ProfileNormalizer()
    normalizer.fit_profiles(raw_profiles)
    profile_tensor = normalizer.transform_profiles(raw_profiles)  # (N, levels, 6)
    normalizer.fit_scalars(scalars_raw)
    scalar_only_tensor = normalizer.transform_scalars(scalars_raw)  # (N, 3)

    # --- compress emissivity (input) and BT (target) spectra ---
    emis_compressor = SpectralCompressor(n_components=n_emis_pca)
    emis_compressor.fit(emissivity_raw)
    emis_coeffs = emis_compressor.encode(emissivity_raw, standardize=True)  # (N, n_emis_pca)

    compressor = SpectralCompressor(n_components=n_pca)
    compressor.fit(bt_raw)
    pca_coeffs = compressor.encode(bt_raw)                        # (N, n_pca)

    # emissivity PCA coefficients ride along in the scalar branch, since
    # they're already a compact (n_emis_pca,) summary rather than a raw
    # M-length vector
    scalar_tensor = np.concatenate([scalar_only_tensor, emis_coeffs], axis=-1)

    # --- split ---
    n_train = int(0.8 * n_samples)
    train_ds = RTDataset(profile_tensor[:n_train], scalar_tensor[:n_train], pca_coeffs[:n_train])
    val_ds = RTDataset(profile_tensor[n_train:], scalar_tensor[n_train:], pca_coeffs[n_train:])
    train_loader = DataLoader(train_ds, batch_size=256, shuffle=True)
    val_loader = DataLoader(val_ds, batch_size=256)

    # --- build & train ---
    model = RTEmulator(
        n_levels=n_levels,
        n_profile_vars=len(LINEAR_VARS + GAS_VARS),
        n_scalars=scalar_tensor.shape[1],
        n_pca_components=n_pca,
        pca_components=compressor.components_torch,
        pca_mean=compressor.mean_torch,
        finetune_decoder=False,
    )
    device = "cuda" if torch.cuda.is_available() else "cpu"
    train(model, train_loader, val_loader, epochs=20, device=device)
