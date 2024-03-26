function [dphase,dfreq] = pi_loop(alpha,beta,gamma)

global df_ref dp_ref df_vco dp_vco a;

global T dp_ref_noise tt  k sigma_ref;


%time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

t = 0;
z = [0 0];
x = 0;
y = 0;

%--------------

%моделирование
for t = 1:T   % время  [sec]
    %начало секунды
    
    % ---------- Усилитель -----------
     z(2) = beta * x + z(1);
     y = alpha * x + z(2);          % управляющее напряжение VCO 
     z(1) = z(2);
     
     %y(2) = (alpha + beta)*x(1) - alpha*x(2) + y(1);
     
    %---------------------------------
    
    df_vco = k * y;     % установлено новое отклонение частоты
    dp_ref = dp_ref + df_ref;% + normrnd(0, sigma_ref);  % набег фазы опорного сигнала за 1 сек из-за отклонения частоты
    dp_vco = dp_vco + df_vco;% * (1 - unifrnd(0, tt));  % набег фазы генератора за 1 сек из-за отклонения частоты 
    % в конце секунды 
    x =  dp_ref - dp_vco;       % фазовый детектор запоминает разность фаз в сек для следующей секунды вычислений
    dphase (t) = x;
    dfreq(t)=df_ref - df_vco;
    
    %fprintf(dfreq_file,'%f\n',dfreq(t));
    if t >= 10
        df_ref = 1.0e-7; % скачок частоты на 10-й секунде
        %df_vco = df_vco + 1.0e-7;
    else
    end 
end