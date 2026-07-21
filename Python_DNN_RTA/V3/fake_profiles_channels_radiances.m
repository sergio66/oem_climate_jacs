freq0 = instr_chans2645;
T_00     = randn(nSamples, nLevels)*20 + 250;
Q_00     = abs(randn(nSamples, nLevels)) + 1e-3;
O3_00    = abs(randn(nSamples, nLevels))*1e-6 + 1e-8;
CO2_00   = 400*ones(nSamples, nLevels)   + randn(nSamples,1);
CH4_00   = 1.8*ones(nSamples, nLevels)   + 0.05*randn(nSamples,1);
N2O_00   = 0.3*ones(nSamples, nLevels)   + 0.01*randn(nSamples,1);

surfTemp_00        = randn(nSamples,1)*15 + 288;
surfPressure_00    = 325 + (1067-325)*rand(nSamples,1);   % hPa; varies with terrain
viewAngleSecant_00 = 1 ./ cos(rand(nSamples,1)*1.0);

wavenumbers      = linspace(650, 1200, nChannels0);
radianceRaw_00   = 50 + 100*rand(nSamples, nChannels0);
btRaw_00         = planckBT(radianceRaw, wavenumbers);
emissivityRaw_00 = min(max(0.95 + 0.03*randn(nSamples, nChannels0), 0.5), 1.0);
