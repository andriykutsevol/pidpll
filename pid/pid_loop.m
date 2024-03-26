function [dphase,dfreq] = pi_loop(alpha,beta,gamma, t_freq)

global df_ref dp_ref df_vco dp_vco a;

global T dp_ref_noise tt  k sigma_ref;

global rand_test out_test;

global dphase_clear;


%time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

t = 0;
z = [0 0];
x = 0;
x_clear = 0;
y = 0;
c = [0 0 0];
v = [0 0];
dp_ref_clear = 0;

%--------------

%моделирование
for t = 1:T   % время  [sec]
    %начало секунды
    
    % -------- P
     %y = x * a;          % управляющее напряжение VCO 
     %-------- PI
     %z(2) = beta * x + z(1);
     %y = alpha * x + z(2);          % управляющее напряжение VCO 
     %z(1) = z(2);
     %-------- PI
     %v(2) = (alpha + beta)*c(3) - alpha*c(2) + v(1);
     %-------- PID
     v(2) = (alpha + beta + gamma)*c(3) - (alpha + 2*gamma)*c(2) + gamma*c(1) + v(1);
     v(1) = v(2);
    %---------------------------------
    
    %df_vco = k * y;     % установлено новое отклонение частоты
    df_vco = k * v(2);
    
    rand_test(t,1) = normrnd(0, sigma_ref);
    rand_test(t,2) = unifrnd(0, tt);
    rand_test(t,3) = (1 - unifrnd(0, tt));
    
    dp_ref = dp_ref + df_ref + rand_test(t,1);% + rand_test(t,1);  % набег фазы опорного сигнала за 1 сек из-за отклонения частоты
    dp_ref_clear = dp_ref_clear + df_ref;
    dp_vco = dp_vco + df_vco;% * rand_test(t,3);% набег фазы генератора за 1 сек из-за отклонения частоты 
    % в конце секунды 
    x =  dp_ref - dp_vco;       % фазовый детектор запоминает разность фаз в сек для следующей секунды вычислений
    x_clear = dp_ref_clear - dp_vco;
    
    out_test(t,1) = dp_ref;
    out_test(t,2) = dp_vco;
    out_test(t,3) = df_ref;
    out_test(t,4) = df_vco;
    out_test(t,5) = x;
    
%     if x < 0
%         c = [c(2:end) c(3)];
%         dphase (t) = c(3);    
%     else
        c = [c(2:end) x];
        dphase (t) = x;
        dphase_clear(t) = x_clear;
%      end
    
    dfreq(t)=df_ref - df_vco;
    
    if t >= t_freq
        %df_ref = 1.0e-7; % скачок частоты на 10-й секунде
        
        %dp_ref = dp_ref + df_ref  - будет все время накаприваться
        %dp_vco = dp_vco + k * v(2) будет его компенсировать.
        %x =  dp_ref - dp_vco;  - смотрим на их разность.
        
        %df_vco = df_vco + 1.0e-7;
    else
    end 
end