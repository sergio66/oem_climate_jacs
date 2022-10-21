x1 = ch_emis(1,:);
x2 = rad2bt(fairs(1520),p.rclr_1231)-rad2bt(fairs(1513),p.rclr_1228);
x3 = rad2bt(fairs(1520),p.rclr_1231);
x = double([x1; x2; x3]);

net = fitnet(10,'trainbr');

net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

[net,tr] = train(net,x,y);

% No evaluate full net
yc = net(x);

nanstd(yc-y)
%    0.0642

tsurf_minus_bt1231 = net;
save tsurf_minus_bt1231_net tsurf_minus_bt1231
