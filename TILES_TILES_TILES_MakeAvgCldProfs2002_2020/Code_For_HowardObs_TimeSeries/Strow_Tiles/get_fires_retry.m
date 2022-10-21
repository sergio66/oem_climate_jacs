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
satzenf = [];
solzenf = [];

for lati = 1:64
   lati
   tic;   for loni = 1:72
      loni;
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/hotfire_LatBin%1$02d_LonBin%2$02d.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      g=load(fnout);
      firetrue = isfield(g,'fire');
      if firetrue
         firenight = isfield(g.fire,'night');
      end
      if firetrue & firenight 
         for i=1:length(g.fire);
            if length(g.fire(i).night) > 0
               if g.fire(i).night.solzenf > 95 
%            nf(lati,loni,i) = length(g.fire(i).night);
                  nf(lati,loni,i) = NaN;
                  latf(lati,loni).fire(i).latf = g.fire(i).night.latf;
                  lonf(lati,loni).lonf = g.fire(i).night.lonf;
                  mtimef(lati,loni).mtimef = g.fire(i).night.mtimef;
                  bt_fire(lati,loni).bt_fire_2616 = g.fire(i).night.bt_fire(2600);
                  bt_fire(lati,loni).bt_fire_1231 = g.fire(i).night.bt_fire(1520);
                  t1231(lati,loni).t1231 = g.fire(i).night.t1231';
                  satzenf(lati,loni).satzenf = g.fire(i).night.satzenf;
                  solzenf(lati,loni).solzenf = g.fire(i).night.solzenf;
               end
            else
            end
            nf(lati,loni,i) = NaN;
         end
      end
   end  % if firetrue & firenight & afire
toc
end


% Any fires at all





