% *** модель PLL для m50 ***
% *** пропорциональный усилитель ***



% alpha = 2.0e-2;
% beta = alpha / 16;


clear all;

global T dp_ref_noise tt k;

dp_ref_noise = 25.0e-9; %[сек]  - амплитуда случайных колебаний фазы опрного сигнала
tt = 100.0e-3;  %[сек] - максимальная случайная задержка выдачи управляющего напряжения на VCO  

%параметры  компонентов
kf = 2.0e-7;  % [1/В]коэффициент преобразования напряжения в отклонение частоты VCO
kv = 5.0e+6;   % [В/сек] коэффициент преобразования отклонения фазы в управляющее напряжение
              % выбран так, чтобы отклонение фазы за секунду
              % компенсировалось полностью
              % для компенсации отклонения в 1е-9 сек - надо изменить частоту на 1е-9
              % тогда k= kv*kf = 1; kv = 1/kf = 1/2.0e-7 = 5e+6 
k = kv * kf;    % =1 - коэффициенaт передачи разность фаз [сек] - управл. напряжение [В] - отклонение частоты относительное []  

global df_ref dp_ref df_vco dp_vco
%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;

global sigma_ref;
sigma_ref = 68e-9;       % измерянное осцилографом


%====================================================
%====================================================
%====================================================


%праметры управления


T = 1000;   %длительность моделирования
time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот


alpha = 2^-3
beta = 2^-9


figure('name','pi_noise_stat');

%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;


%------------- 
[dphase, dfreq] = pid_loop(alpha, beta , 0);
%-------------


hold on;
plot(time, dphase, 'r');  % ошибка по фазе - красная 
plot(time, dfreq,'g');  % ошибка по частоте - синяя

Tfrom = 670;
Tto = T;

min(dphase(Tfrom:Tto))
max(dphase(Tfrom:Tto))

mean(dphase(Tfrom:Tto))
std(dphase(Tfrom:Tto))
rms(dphase(Tfrom:Tto))


% ----------------------------------
%  pid_05_1_1.eps
% ----------------------------------

% figure('name','pi_test_1');
% R = 1;
% G = 0;
% B = 0;
% T = 10000;   %длительность моделирования
% time = 1:T;    % массив отсчетов времени
% dphase = 1:T;  % массив отчетов разности фаз
% dfreq = 1:T;  % массив отчетов разности частот
% 
% beta = 3.053e-6
% gamma = -7.634e-5
% 
% for i = 2.5:0.1:3.5
% alpha = i * 1e-3

% %начальные значения
% df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
% dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
% df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
% dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
% x = dp_ref - dp_vco;
% 
% 
% %------------- 
% [dphase, dfreq] = pi_loop(alpha, beta , 0);
% %-------------
% 
% hold on;
% plot(time, dphase, 'Color', [R,G,B]);  % ошибка по фазе - красная 
% plot(time, dfreq, 'Color', [R,G,B]);  % ошибка по частоте - синяя
% 
% R = R - 0.1;
% B = B + 0.1;
% 
% end