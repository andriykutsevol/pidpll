clear

% rng default;
% 
% height = normrnd(50,2,30,1);
% 
% [mu,s,muci,sci] = normfit(height)
% 
% 
% p1 = pdf('Normal',-2:2,0,1)
% 
% plot(-2:2, p1);


% pd = makedist('Normal','mu',75,'sigma',10);
% 
% p = [0.1:0.1:0.9];
% pnew = normcdf(norminv(p,0,1),0,1)

rng('default')

x = [normrnd(0,68e-9,[1,10000])];

figure(1);
histfit(x);

[mu, sigma] = normfit(x)
% входдное сигма 0,68e-9,        мат ожидание 0
% выходное сигма 6.7420e-08      мат ожидание 1.1284e-10


