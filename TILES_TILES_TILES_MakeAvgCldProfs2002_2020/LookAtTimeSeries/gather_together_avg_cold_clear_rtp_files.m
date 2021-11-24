for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  for ii = 1: 72
    clear pclr pcld pavg
    indX = ii;
    indY = jj;
    JOB = (indY-1)*72 + indX;
    fnameclr = ['RTP_PROFS/Clr/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_clr.rtp'];
    fnamecld = ['RTP_PROFS/Cld/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cld.rtp'];
    fnameavg = ['RTP_PROFS/Avg/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_avg.rtp'];
    fnamecold = ['RTP_PROFS/Cold/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cold.rtp'];
  
    if exist(fnameclr)
      [h,ha,pclr,pa] = rtpread(fnameclr);
    end

    if exist(fnamecld)
      [h,ha,pcld,pa] = rtpread(fnamecld);
    end

    if exist(fnameavg)
      [h,ha,pavg,pa] = rtpread(fnameavg);
    end

    data.cfrac_clr(ii,jj) = pclr.cfrac(1);
    data.cfrac2_clr(ii,jj) = pclr.cfrac2(1);
    data.cfrac_cld(ii,jj) = pcld.cfrac(1);
    data.cfrac2_cld(ii,jj) = pcld.cfrac2(1);
    data.cfrac_avg(ii,jj) = pavg.cfrac(1);
    data.cfrac2_avg(ii,jj) = pavg.cfrac2(1);

    data.cngwat_clr(ii,jj) = pclr.cngwat(1);
    data.cngwat2_clr(ii,jj) = pclr.cngwat2(1);
    data.cngwat_cld(ii,jj) = pcld.cngwat(1);
    data.cngwat2_cld(ii,jj) = pcld.cngwat2(1);
    data.cngwat_avg(ii,jj) = pavg.cngwat(1);
    data.cngwat2_avg(ii,jj) = pavg.cngwat2(1);

    data.rlon(ii,jj) = pavg.rlon(1);
    data.rlat(ii,jj) = pavg.rlat(1);
  end
end

figure(1); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac_clr(:)); title('cfrac clr')
figure(2); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac_cld(:)); title('cfrac cld')
figure(3); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac_avg(:)); title('cfrac avg')

figure(1); simplemap_sergio(data.rlat(:),data.rlon(:),data.cfrac_clr(:),5); title('cfrac clr')
figure(2); simplemap_sergio(data.rlat(:),data.rlon(:),data.cfrac_cld(:),5); title('cfrac cld')
figure(3); simplemap_sergio(data.rlat(:),data.rlon(:),data.cfrac_avg(:),5); title('cfrac avg')

figure(4); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac2_clr(:)); title('cfrac2 clr')
figure(5); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac2_cld(:)); title('cfrac2 cld')
figure(6); scatter_coast(data.rlon(:),data.rlat(:),30,data.cfrac2_avg(:)); title('cfrac2 avg')
