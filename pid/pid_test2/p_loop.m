function [dphase,dfreq] = p_loop()

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
    y = x * a;          % управляющее напряжение VCO 
    df_vco = k * y;     % установлено новое отклонение частоты
    dp_ref = dp_ref + df_ref; % + unifrnd(-dp_ref_noise, +dp_ref_noise);  % набег фазы опорного сигнала за 1 сек из-за отклонения частоты     
    dp_vco = dp_vco + df_vco; % * (1 - unifrnd(0, tt));  % набег фазы генератора за 1 сек из-за отклонения частоты 
    % в конце секунды 
    x =  dp_ref - dp_vco;       % фазовый детектор запоминает разность фаз в сек для следующей секунды вычислений
    dphase (t) = x;
    dfreq(t)=df_ref - df_vco;
   
    if t >= 10
        df_ref = 1.0e-7; % скачок частоты на 10-й секунде
    else
    end 
end