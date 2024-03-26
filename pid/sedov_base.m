% *** модель PLL для m50 ***
% *** пропорциональный усилитель ***

% Все так.
% В аттаче модель с добавленным отклонением по частоте. С 10-й секунды частота опорного колебания уходит на 1.е-7 мы должны подстроить VCO так, чтобы ошибка по ФАЗЕ стала нулевой (на идеальной модели меньше 1.0е-9, при уходе частоты до ±0.5е-6)
% 
% При а=1:
% - ошибка по частоте становится равной 0 (синий график)
% - ошибка по фазе не равна 0 (1.0е-7красный график)
% 
% Уменьшаем а - а=0.5:
% - ошибка по частоте становится равной 0 (синий график)
% - ошибка по фазе становиться больше (2.0е-7красный график)
% 
% Увеличиваем а - а=1.5:
% - ошибка по частоте становится равной 0 (синий график)
% - ошибка по фазе меньше (0.75е-7красный график)
% и появляются признаки неустойчивости
% 
% 
% Все точно соответствует теории !!!
% Надо добавить интегратор и посмотреть, что будет.


clear all;

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
k = kv * kf;    % =1 - коэффициент передачи разность фаз [сек] - управл. напряжение [В] - отклонение частоты относительное []  

%праметры управления
a = 1;        % [] коэффициент усиления пропорционального усилителя

%начальные значения
df_ref = 0;   % [Гц] отклонение частоты опорного сигнала от идеального сигнала 1Гц
dp_ref = 0;   % [сек] отклонение фазы опорного сигнала от идеального сигнала 1Гц
df_vco = 0;   % [Гц] отклонение частоты генератора от идеального сигнала 1Гц
dp_vco = 0;   % [сек] отклонение фазы генератора от идеального сигнала 1Гц
x = dp_ref - dp_vco;

time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

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

%вывод результатов
hold off;
plot(time, dphase, 'r');  % ошибка по фазе - красная 
hold on;
plot(time, dfreq,'b');  % ошибка по частоте - синяя