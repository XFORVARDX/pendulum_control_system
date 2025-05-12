//setting peripherals
#include "peripherals.c"
#ifndef PERIPHERALS_H
#define PERIPHERALS_H

void setPORTS(void);
void setCLK(void);
void setTimers(void);
void setEXT(void);
void uartconfig(void);
void send_byte(uint8_t byte);
uint8_t calculate_crc(uint8_t *data, uint8_t len) ;
#endif // PERIPHERALS_H
 