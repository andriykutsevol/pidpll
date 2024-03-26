% *** модель PLL для m50 ***
% *** пропорциональный усилитель ***

% 1.  ПИД  - без и с шумом
% alfa = 1.53e-3
% betta =  3.053e-6
% gamma = -7.634e-5  (с минусом !!!,  хотя по теории надо плюс)


clear all;

global T dp_ref_noise tt k;

T = 100; %длительность моделирования
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




time = 1:T;    % массив отсчетов времени
%dphase = 1:T;  % массив отчетов разности фаз
%dfreq = 1:T;  % массив отчетов разности частот

% alpha = 7.53e-3;         % коэффициэнт усилителя.
% beta = 3.053e-6;          % коэффициэнт усилителя.
% gamma = -7.634e-5;

global df_ref dp_ref df_vco dp_vco
%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;

global sigma_ref;
sigma_ref = 68e-9;       % измерянное осцилографом

R = 1;
G = 0;
B = 0;


% 1.  ПИД  - без и с шумом
% alfa = 1.53e-3
% betta =  3.053e-6
% gamma = -7.634e-5  (с минусом !!!,  хотя по теории надо плюс)
% 
% 2. ПИД без и с шумом
% оптимальные - твой набор коэффициентов
% 
% 3. ПИ без и с шумом
% оптимальные - твой набор коэффициентов
% 
% В отчете:  графики с указанием коэфф,  уровня шума,
% В приложении:  программа моделирования (все 3 варианта)


%======================================================================
%======================================================================



% П - с шумом и без.

%праметры управления
global a;
a = 1.94;        % [] коэффициент усиления пропорционального усилителя

T = 50;
time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

alpha = 3.0e-2;         % коэффициэнт усилителя.
beta = alpha / 16;      % коэффициэнт усилителя.
gamma = 0;

%----------------------------------
%1)  p_first_instab.eps
%----------------------------------

figure('name','pi_test_1');

for i = 0.5:0.1:1.5
alpha = i

%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;


%------------- 
[dphase, dfreq] = pi_loop(alpha, 0 , 0);
%-------------


hold on;
plot(time, dphase, 'r');  % ошибка по фазе - красная 
plot(time, dfreq,'b');  % ошибка по частоте - синяя

end

%----------------------------------
% 2) pi_0_first_instab.eps
%----------------------------------

% alpha = 0.5
% 
% for i = 0:0.1:1
% 
% beta = i
% 
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
% 
% hold on;
% plot(time, dphase, 'r');  % ошибка по фазе - красная 
% plot(time, dfreq,'b');  % ошибка по частоте - синяя
% 
% end

%----------------------------------
% 3) pi_05_1_1.eps
%----------------------------------

% alpha = 2
% 
% for i = 0:0.1:1
% 
% beta = 0
% 
% %начальные значения
% df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
% dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
% df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
% dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
% x = dp_ref - dp_vco;
% 
% 
% %------------- 
% [dphase, dfreq] = pi_loop((0.6 * 2), 0.6, 0);
% %-------------
% 
% 
% hold on;
% plot(time, dphase, 'r');  % ошибка по фазе - красная 
% plot(time, dfreq,'b');  % ошибка по частоте - синяя
% 
% end

%----------------------------------
% 4)
%----------------------------------

% T = 2;    % Период колебаний
% K = 2;    % Alpha при котором начинаются колебания.
% 0.6 коэффициэнт.
% alpha = K * 0.6;
% beta = 2 * alpha / T;

alpha = 0.6 * 2;
beta = 2 * alpha / 2;


%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;


%------------- 
[dphase, dfreq] = pi_loop(alpha, 0, 0);
%-------------

figure('name','pi_test_2');
hold on;
plot(time, dphase, 'r');  % ошибка по фазе - красная 
plot(time, dfreq,'b');  % ошибка по частоте - синяя


%----------------------------------
% 5)
%----------------------------------



% T = 2;    % Период колебаний
% K = 2;    % Alpha при котором начинаются колебания.
% 0.6 коэффициэнт.
% alpha = K * 0.6;
% beta = 2 * alpha / T;

% alpha = 0.6 * 2;
% %beta = 2 * alpha / 2;
% 
% for i = 1:0.1:1.5
% beta = i;
% %начальные значения
% df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
% dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
% df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
% dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
% x = dp_ref - dp_vco;
% 
% 
% %------------- 
% %[dphase, dfreq] = pi_loop(alpha, beta, 0);
% [dphase, dfreq] = pi_loop(1.94, 0, 0);
% %-------------
% 
% 
% %-------------
% hold on;
% plot(time, dphase, 'Color', [R,G,B]);  % ошибка по фазе - красная 
% %plot(time, dfreq, 'Color', [R,G,B]);   % ошибка по частоте - синяя
% 
% R = R - 0.2;
% B = B + 0.2;
% 
% %-------------
% 
% end










