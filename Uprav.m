    clc; clear all;
    delete(instrfindall);
    i =1 ;
    s = serial('COM11');
    set(s,'Terminator','','BaudRate',38400);
    set(s,'Timeout',10);
    fopen(s);
    figure ('Position', [100, 100, 800, 600]);

    hLine = plot(NaN, NaN); % Инициализируем пустой график
    xlabel('Время,с');
    ylabel('Значение,Градусы');
    title('График в реальном времени');

    a=0;
    pauseButton = uicontrol('Style', 'pushbutton', 'String', 'Пауза', 'Position', [20 20 60 20], 'Callback', 'pause');

% Создание кнопки "Выход"

exitButton = uicontrol('Style', 'pushbutton', 'String', 'Выход', 'Position', [100 20 60 20], 'Callback', 'close(gcf)');
    
    data1=[ ];
            xData = get(hLine, 'XData');
            yData = get(hLine, 'YData');
 %% для интерфейса
 %figure('Position', [100, 100, 800, 600]);  
    sendButton = uicontrol('Style', 'pushbutton', 'String', 'Отправить', 'Position', [170 20 60 20], 'Callback', 'data_to_send = str2num(get(editField, ''String'')); fwrite(s, data_to_send, ''uint8'');');
    data1=[ ];
            xData = get(hLine, 'XData');
            yData = get(hLine, 'YData');
            
            
            
    grid on;
   % y = sin(x);
    %        plot(x, y);
    % Цикл для получения данных из COM порта и обновления графика
    while ishandle(hLine) % Проверяем, что фигура существует
    data_size = fread(s,2); 
    byte1 = 1;
    byte2 = 10;
%value = uint32(data_size(4))+uint32(data_size(3)) +  uint32(data_size(2)) + uint32(data_size(1));
int_value = typecast(uint8(flipud(data_size)), 'int16');

            xData = [xData, a]; % Добавляем текущее время
            yData = [yData, (int_value/1.39)]; % Добавляем прочитанное число
            set(hLine, 'XData', xData, 'YData', yData);% Обновляем график
            drawnow; % Обновляем фигуру
        a =a+0.016384;
    end
    fclose(s);
    delete(instrfindall);
   
