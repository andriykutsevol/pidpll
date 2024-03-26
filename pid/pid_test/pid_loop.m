function [dphase,dfreq] = pid_loop(alpha,beta,gamma)

global df_ref dp_ref df_vco dp_vco a;

global T dp_ref_noise tt  k sigma_ref;


%time = 1:T;    % массив отсчетов времени
dphase = 1:T;  % массив отчетов разности фаз
dfreq = 1:T;  % массив отчетов разности частот

t = 0;
z = 0;
x = [ 0 0 0 ];
y = [ 0 0 ];

%моделирование
for t = 1:T   % время  [sec]
    %начало секунды
    %y = x * a;          % управляющее напряжение VCO 
    
    % ---------- Фильтр -----------
     
     %c(2) = beta * x(1) + c(1);
     %y(2) = alpha * x(1) + c(2);          % управляющее напряжение VCO 
     %c(1) = c(2);
     
    %---------------------------------
    % ПИД регулятор.
    
    y(2) = (alpha + beta + gamma)*x(3) - (alpha + 2*gamma)*x(2) + gamma*x(3) + y(1);
    %y(2) = (alpha + beta)*x(1) - alpha*x(2) + y(1);
    y(1) = y(2);
    
    
    df_vco = k * y(2);     % установлено новое отклонение частоты
    dp_ref = dp_ref + df_ref; %+ normrnd(0, sigma_ref);  % набег фазы опорного сигнала за 1 сек из-за отклонения частоты
    dp_ref = dp_ref + df_ref; % + unifrnd(-dp_ref_noise, +dp_ref_noise);  % набег фазы опорного сигнала за 1 сек из-за отклонения частоты     
    dp_vco = dp_vco + df_vco; % * (1 - unifrnd(0, tt));  % набег фазы генератора за 1 сек из-за отклонения частоты 
    % в конце секунды 
    z =  dp_ref - dp_vco;       % фазовый детектор запоминает разность фаз в сек для следующей секунды вычислений

% Условие на знак разности фаз закомментировано

    % Условие на знак разности фаз.
%    if z < 0
%         x = [x(2:end) x(3)]      % Конкаттерация вектора. В начало добавляем предидущий элемент
%         dphase(t) = x(1);
%    else
          x = [x(2:end) z]         % Конкаттенация вектора. В начало добавляем вновь вычисленный элемент.
          dphase(t) = z;
%    end
    
    dfreq(t)=df_ref - df_vco;
   
    if t >= 5
        df_ref = 1.0e-7; % скачок частоты на 10-й секунде
    else
    end 
end