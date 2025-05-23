/*******************************************************
This program was created by the CodeWizardAVR V3.27 
Project : DIPLOM
Version : 
Date    : 17.04.2024
Author  : FORVARD
Company : KB52
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <io.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include <mega328p.h>
#include <peripherals.h>
#include "createmassiveSIN.h"
#define dt 0.0163


volatile int ugol = 0;
unsigned char byte1,byte2,byte3,byte4 ;
int32_t result = 0;    // ��������� ������� 
//������ ��������� ������� ������(�� ������� ����� �������� ������) y = A*sin(T*t)
int32_t A = 60 ;//��������� , ����� ����� �������� �������� 
int T = 3 ; // ������ , ����� ����� ��������� � �������    //3~0.684 ms  ������ ���������� � 2 ����
int32_t error = 0;// ��� ������� ������ 
int time12 = 0;
int flag = 0;

int32_t integral = 0;       // ������������ ������������
int32_t previous_error = 0; // ���������� �������� ������
int32_t derivative;
//������������ ��� ����������
int16_t Kp = 200;
int16_t Ki = 0;
int16_t Kd = 1;
uint8_t flagPWM = 0;
uint32_t pwm_value = 0;
uint32_t my_abs(int32_t value) {
    return (value < 0) ? -value : value;
}
uint8_t flagT = 0   ;
uint8_t flagA = 0   ;
uint8_t flagP = 0   ;
uint8_t flagI = 0   ;
uint8_t flagD = 0   ;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
                  //PORTB ^= (1 << PORTB5); // ������������ ��������� ���������� L (PB5)
if (PINB.4 == 1)
{     
  ugol++;    
}
else
{
  ugol--;
}
EIFR |= (1 << INTF0); // ��������� ����� INTF0 ��� ������ ���������� INT0
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)

{       
        //PORTB ^= (1 << PORTB5); // ������������ ��������� ���������� L (PB5)

        byte1 = (ugol >> 8) & 0xFF;
        byte2 = ugol & 0xFF;  
        putchar(0x1c);   // ��������� ��� ������ ����
        putchar(byte1);   
        putchar(byte2);        
        byte1 = (pwm_value >> 8) & 0xFF;
        byte2 = pwm_value & 0xFF; 
        putchar(0x2d);  // ��������� ��� ������ ����������
        putchar(byte1);   
        putchar(byte2);
        byte4 = (error >> 24) & 0xFF;      
        byte3 = (error >> 16) & 0xFF;
        byte1 = (error >> 8) & 0xFF;
        byte2 = error & 0xFF; 
        putchar(0x2c);       // ��������� ��� ������        
        putchar(byte4);    
        putchar(byte3);
        putchar(byte1);   
        putchar(byte2);    
        time12=time12+100; 
        if(time12>(samls*(1<<T)))time12 = 0;
        if(time12>16128)time12 =0;
        
        //cordic
        //PORTB ^= (1 << PORTB5); // ������������ ��������� ���������� L (PB5)

        //result =  A*sin(0.016384*T*time12*2*PI);   
        //error = (A*((sin_ugol[ugol>>1])) -  result)/100;
        //error =((int16_t)(A*sin(ugol/1.39*PI/180))) - result;
        //    //error = (int16_t)(error>>2);    
        result = A*(fix16_sin[(time12>>T)]);  
        error = (A*((sin_ugol[ugol>>1])) -  result)/100;
        // ���������� ������������ ������������
        integral += error * dt;
        // ���������� ���������������� ������������
        derivative = error - previous_error; 
        pwm_value = (my_abs(Kp * error + Ki * integral + Kd * derivative)/10);   
       

        if (pwm_value > 65535) {
            pwm_value = 65535;  
            
        }    
        if (error<0){   
            
            if(flagPWM == 0){
            flagPWM = 1;
            PORTD.7 = 0;  
            PIND.6=1;        
            }
            if(pwm_value <= 65535){      
               OCR1AH = (pwm_value >> 8) & 0xFF; // ������ ����
               OCR1AL = pwm_value & 0xFF; // ������ ����    
            }  
        }
            else if(error>0){   
            if(flagPWM == 1)
            { 
            flagPWM = 0;     
            PORTD.7 = 1;  
            PIND.6 = 0; 
            }
            if(pwm_value <= 65535) {  
                OCR1AH = (pwm_value >> 8) & 0xFF; // ������ ����
                OCR1AL = pwm_value & 0xFF; // ������ ����       
            } 
            else {
                OCR1BH = 0; 
                OCR1BL = 0;
               previous_error = 0;    
            }

        }        
    previous_error =  error;
    //PORTB ^= (1 << PORTB5); // ������������ ��������� ���������� L (PB5) 
}
// Declare your global variables here
interrupt[USART_RXC] void usartRX_data(void) {
    // ������ ��������� ����� �� �������� UDR0    
    uint8_t received_data = UDR0;   
    if(received_data == 0x0A){
        flagA = 1;
    }  
    if(flag == 1){
        A = received_data; 
        flagA = 0;
    }   
    if(received_data == 0x0B){
        flagT = 1;
    }  
    if(flagT == 1){
        T = (received_data<<8); 
        flagT = 2;
    }  
    if(flagT == 2){
        T = T+received_data; 
        flagT = 0;
    }    
    if(received_data == 0x1A){
        flagP = 1;
    }  
    if(flagP == 1){
        Kp = (received_data<<8); 
        flagP = 2;
    }  
    if(flagP == 2){
        Kp = Kp + received_data; 
        flagP = 0;
    }    
    if(received_data == 0x1B){
        flagI = 1;
    }  
    if(flagI == 1){
        Ki = (received_data<<8); 
        flagI = 2;
    }  
    if(flagI == 2){
        Ki = Ki + received_data; 
        flagI = 0;
    }  
    if(received_data == 0x1F){
        flagD = 1;
    }  
    if(flagD == 1){
        Kd = (received_data<<8); 
        flagD = 2;
    }  
    if(flagD == 2){
        Kd = Kd + received_data; 
        flagD = 0;
    }  
}


void main(void)
{
    
    //peripherals config
    setCLK();
    setPORTS();
    setTimers();   
    setEXT();
    uartconfig();


    #asm("sei")
    PIND.6=0;
    PORTB.5 = 0;
    PORTD.7 = 0;
    PORTB.1 = 1; 
    generSin();        // ������������� ������� ������ 
    generSinUgol();
    PORTD.7 = 1;  
    PIND.6 = 0; 
    OCR1BH = 244; 
    OCR1BL = 244;


    while (1)
    {  
    
        // result =A*datay[5];          
        //    if(time12>16128)time12 =0;
        //    result = A*(fix16_sin[(time12>>6)]);  
        //    //result = 1966080;
        //    //result =  A*sin(0.016384*T*time12*2*PI);   
        //    error = (A*((sin_ugol[ugol>>1])) -  result)/100;
        //    //error =((int16_t)(A*sin(ugol/1.39*PI/180))) - result;
        //    //error = (int16_t)(error>>2);    
        //    // ���������� ������������ ������������
        //    integral += error * dt;
        //    // ���������� ���������������� ������������
        //    derivative = error - previous_error; 
        //    pwm_value = (my_abs(Kp * error + Ki * integral + Kd * derivative)/100);    
        //    //pwm_value = (Y); // �������������� float � uint16_t         
        //    //error = 1;                   
        //                    //OCR1AH = 0xFF; // ������ ����
        //               
        //    //OCR1AL = 254;  
        //        if (pwm_value > 65535) {
        //            pwm_value = 65535;  
        //            
        //        }    
        //        if (error<0){   
        //            flagPWM = 1; 
        //            PORTD.7 = 0;  
        //            PIND.6=1;    
        //            if(pwm_value <= 65535){      
        //               //#asm("cli")
        //               OCR1AH = (pwm_value >> 8) & 0xFF; // ������ ����
        //               OCR1AL = pwm_value & 0xFF; // ������ ����  
        //               //#asm("sei")     
        //            }  
        //        }
        //            else if(error>0){    
        //            flagPWM = 0;
        //            PORTD.7 = 1;  
        //            PIND.6 = 0; 
        //            if(pwm_value <= 65535) {  
        //                //#asm("cli")
        //                OCR1AH = (pwm_value >> 8) & 0xFF; // ������ ����
        //                OCR1AL = pwm_value & 0xFF; // ������ ����   
        //                //#asm("sei")      
        //            } 
        //            else {
        //                //OCR1BH = 0; 
        //                //OCR1BL = 0;
        //                previous_error = 0;    
        //            }
        //        }        
        //    previous_error =  error;
        //    // OCR1AH = 0;
      
    }
}






