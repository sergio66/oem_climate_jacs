clear all

addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE

kcvers = 112;
kcvers = 120

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if kcvers >= 118
  [r,w] = readkcstd_smart('JUNK/x.dat');
else
  [r,w] = readkcstd_smartv116('JUNK/x.dat');
  ind = find(w >= 1305-0.00001 & w <= 1605-0.0025 + 0.00001);
  [ind(1) ind(end)]
  r = r(ind,:);
  w = w(ind);
end
for nn = 1 : 6
  [fc,qc] = quickconvolve(w,r(:,nn),0.5,0.5);
  plot(fc,qc); title(['dat : ' num2str(nn)]);
  %disp('ret'); pause
  pause(0.1)
end

[fc,qc] = quickconvolve(w,r(:,[1 3 4 5]),0.5,0.5);
semilogy(fc,qc,'linewidth',2); title(['dat W Self Forn HDO']);
hl = legend('W','Self','Forn','HDO','location','best');
%disp('ret'); pause
pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if kcvers >= 118
  [j,w] = readkcjac('JUNK/x.jac');
  nnmax = 7;
else
  [j,w] = readkcjacv116('JUNK/x.jac');
  ind = find(w >= 1305-0.00001 & w <= 1605-0.0025 + 0.00001);
  j = j(ind,:);
  w = w(ind);
  nnmax = 6;
end
for nn = 1 : nnmax
  nT = (1:97) + (nn-1)*97; [fc,qc] = quickconvolve(w,j(:,nT),0.5,0.5);
  plot(fc,sum(qc')); title(['sum jac ' num2str(nn)]);
  [nn nT(1) nT(end)]
  %disp('ret'); pause
  pause(0.1)
end

if kcvers >= 118
  nn = 6;
else
  nn = 5;
end
nT = (1:97) + (nn-1)*97; [fc,qc] = convolve_airs(w,j(:,nT),1:2378);
plot(fc,sum(qc')); title(['sum jac T ' num2str(nn)]);
[nn nT(1) nT(end)]

[mmx,nnx] = size(r);
[fc,qcr] = convolve_airs(w,r(:,nnx),1:2378);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this is from MATLABCODE/kcarta-junk/Test/
%% save /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA/CLEAR_JACS/kcml.mat fc qc qcr j1 j10001

kcml = load('kcml.mat'); 
figure(1); plot(fc,rad2bt(fc,qcr),'b.-',kcml.fc,rad2bt(fc,kcml.qcr),'r'); title('BT')
ax = axis; axis([1305 1605 200 280])

figure(1); plot(fc,rad2bt(fc,qcr) - rad2bt(fc,kcml.qcr),'r'); title('BT f77-Matlab')

figure(2); plot(fc,sum(qc'),'b.-',kcml.fc,sum(kcml.qc'),'r'); title('sum(T jacs)'); 
ax = axis; axis([1305 1605 0.8 1.1])

figure(3); pcolor(fc,1:97,qc');              shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('f77')
  cx = caxis;
figure(4); pcolor(fc,1:97,kcml.qc');         shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('matlab')
  caxis(cx);

%figure(3); pcolor(fc,1:97,log10(abs(qc')));              shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('f77')
%  cx = caxis;
%figure(4); pcolor(fc,1:97,log10(abs(kcml.qc')));         shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('matlab')
%  caxis(cx);

figure(5); pcolor(fc,1:97,qc'-kcml.qc'); shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('f77-matlab')
figure(5); pcolor(fc,1:97,qc' ./ kcml.qc'); shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('f77/matlab'); 
  caxis([0.75 +1.25])
figure(5); pcolor(fc,1:97,qc' ./ kcml.qc' - 1.0); shading flat; colormap jet; colorbar; axis([1305 1605 1 97]); title('f77/matlab-1'); 
  caxis([-0.25 +0.25])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
load v120_T_radunits.mat
t0   = rad2bt(fc,qcr) * ones(1,97);
tjac = rad2bt(fc,qc + qcr*ones(1,97));

thejac = tjac-t0;
plot(fc,sum(thejac'))

v120 = load('v120_T.mat');
plot(v120.fc,sum(v120.qc'),fc,sum(thejac'))
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%save v112_T.mat fc qc qcr
%save v120_T.mat fc qc qcr

v120 = load('v120_T.mat');
v112 = load('v112_T.mat');
plot(v112.fc,sum(v112.qc'),v112.fc,sum(v120.qc'))
plot(v112.fc,rad2bt(v112.fc,v112.qcr),v112.fc,rad2bt(v112.fc,v120.qcr))
plot(v112.fc,rad2bt(v112.fc,v112.qcr)-rad2bt(v112.fc,v120.qcr))
%}
