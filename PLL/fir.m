clear

 x = zeros(1, 12);
 x(6) = 1;
 x
 
 h = [1 2 3 4 5 6]
 % 
 y = filter(h,1,x)

%---------------------

% NTAPS = 1;
% 
% h = 2.0*10^-2;
% 
% imp = 1;
% 
% y = filter(h,1,imp)

%---------------------

%fir_filt_linear_buff.m
% x = [2 4 6 4 2 0 0 0 0 0];
% b = [3 -1 2 1];
% 
% z = zeros(4,1);
% 
% [y,z] = fir_filt_linear_buff(b,x,z)


alpha = 2.0e-2

beta = alpha / 16











   
   



