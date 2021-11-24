set_rtp

iProf = 21;
[h0,ha,p0,pa] = rtpread(use_this_rtp);

num_repeat = p0.nlevs(iProf) + 1;
addpath /home/sergio/MATLABCODE
[hnew,pnew] = replicate_rtp_headprof(h0,p0,iProf,num_repeat);

for ii = 1 : num_repeat
  pnew.ptemp(ii,ii) = pnew.ptemp(ii,ii) + 1.0;
end

rtpwrite(['tjac_100layer_prof' num2str(iProf) '.rtp'],hnew,ha,pnew,pa);
plot(p0.ptemp(:,iProf)*ones(1,num_repeat)-pnew.ptemp,1:101,'b',p0.ptemp(:,iProf)-pnew.ptemp(:,num_repeat),1:101,'ro-')
