function [x,translate] = translator_wrong2correct(JOB,iPrint)

%{
%% see driver_convert_WRONG_latlon_individual_2_CORRECT_latlon.m
%% JOB = 1 : 4608

%%%%%%%%%%%%%%%%%%%%%%%%%
TESTING, noisy
for JOB = 1 : 4608
  x = translator_wrong2correct(JOB,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
TESTING, quiet
for JOB = 1 : 4608
  if mod(JOB,1000) == 0
    fprintf(1,'x');
  elseif mod(JOB,100) == 0
    fprintf(1,'.');
  end

  [x,junk] = translator_wrong2correct(JOB,-1);
  correct.wrongind(JOB)  = junk.wrong;
  correct.name{JOB} = junk.correctname;
  correct.lat(JOB) = junk.correctlat;
  correct.lon(JOB) = junk.correctlon;
end
comment0 = 'see translator_wrong2correct.m';
comment1 = '  so eg if you want sergioindex = 1    = latbin=01,lonbin=01, then you need howard index from correct.wrongind(0001) = 4608 = correct.name{1}    = S90p00_W180p00.nc';
comment2 = '  so eg if you want sergioindex = 1170 = latbin=16,lonbin=18, then you need howard index from correct.wrongind(1170) = 3439 = correct.name{1170} = S44p00_W095p00.nc';
comment3 = '  so eg if you want sergioindex = 2340 = latbin=32,lonbin=36, then you need howard index from correct.wrongind(2340) = 0090 = correct.name{2340} = N00p00_W005p00.nc';
comment4 = '  so eg if you want sergioindex = 3510 = latbin=48,lonbin=54, then you need howard index from correct.wrongind(3510) = 0037 = correct.name{3510} = N44p00_E085p00.nc';
comment5 = '  so eg if you want sergioindex = 4608 = latbin=64,lonbin=72, then you need howard index from correct.wrongind(4608) = 2268 = correct.name{4608} = N81p75_E175p00.nc';
save translator_wrong2correct comment* correct
%%%%%%%%%%%%%%%%%%%%%%%%%
so 
  correctorder_howardfilenames.name{1} = '/asl/isilon/airs/tile_test7/2002_s001/S90p00/tile_2002_s001_S90p00_W180p00.nc'
    correctname(1,:)                   =                                                             'S90p00_W180p00'
    correctorder_howardfilenames.ilat(1) = 1             correctorder_howardfilenames.ilon(1) = 1
    correctorder_howardfilenames.rlon(1) =  -177.5000    correctorder_howardfilenames.rlat(1) =  -85.8750
while  
  wrongorder_howardfilenames_from_dirs.savedirname.fname{1} = '/asl/isilon/airs/tile_test7/2013_s237/N00p00/tile_2013_s237_N00p00_E000p00.nc';
  wrongname(1,:)                                            =                                                             'N00p00_E000p00'
  wrongorder_howardfilenames_from_dirs.savedirname.lon(1) = 2.4996; wrongorder_howardfilenames_from_dirs.savedirname.lat(1) = 1.3768;
  themapWrong2Right(1)                                      = 4608;
  wrongname(themapWrong2Right(1),:)    = 'S90p00_W180p00'
  wrongorder_howardfilenames_from_dirs.savedirname.lon(themapWrong2Right(1)) =  -177.5214
  wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right(1)) =  -84.1662

JOB = 1000;
correctorder_howardfilenames.name{JOB}
wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)}

junk1 = [JOB  correctorder_howardfilenames.ilon(JOB) correctorder_howardfilenames.ilat(JOB) correctorder_howardfilenames.rlon(JOB) correctorder_howardfilenames.rlat(JOB) ];
junk2 = [themapWrong2Right(JOB)  wrongorder_howardfilenames_from_dirs.savedirname.jjj(themapWrong2Right(JOB)) wrongorder_howardfilenames_from_dirs.savedirname.iii(themapWrong2Right(JOB)) ...
                                   wrongorder_howardfilenames_from_dirs.savedirname.lon(themapWrong2Right(JOB)) wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right(JOB))];
fprintf(1,' CORRECT %4i     %s   %2i %2i %8.f4 %8.4f \n',JOB,correctorder_howardfilenames.name{JOB},                                        junk1);
fprintf(1,' WRONG   %4i     %s   %2i %2i %8.f4 %8.4f \n',JOB,wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)},junk2);

%% see translator_wrong2correct.m

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 1
  iPrint = -1;
end

load reorder_indexing.mat

correctorder_howardfilenames.name{JOB};
wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)};
junk1 = [JOB                     correctorder_howardfilenames.ilon(JOB) correctorder_howardfilenames.ilat(JOB) correctorder_howardfilenames.rlon(JOB) correctorder_howardfilenames.rlat(JOB) ];
junk2 = [themapWrong2Right(JOB)  wrongorder_howardfilenames_from_dirs.savedirname.jjj(themapWrong2Right(JOB)) wrongorder_howardfilenames_from_dirs.savedirname.iii(themapWrong2Right(JOB)) ...
                                   wrongorder_howardfilenames_from_dirs.savedirname.lon(themapWrong2Right(JOB)) wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right(JOB))];

x.correctname     = correctorder_howardfilenames.name{JOB};
x.wrong2correct   = wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)};

x.correct_index         = JOB;
%x.wrong2correct_index   = JOB;
x.usethis2map_wrong2correct = themapWrong2Right(JOB);   %%% <<< KEY THING

x.correct_I_J_lon_lat       = junk1(2:5);
x.wrong2correct_I_J_lon_lat = junk2(2:5);

translate.wrong   = themapWrong2Right(JOB);
translate.correct      = JOB;
translate.correctlon   = junk2(4);
translate.correctlat   = junk2(5);
translate.correctname  = wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)};
if iPrint > 0
  fprintf(1,'\n JOB = %4i \n',JOB);
  fprintf(1,' CORRECT x/y=lon/lat %s ind=%4i : %2i %2i %8.4f %8.4f \n',correctorder_howardfilenames.name{JOB},junk1);
  fprintf(1,' WRONG   x/y=lon/lat %s ind=%4i : %2i %2i %8.4f %8.4f \n',wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(JOB)},themapWrong2Right(JOB),junk2(2:5));
end
