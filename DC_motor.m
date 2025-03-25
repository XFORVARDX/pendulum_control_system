    clc; clear all;
    delete(instrfindall);
    i =1 ;
    s = serial('COM8');
    set(s,'Terminator','','BaudRate',38400);
    set(s,'Timeout',10);
    fopen(s);
    figure;

    hLine = plot(NaN, NaN); % Инициализируем пустой график
    xlabel('Время,с');
    ylabel('Угловая скорость,Рад/c');
    title('График в реальном времени');

    a=0;
    pauseButton = uicontrol('Style', 'pushbutton', 'String', 'Пауза', 'Position', [200 20 60 20], 'Callback', 'pause');

% Создание кнопки "Выход"
    exitButton = uicontrol('Style', 'pushbutton', 'String', 'Выход', 'Position', [300 20 60 20], 'Callback', 'close(gcf)');
    editField = uicontrol('Style', 'edit', 'Position', [20 20 60 20]);

% Создание кнопки для отправки данных
    sendButton = uicontrol('Style', 'pushbutton', 'String', 'Отправить', 'Position', [100 20 60 20], 'Callback', 'data_to_send = str2num(get(editField, ''String'')); fwrite(s, data_to_send, ''uint8'');');
    data1=[ ];
            xData = get(hLine, 'XData');
            yData = get(hLine, 'YData');
    grid on;
   % y = sin(x);
    %        plot(x, y);
    % Цикл для получения данных из COM порта и обновления графика
    while ishandle(hLine) % Проверяем, что фигура существует
    
    data_size = fread(s,2); 

%value = uint32(data_size(4))+uint32(data_size(3)) +  uint32(data_size(2)) + uint32(data_size(1));
int_value = typecast(uint8(flipud(data_size)), 'int16');
avs = double(int_value);
avs = avs*3.14/(1.39*180);
            xData = [xData, a]; % Добавляем текущее время
            yData = [yData, avs]; % Добавляем прочитанное число
            set(hLine, 'XData', xData, 'YData', yData);% Обновляем график
            drawnow; % Обновляем фигуру
        a =a+0.016384;
    end
    fclose(s);
    delete(instrfindall);