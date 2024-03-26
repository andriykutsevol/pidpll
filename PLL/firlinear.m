function accum = firlinear(input, ntaps, h)

global z;
z(1) = input;

accum = 0;

% calc FIR
for i = 1:1:ntaps
    accum = accum + h(i) * z(i);
end

% shift delay line
for i = ntaps:-1:2
    z(i) = z(i-1);
end


end