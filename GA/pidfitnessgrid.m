function J = pidfitnessgrid(K, sys)
    Kp = K(1); Ki = K(2); Kd = K(3);

    controller = pid(Kp, Ki, Kd);
    closed_loop = feedback(controller * sys, 1);

    try
        [y,t] = step(closed_loop, 20); % моделируем 20 секунд
        e = 1 - y; % ошибка от заданного значения (step = 1)

        IAE = trapz(t, abs(e)); % Интегральная ошибка
        Ts_idx = find(y >= 0.9 & y <= 1.1, 1, 'last');
        if isempty(Ts_idx)
            Ts = Inf;
        else
            Ts = t(Ts_idx);
        end

        Mp = max(y) - 1;
        if Mp < 0
            Mp = 0;
        end

        % Целевая функция
        w1 = 1;   % штраф за ошибку
        w2 = 10;  % штраф за время реакции
        w3 = 50;  % штраф за перерегулирование

        J = w1*IAE + w2*Ts + w3*Mp;

    catch
        J = Inf; % если система не устойчива
    end
end