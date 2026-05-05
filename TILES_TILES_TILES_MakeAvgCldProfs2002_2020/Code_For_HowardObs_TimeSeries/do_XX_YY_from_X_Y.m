load latB64.mat
rlat65 = latB2; rlon73 = -180 : 5 : +180;
rlon = -180 : 5 : +180;  rlat = latB2;
rlon = 0.5*(rlon(1:end-1)+rlon(2:end));
rlat = 0.5*(rlat(1:end-1)+rlat(2:end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Y,X] = meshgrid(rlat,rlon);
X = X; Y = Y;

XX = X'; XX = XX(:); XX = XX';   %%%% MUST BE WRONG!T MUST BE WRONG!T MUST BE WRONG!T MUST BE WRONG!T 
YY = Y'; YY = YY(:); YY = YY';   %%%% MUST BE WRONG!T MUST BE WRONG!T MUST BE WRONG!T MUST BE WRONG!T 

XX = X;  XX = XX(:); XX = XX';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT
YY = Y;  YY = YY(:); YY = YY';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Y65,X73] = meshgrid(rlat65,rlon73);

XX73 = X73;  XX73 = XX73(:); XX73 = XX73';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT
YY65 = Y65;  YY65 = YY65(:); YY65 = YY65';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT

