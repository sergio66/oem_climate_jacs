% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

fdirpre = 'Data/Quantv3';

latf = [];
lonf = [];
mtimef = [];
bt_fire = [];
t1231 = [];
t2616 = [];
% bt1231 = [];
% bt2616 = [];
satzenf = [];
solzenf = [];

for lati = 1:64
   lati
   for loni = 1:72
      loni;
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/hotfire_LatBin%1$02d_LonBin%2$02d_v2.mat',lati,loni);

      fnout = fullfile(fdirpre,fnout);
      if exist(fnout);
         g=load(fnout);
         firetrue = isfield(g,'fire');
         if firetrue
            fireday = isfield(g.fire,'day');
         end
         if firetrue & fireday 
            for i=1:length(g.fire);
               ifireday = isfield(g.fire(i),'day');
               if length(g.fire(i).day) > 0
                  if g.fire(i).day.solzenf < 90;
%            nf(lati,loni,i) = length(g.fire(i).day);
                     nf(lati,loni,i) = NaN;
                     latf(lati,loni).fire(i).latf = g.fire(i).day.latf;
                     lonf(lati,loni).fire(i).lonf = g.fire(i).day.lonf;
                     mtimef(lati,loni).fire(i).mtimef = g.fire(i).day.mtimef;
%                  bt_fire(lati,loni).fire(i).bt_fire = g.fire(i).day.bt_fire;
                     t1231(lati,loni).fire(i).t1231 = g.fire(i).day.t1231';
                     bt2616(lati,loni).fire(i).t2616 = g.fire(i).day.bt_fire(2600,:)';
%                      bt1231(lati,loni).fire(i).bt1231 = g.fire(i).day.bt1231';
%                      bt2616(lati,loni).fire(i).bt2616 = g.fire(i).day.b2616';
                     satzenf(lati,loni).fire(i).satzenf = g.fire(i).day.satzenf;
                     solzenf(lati,loni).fire(i).solzenf = g.fire(i).day.solzenf;
                  end
               else
               end
               nf(lati,loni,i) = NaN;
            end
         end
      end  % if firetrue & fireday & afire
   end
end



% Any fires at all





