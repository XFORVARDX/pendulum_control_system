function fitness = pidfitnessgrid(K, sys)
    % Извлекаем параметры PID
    Kp = K(1);
    Ki = K(2);
    Kd = K(3);
    
    % Создаем PID-регулятор
    controller = pid(Kp, Ki, Kd);
    
    % Замкнутая система
    closed_loop = feedback(controller * sys, 1);
    
    % Симулируем переходную характеристику
    [y, t] = step(closed_loop, 0:0.01:5);
    
    % Рассчитываем критерии качества
    overshoot = max(y) - 1;  % Перерегулирование
    settling_time = find_settling_time(t, y); % Время установления
    
    % Интегральный критерий ITAE
    error = 1 - y;
    itae = sum(t .* abs(error));
    
    % Фитнес-функция (чем меньше, тем лучше)
    fitness = 0.4*itae + 0.3*overshoot + 0.3*settling_time;
end

function st = find_settling_time(t, y)
    % Находим время установления (в пределах 2% от установившегося значения)
    final_value = y(end);
    idx = find(abs(y - final_value) > 0.02*final_value, 1, 'last');
    if isempty(idx)
        st = 0;
    else
        st = t(idx);
    end
end