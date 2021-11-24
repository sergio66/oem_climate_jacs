use_this_rtp = 'latbin1_40.rp.rtp';      %% cloudy
%{
[h,ha,p,pa] = rtpread('../latbin1_40.rp.rtp');
p.cngwat  = zeros(size(p.cngwat));
p.cfrac   = zeros(size(p.cngwat));
p.cngwat2 = zeros(size(p.cngwat));
p.cfrac2  = zeros(size(p.cngwat));
p.cfrac12 = zeros(size(p.cngwat));
p.ctype   = ones(size(p.cngwat))*-9999;
p.ctype2  = ones(size(p.cngwat))*-9999;
rtpwrite('latbin1_40.clr.rp.rtp',h,ha,p,pa);
%}

use_this_rtp = 'latbin1_40.clr.rp.rtp';  %% clear
use_this_rtp = 'tjac_100layer_prof21.rtp'; %% clear prof 21, repeated 99 times ... 99th time is the r0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% moved to clust_do_kcarta_driver.m
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%% use_this_rtp0 = use_this_rtp;
%% set_convolver
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
