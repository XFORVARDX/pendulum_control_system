#include <stdio.h>
#include <math.h>
#include <stdint.h> // ��� int32_t

#define FIX16_SCALE 32768 // ��� ������������� ������������� ����� � 16 ������
#define MI_P 3.14159265358979323846
#define samls 256
#define MAXugol 400
int16_t fix16_sin[samls];
int i = 0;
float x = 0;
int16_t sin_ugol[MAXugol];


int generSin() {


    for (i = 0; i < samls; i++) {
        // ����������� i � �������
        x = 2*(3.14 * i) / samls; // x �� -1 �� 1
        // ��������� ����� � ������������ � fix16
        fix16_sin[i] = (int)(sin(x) * FIX16_SCALE);  
        //fix16_sin[i] = sin(x);
    }                                               


    return 0;
}

int k = 0;
int generSinUgol() {


    for (k = 0; k < MAXugol; k++) {
        // ����������� i � �������
        x = ((k-MAXugol>>1)*0.9*3.14) / 180; // x �� -1 �� 1
        // ��������� ����� � ������������ � fix16
        sin_ugol[k] = (int)(sin(x) * FIX16_SCALE );
        //sin_ugol[k] = sin(x) ;     
        
        
    }                                               


    return 0;
}
