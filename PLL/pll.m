clear
% NTAPS = 6;
% h = [1 2 3 4 5 6];


NTAPS = 1;

h = 2.0*10^-2;

IMP_SIZE = 3 * NTAPS;
imp = zeros(1, IMP_SIZE);
imp(1) = 1;



global z
z = zeros(1, 2 * NTAPS);

for i = 1:1:IMP_SIZE
    c = firlinear(imp(i), NTAPS, h);
    c
end



% global s dim;
% dim = 5;
% s = zeros(1,5);
% s
% 
% s(1) = 3;
% dealay();
% s
% 
% s(1) = 7;
% dealay();
% s
% 
% s(1) =  9;
% dealay();
% s
% 
% s(1) = 8;
% dealay();
% s
% 
% s(1) = 4;
% dealay();
% s




