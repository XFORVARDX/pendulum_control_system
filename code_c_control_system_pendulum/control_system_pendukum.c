/*******************************************************
This program was created by the CodeWizardAVR V3.27 
Automatic Program Generator
 Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com
Project : NIRcode
Version : 
Date    : 17.04.2024
Author  : 
Company : 
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
#include "createmassiveSIN.h"
#define dt 0.0163


int ugol = 0;
unsigned char byte1,byte2,byte3,byte4 ;
int32_t result = 0;    // результат функции 
//задаем параметры функции синуса(из которой будем получать ошибку) y = A*sin(T*t)
int32_t A = 60 ;//амплитуда , потом будем задавать матлабом 
int T = 1 ; // период , потом будем принимать с матлаба 
int32_t error = 0;// для расчета ошибки 
int time12 = 0;
int flag = 0;

float integral = 0;       // Интегральная составляющая
float previous_error = 0; // Предыдущее значение ошибки
float derivative;
//коэффициенты ПИД регулятора
int Kp = 200;
int Ki = 20;
int Kd = 50;
uint8_t flagPWM = 0;
float Y = 0 ;
uint16_t pwm_value = 0;
int datay[] ={0, 84, 91, 14, -76, -96, -28, 
66, 99, 41, -54, -84, -54, 
42, 99, 65, -26, -96, -84, 
-1, 91, 84, -26, -65, -99,
-42, 54, 84, 54, -41, -99,
-66, 28, 96, 76, -14, -91,
-84, 0 }     ;
float my_abs(float value) {
    return (value < 0) ? -value : value;
}


// Declare your global variables here

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
if (PINB.4 == 1)
{     
  //ugol++;    
  
}
else
{
  //ugol--;
}

}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)

{       
          
//sprintf(buffer, "%d", ugol);
//                    
//        puts(buffer);   

        byte1 = (ugol >> 8) & 0xFF;
        byte2 = ugol & 0xFF;  
        putchar(0x1c);
        putchar(byte1);   
        putchar(byte2);        
        byte1 = (pwm_value >> 8) & 0xFF;
        byte2 = pwm_value & 0xFF; 
        putchar(0x2d); 
        putchar(byte1);   
        putchar(byte2);
        byte4 = (error >> 24) & 0xFF;      
        byte3 = (error >> 16) & 0xFF;
        byte1 = (error >> 8) & 0xFF;
        byte2 = error & 0xFF; 
        putchar(0x2c);   
        putchar(byte4);    
        putchar(byte3);
        putchar(byte1);   
        putchar(byte2);    
        time12=time12+100; 
        if(time12>16128)time12 = 0;      
        //PORTB &= ~(1 << PORTB5);    
}
// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 16,384 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;


// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);


// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
EIMSK=(0<<INT1) | (1<<INT0);
EIFR=(0<<INTF1) | (1<<INTF0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x19;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Ph. correct PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,255 ms
// Output Pulse(s):
// OC1A Period: 0,255 ms Width: 0,127 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0xFF;
OCR1AL=0xFA;
OCR1BH=0x00;
OCR1BL=0x00;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
#asm("sei")
PIND.6=0;
PORTB.5 = 1;
PORTD.7 = 0;
PORTB.1 = 1; 
//сделай график управления в режиме реального времени
generSin();
generSinUgol();


while (1)
    {  
    // result =A*datay[5];          
    if(time12>16128)time12 =0;
    result = A*(fix16_sin[(time12>>6)]);  
    //result = 1966080;
    //result =  A*sin(0.016384*T*time12*2*PI);   
    error = (A*((sin_ugol[ugol>>1])) -  result)/100;
    //error =((int16_t)(A*sin(ugol/1.39*PI/180))) - result;
    //error = (int16_t)(error>>2);    
    // Вычисление интегральной составляющей
    integral += error * dt;
    // Вычисление дифференциальной составляющей
    derivative = error - previous_error; 
    Y = (uint16_t)(my_abs(Kp * error + Ki * integral + Kd * derivative));    
    pwm_value = (Y); // Преобразование float в uint16_t         
    //error = 1;                   
                    //OCR1AH = 0xFF; // Высший байт
               
    //OCR1AL = 254;  
        if (Y > 65535) {
            Y = 65535;  
            
        }    
        if ((error<-1) && (flagPWM == 0)){   
            flagPWM = 1; 
            PORTD.7 = 0;  
            PIND.6=1;    
            if(Y <= 65535){      
               //#asm("cli")
               OCR1AH = (65535 >> 8) & 0xFF; // Высший байт
               OCR1AL = 65535 & 0xFF; // Нижний байт  
               //#asm("sei")     
            }  
        }
            else if((error>1) && (flagPWM == 1)){    
            flagPWM = 0;
            PORTD.7 = 1;  
            PIND.6 = 0; 
            if(Y <= 65535) {  
                //#asm("cli")
                OCR1AH = (65535 >> 8) & 0xFF; // Высший байт
                OCR1AL = 65535 & 0xFF; // Нижний байт   
                //#asm("sei")      
            } 
            else {
                //OCR1BH = 0; 
                //OCR1BL = 0;
                previous_error = 0;    
            }
        }        
    previous_error =  error;
    // OCR1AH = 0;
      
    }
}






