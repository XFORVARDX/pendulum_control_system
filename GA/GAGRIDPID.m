% Параметры системы
% можно на Pythone, но нравится MATLAB
g = 9.8;
l = 0.151;
m = 0.174;
Km = 0.061;
R_ya = 5;
L_ya = 670e-6;
b = 0.00064;

J = m * l^2; % момент инерции
a = m * g * l; % возвращающий момент

% Передаточная функция замкнутой системы
num = [Km];
den = [L_ya*J, L_ya*b + R_ya*J, L_ya*a + R_ya*b + Km^2, R_ya*a];

sys = tf(num, den);% Параметры генетического алгоритма
options = optimoptions('ga', ...
    'PopulationSize', 50, ...
    'MaxGenerations', 100, ...
    'CrossoverFraction', 0.8, ...
    'MutationFcn', {@mutationadaptfeasible, 0.1}, ...
    'Display', 'iter', ...
    'PlotFcn', {@gaplotbestf, @gaplotstopping});

% Запуск генетического алгоритма
[K_opt, fval] = ga(@(K) pidfitnessgrid(K, sys), 3, [], [], [], [], lb, ub, [], options);

% Оптимальные коэффициенты
Kp = K_opt(1);
Ki = K_opt(2);
Kd = K_opt(3);
% Создаем оптимальный регулятор
controller = pid(K_opt(1), K_opt(2), K_opt(3));
closed_loop = feedback(controller * sys, 1);
step(closed_loop);
grid on;
title('Переходная характеристика с оптимальным PID-регулятором');