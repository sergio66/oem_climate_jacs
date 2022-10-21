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
            firenight = isfield(g.fire,'night');
         end
         if firetrue & firenight 
            for i=1:length(g.fire);
               ifirenight = isfield(g.fire(i),'night');
               if length(g.fire(i).night) > 0
                  if g.fire(i).night.solzenf > 95 
%            nf(lati,loni,i) = length(g.fire(i).night);
                     nf(lati,loni,i) = NaN;
                     latf(lati,loni).fire(i).latf = g.fire(i).night.latf;
                     lonf(lati,loni).fire(i).lonf = g.fire(i).night.lonf;
                     mtimef(lati,loni).fire(i).mtimef = g.fire(i).night.mtimef;
%                  bt_fire(lati,loni).fire(i).bt_fire = g.fire(i).night.bt_fire;
                     t1231(lati,loni).fire(i).t1231 = g.fire(i).night.t1231';
                     t2616(lati,loni).fire(i).t2616 = g.fire(i).night.t2616';
%                      bt1231(lati,loni).fire(i).bt1231 = g.fire(i).night.bt1231';
%                      bt2616(lati,loni).fire(i).bt2616 = g.fire(i).night.b2616';
                     satzenf(lati,loni).fire(i).satzenf = g.fire(i).night.satzenf;
                     solzenf(lati,loni).fire(i).solzenf = g.fire(i).night.solzenf;
                  end
               else
               end
               nf(lati,loni,i) = NaN;
            end
         end
      end  % if firetrue & firenight & afire
   end
end



% Any fires at all





