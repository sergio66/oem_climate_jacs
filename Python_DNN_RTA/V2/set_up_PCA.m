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

if iScalar == 0
  scalarNames = {'surfTemp','surfPressure','viewAngleSecant', 'localAngleSecant', ...
                 'co2Scalar','ch4Scalar','n2oScalar'};
  rawScalars  = struct('surfTemp',surfTemp,  'surfPressure',surfPressure, ...
                       'viewAngleSecant',viewAngleSecant, 'localAngleSecant',localAngleSecant, ...
                       'co2Scalar',co2Scalar,'ch4Scalar',ch4Scalar,'n2oScalar',n2oScalar);
elseif iScalar == 1
  scalarNames = {'surfTemp','surfPressure','viewAngleSecant', 'localAngleSecant', 'n2oScalar'};
  rawScalars  = struct('surfTemp',surfTemp,  'surfPressure',surfPressure, ...
                       'viewAngleSecant',viewAngleSecant, 'localAngleSecant',localAngleSecant, ...
                       'n2oScalar',n2oScalar);
else
  error('iScalar should be 0 or 1')
end

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
if iScalar == 1
  CH4_log = log(max(CH4, 1e-12));
  CO2_log = log(max(CO2, 1e-12));  
end

tPCA   = fitSpectralPCA(T,      nPCA_T);
qPCA   = fitSpectralPCA(Q_log,  nPCA_Q);
o3PCA  = fitSpectralPCA(O3_log, nPCA_O3);
if iScalar == 1
  ch4PCA = fitSpectralPCA(O3_log, nPCA_CH4);
  co2PCA = fitSpectralPCA(O3_log, nPCA_CO2);
end

tEOF    = encodeSpectral(tPCA,  T,      true);
qEOF    = encodeSpectral(qPCA,  Q_log,  true);
o3EOF   = encodeSpectral(o3PCA, O3_log, true);
if iScalar == 1
  ch4EOF  = encodeSpectral(ch4PCA,CH4_log, true);
  co2EOF  = encodeSpectral(co2PCA,CO2_log, true);
end

figure(1); clf
  subplot(131); plot(tPCA.coeff(:,1:3), 1:100); title('eof T'); set(gca,'ydir','reverse')
  subplot(132); plot(qPCA.coeff(:,1:3), 1:100); title('eof Q'); set(gca,'ydir','reverse')
  subplot(133); plot(o3PCA.coeff(:,1:3),1:100); title('eof OZ'); set(gca,'ydir','reverse')
if iScalar == 1
  figure(2); clf
  subplot(121); plot(co2PCA.coeff(:,1:3), 1:100); title('eof CO2'); set(gca,'ydir','reverse')
  subplot(122); plot(ch4PCA.coeff(:,1:3), 1:100); title('eof CH4'); set(gca,'ydir','reverse')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%emissivityRaw0 = emissivityRaw;
%btRaw0         = btRaw;
%freq0          = freq;
%btTrueVal0     = btTrueVal;

whos tPCA qPCA o3PCA  tEOF qEOF o3EOF
if iScalar == 1
  whos co2PCA ch4PCA co2EOF ch4EOF
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check the reconstruction of the T,Q,O3 profiles
Trecon  = decodeSpectral(tPCA,  encodeSpectral(tPCA,  T,      false), false);
Qrecon  = exp(decodeSpectral(qPCA,  encodeSpectral(qPCA,  Q_log,  false), false));
O3recon = exp(decodeSpectral(o3PCA, encodeSpectral(o3PCA, O3_log, false), false));

fprintf('T  reconstruction RMSE: %.3f K\n', sqrt(mean((Trecon - T).^2, 'all')));
fprintf('Q  reconstruction relative RMSE: %.2f%%\n', 100*sqrt(mean(((Qrecon - Q)./Q).^2, 'all')));
fprintf('O3 reconstruction relative RMSE: %.2f%%\n', 100*sqrt(mean(((O3recon - O3)./O3).^2, 'all')));

