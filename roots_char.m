% Параметры системы
g = 9.8;
l = 0.151;
m = 0.174;
J = m * l^2;       % момент инерции
b = 0.00064;        % коэффициент трения
R_ya = 5;           % сопротивление якоря
L_ya = 670e-6;       % индуктивность якоря
Km = 0.061;          % крутизна двигателя
a = m * g * l;        % возвращающий момент
den = [L_ya*J, L_ya*b + R_ya*J, L_ya*a + R_ya*b + Km^2, R_ya*a];    
poles = roots(den);
disp('Полюса системы:');
disp(poles');
% Отображение полюсов на комплексной плоскости
figure;
zplane([], poles);  
title('Расположение полюсов системы');
grid on;
