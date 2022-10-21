function d = merge_v2(ilon,ilat)

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv2';
fdirpre_out = 'Data/Quantv2_fits';

fn = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2.mat',ilat,ilon);
fn = fullfile(fdirpre,fn);

fn2 = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2_iset417p.mat',ilat,ilon);
fn2 = fullfile(fdirpre,fn2);

fn3 = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2_iset433p.mat',ilat,ilon);
fn3 = fullfile(fdirpre,fn3);

d = load(fn);
d2 = load(fn2);

d.r_desc = [d.r_desc; d2.r_desc];
d.r_asc = [d.r_asc; d2.r_asc];
d.r_desc_std = [d.r_desc_std; d2.r_desc_std];
d.r_asc_std = [d.r_asc_std; d2.r_asc_std];
d.r_desc_all = [d.r_desc_all; d2.r_desc_all];
d.r_asc_all = [d.r_asc_all; d2.r_asc_all];
d.count_asc = [d.count_asc; d2.count_asc];
d.count_desc = [d.count_desc; d2.count_desc];
d.satzen_asc = [d.satzen_asc; d2.satzen_asc];
d.satzen_desc = [d.satzen_desc; d2.satzen_desc];
d.solzen_asc = [d.solzen_asc; d2.solzen_asc];
d.solzen_desc = [d.solzen_desc; d2.solzen_desc];
d.tsurf_asc = [d.tsurf_asc; d2.tsurf_asc];
d.tsurf_desc = [d.tsurf_desc; d2.tsurf_desc];
d.tai93_asc = [d.tai93_asc; d2.tai93_asc];
d.tai93_desc = [d.tai93_desc; d2.tai93_desc];
d.counts_desc_bin = [d.counts_desc_bin; d2.counts_desc_bin];
d.counts_asc_bin = [d.counts_asc_bin; d2.counts_asc_bin];
d.r_dasc_all = [d.r_dasc_all; d2.r_dasc_all];
%d.r_asc_all = d.r_dasc_all;
%d = rmfield(d,'r_dasc_all');
d.iset_start = 1;
d.iset_top = d2.iset_stop;

d2 = load(fn3);

d.r_desc = [d.r_desc; d2.r_desc];
d.r_asc = [d.r_asc; d2.r_asc];
d.r_desc_std = [d.r_desc_std; d2.r_desc_std];
d.r_asc_std = [d.r_asc_std; d2.r_asc_std];
d.r_desc_all = [d.r_desc_all; d2.r_desc_all];
d.r_asc_all = [d.r_asc_all; d2.r_asc_all];
d.count_asc = [d.count_asc; d2.count_asc];
d.count_desc = [d.count_desc; d2.count_desc];
d.satzen_asc = [d.satzen_asc; d2.satzen_asc];
d.satzen_desc = [d.satzen_desc; d2.satzen_desc];
d.solzen_asc = [d.solzen_asc; d2.solzen_asc];
d.solzen_desc = [d.solzen_desc; d2.solzen_desc];
d.tsurf_asc = [d.tsurf_asc; d2.tsurf_asc];
d.tsurf_desc = [d.tsurf_desc; d2.tsurf_desc];
d.tai93_asc = [d.tai93_asc; d2.tai93_asc];
d.tai93_desc = [d.tai93_desc; d2.tai93_desc];
d.counts_desc_bin = [d.counts_desc_bin; d2.counts_desc_bin];
d.counts_asc_bin = [d.counts_asc_bin; d2.counts_asc_bin];
d.r_dasc_all = [d.r_dasc_all; d2.r_dasc_all];
d.r_asc_all = d.r_dasc_all;
d = rmfield(d,'r_dasc_all');
d.iset_start = 1;
d.iset_top = d2.iset_stop;

