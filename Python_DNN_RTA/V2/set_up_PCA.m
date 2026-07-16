%% ------------------------------------------------------------------
%  1. Normalize the well-mixed gases + scalars
%  ------------------------------------------------------------------
% Well-mixed gases: shape barely varies -> represent with column mean only
disp('Stage 1 : normalize')
% co2Scalar = mean(CO2, 2);
% ch4Scalar = mean(CH4, 2);
% n2oScalar = mean(N2O, 2);
co2Scalar = co2_500mb;
ch4Scalar = ch4_500mb;
n2oScalar = n2o_500mb;

scalarNames = {'surfTemp','surfPressure','viewAngleSecant', 'localAngleSecant', ...
               'co2Scalar','ch4Scalar','n2oScalar'};
rawScalars  = struct('surfTemp',surfTemp,  'surfPressure',surfPressure, ...
                      'viewAngleSecant',viewAngleSecant, 'localAngleSecant',localAngleSecant, ...
                      'co2Scalar',co2Scalar,'ch4Scalar',ch4Scalar,'n2oScalar',n2oScalar);

scalarStats = struct();
scalarTensor = zeros(nSamples, numel(scalarNames));
for k = 1:numel(scalarNames)
    name = scalarNames{k};
    x = rawScalars.(name);
    scalarStats.(name).mean = mean(x);
    scalarStats.(name).std  = std(x) + 1e-12;
    scalarTensor(:,k) = (x - scalarStats.(name).mean) / scalarStats.(name).std;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ------------------------------------------------------------------
%  2. PCA-compress T, Q, O3 profiles; emissivity input; BT target
%  ------------------------------------------------------------------
disp('Stage 2 : PCA compress')
% log-transform humidity and ozone before PCA (both span orders of
% magnitude and are closer to log-normal); temperature stays linear
Q_log   = log(max(Q, 1e-12));
O3_log  = log(max(O3, 1e-12));
%CH4_log = log(max(CH4, 1e-12));

tPCA   = fitSpectralPCA(T,      nPCA_T);
qPCA   = fitSpectralPCA(Q_log,  nPCA_Q);
o3PCA  = fitSpectralPCA(O3_log, nPCA_O3);
%ch4PCA = fitSpectralPCA(O3_log, nPCA_CH4);

tEOF    = encodeSpectral(tPCA,  T,      true);
qEOF    = encodeSpectral(qPCA,  Q_log,  true);
o3EOF   = encodeSpectral(o3PCA, O3_log, true);
%ch4EOF  = encodeSpectral(ch4PCA,CH4_log, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%emissivityRaw0 = emissivityRaw;
%btRaw0         = btRaw;
%freq0          = freq;
%btTrueVal0     = btTrueVal;

whos tPCA qPCA o3PCA  tEOF qEOF o3EOF
