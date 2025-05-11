% Параметры системы
g = 9.8;
l = 0.151;
m = 0.174;
Km = 0.061; % крутизна двигателя
R_ya = 5;   % сопротивление якоря
L_ya = 670e-6; % индуктивность якоря
b = 0.00064;   % коэффициент трения

J = m * l^2; % момент инерции
a = m * g * l; % возвращающий момент

% Передаточная функция объекта управления
num = [Km];
den = [L_ya*J, L_ya*b + R_ya*J, L_ya*a + R_ya*b + Km^2, R_ya*a];

sys = tf(num, den);
lb = [0, 0, 0];
ub = [1000, 1000, 1000];

fitnessfcn = @(K) pidfitnessgrid(K, sys);

% Пример одной настройки
options = optimoptions('ga', ...
    'PopulationSize', 100, ...
    'MaxGenerations', 100, ...
    'MutationFcn', {@mutationuniform, 0.1}, ...
    'CrossoverFraction', 0.95, ...
    'Display', 'iter');

[Kopt, Jopt] = ga(fitnessfcn, 3, [], [], [], [], lb, ub, [], options);