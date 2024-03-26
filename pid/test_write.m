clear all


M = [1 1 1 1 1 1]

M1 = [2 2 2 2 2 2]

M2 = [3 3 3 3 3 3]

%dlmwrite('./rand_test3_file',M, 'delimiter','\t');


Z = zeros(6, 3);

Z(1,3) = 2;

Z
