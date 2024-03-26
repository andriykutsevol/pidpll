% *** модель PLL для m50 ***
% *** пропорциональный усилитель ***



% alpha = 2.0e-2;
% beta = alpha / 16;


clear all;
close all;

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

global df_ref dp_ref df_vco dp_vco dp_ref_clear dphase_clear

%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
dp_ref_clear = 0;
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;

global sigma_ref;
sigma_ref = 68e-9;       % измерянное осцилографом


%====================================================
%====================================================
%====================================================


%праметры управления

%---------------------------------------------------
% Изменяемые данные

T = 1000;   %длительность моделирования
% alpha = 2e-2;
% beta = alpha / 16;
% gamma = 0;

alpha = 1.53e-3;
beta = 3.053e-3;
gamma = -4.63e-3;

t_freq = 10000;   % Момент времени скачка опорной частоты на 1.0e-07

global rand_test out_test;
rand_test = zeros(T,3);
out_test = zeros(T,5);

%----------------------------------------------------


time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

dphase_clear = 1:T;



%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;


%------------- 
[dphase, dfreq] = pid_loop(alpha, beta , gamma, t_freq);
%-------------

%-------- rand_test

% disp('----rand_test---');
%dlmwrite('./txt/dp_ref_noise',rand_test, 'delimiter','\t');
%dlmwrite('./txt/dp_ref_noise_rand',out_test, 'delimiter','\t');

%------------------

% figure('name','dfreq_hist');
% histfit(dfreq);             % Гистограмма для наглядности.
% [mu, sigma_jitter] = normfit(dfreq)            % Печатаем мат ожидание и СКО на выходе VCO
% 
% disp('--- mu ---');
% mu
% disp('--- mu ---');
% sigma_jitter

%------------------

figure('name','1pps_hist');
histfit(rand_test(:,1));             % Гистограмма для наглядности.
[mu_1pps, sigma_jitter_1pps] = normfit(rand_test(:,1))            % Печатаем мат ожидание и СКО на выходе VCO

% disp('--- mu_1pps ---');
% mu_1pps
% disp('--- sigma_jitter_1pps ---');
% sigma_jitter_1pps

%------------------
% Spectrum

figure('name', 'rand_test(:,1)_spectrum');

plot(abs(fftshift(fft(rand_test(:,1)))).^2);

% fft_var = fft(rand_test(:,1));
% 
% plot(abs(fft_var).^2);

%----------

% figure('name', 'rand_test(:,2)_spectrum');
% 
% fft_var2 = fft(rand_test(:,2));
% 
% plot(abs(fft_var2).^2);


%------------------



figure('name','pi_noise_stat');
hold on
plot(time, dphase, 'r');  % ошибка по фазе - красная 
plot(time, dfreq,'g');  % ошибка по частоте - синяя

figure('name','pi_noise_stat_clear');
hold on
plot(time, dphase_clear, 'r');  % ошибка по фазе - красная 
plot(time, dfreq,'g');  % ошибка по частоте - синяя

%---------------------------------------------------
% print to file
x_file = '/home/andrey/MatLab/fig_pid/pi_noise_stat/report/x.txt';
x_clear_file = '/home/andrey/MatLab/fig_pid/pi_noise_stat/report/x_clear.txt';
dlmwrite(x_file, dphase, '\n');
dlmwrite(x_clear_file, dphase_clear ,'\n');


%---------------------------------------------------
% Изменяемые данные

Tfrom = T - 500;
Tto = T;

%---------------------------------------------------

min(dphase(Tfrom:Tto))
max(dphase(Tfrom:Tto))

mean(dphase(Tfrom:Tto))
std(dphase(Tfrom:Tto))
rms(dphase(Tfrom:Tto))

mean(dfreq(Tfrom:Tto))
std(dfreq(Tfrom:Tto))
rms(dfreq(Tfrom:Tto))
