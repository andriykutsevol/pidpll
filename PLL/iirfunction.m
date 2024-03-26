function [y] = iirfunction(B,A,x)
% Equivalent to 'y = filter(B,A,x)'
% to produce y = (B/A) x

NB = length(B);
NA = length(A);
Nx = length(x);

xv = x(:)

%do the FIR

v = B(1)*xv;
if NB > 1
    for i = 2:min(NB,Nx)
        xdelayed = [zeros(i-1,1); xv(1:Nx-i+1)];
        v = v + B(i)*xdelayed;
    end;
end; %fir par done

y = zeros(length(x), 1);
ac = -A(2:NA);
for i = 1:Nx,
    t = v(i);
    if NA >1,
        for j = 1:NA - 1
           if i<j,
               t = t + ac(j) * y(i-j);
           %else y(i-j) = 0
           end;
        end;
    end;
    y(i) = t;
end;

y = reshape(y,size(x));