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

sys = tf(num, den);
% Границы коэффициентов регулятора
lb = [0, 0, 0];
ub = [1000, 1000, 1000];

options = optimoptions('ga', ...
    'Display', 'iter', ...
    'PlotFcn', {@gaplotbestf, @gaplotscorediversity}, ...
    'PopulationSize', 50, ...
    'MaxGenerations', 50, ...
    'FunctionTolerance', 1e-4, ...
    'ConstraintTolerance', 1e-4);

% Запуск ГА
[Kopt, Jopt] = ga(@(K) pidfitness(K, sys), 3, [], [], [], [], lb, ub, [], options);

disp(['Оптимальные коэффициенты ПИД: Kp = ', num2str(Kopt(1)), ...
      ', Ki = ', num2str(Kopt(2)), ', Kd = ', num2str(Kopt(3))]);