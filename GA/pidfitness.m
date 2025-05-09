function J = pidfitness(K, sys)
    Kp = K(1); Ki = K(2); Kd = K(3);

    controller = pid(Kp, Ki, Kd);
    closed_loop = feedback(controller * sys, 1);

    try
        [y,t] = step(closed_loop, 20); % моделируем 20 секунд
        e = 1 - y; % ошибка от заданного значения (step = 1)

        IAE = trapz(t, abs(e)); % Интегральная ошибка
        Ts = t*(find(y >= 0.9 & y <= 1.1, 1, 'last')) - t*(find(y >= 0.9 & y <= 1.1, 1, 'first'));

        overshoot = max(y) - 1;
        if overshoot < 0
            overshoot = 0;
        end

        % Весовые коэффициенты целевой функции
        J = IAE + 10 * Ts(end) + 50 * overshoot;
    catch
        J = Inf; % если система не устойчива — штраф
    end
end