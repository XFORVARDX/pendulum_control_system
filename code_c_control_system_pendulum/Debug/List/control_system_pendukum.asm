
;CodeVisionAVR C Compiler V3.27 Evaluation
;(C) Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R3
	.DEF _i_msb=R4
	.DEF _k=R5
	.DEF _k_msb=R6
	.DEF _byte1=R8
	.DEF _byte2=R7
	.DEF _byte3=R10
	.DEF _byte4=R9
	.DEF _T=R11
	.DEF _T_msb=R12
	.DEF _time12=R13
	.DEF _time12_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usartRX_data
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x3,0x0,0x0,0x0

_0xF:
	.DB  0x3C
_0x10:
	.DB  0xC8
_0x11:
	.DB  0x1
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _A
	.DW  _0xF*2

	.DW  0x01
	.DW  _Kp
	.DW  _0x10*2

	.DW  0x01
	.DW  _Kd
	.DW  _0x11*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the CodeWizardAVR V3.27
;Project : DIPLOM
;Version :
;Date    : 17.04.2024
;Author  : FORVARD
;Company : KB52
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;#include <math.h>
;#include <stdint.h>
;#include <mega328p.h>
;#include <peripherals.h>
;
;
;void setPORTS(void){
; 0000 001A void setPORTS(void){

	.CSEG
_setPORTS:
; .FSTART _setPORTS
;    // Port B initialization
;    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
;    DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(51)
	OUT  0x4,R30
;    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
;    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
;
;    // Port C initialization
;    // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
;    DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
;    // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
;    PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
;
;    // Port D initialization
;    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
;    DDRD=(1<<DDD7) | (1<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(194)
	OUT  0xA,R30
;    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
;    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(4)
	OUT  0xB,R30
;
;}
	RET
; .FEND
;
;void setCLK(void){
_setCLK:
; .FSTART _setCLK
;    // Crystal Oscillator division factor: 1
;    #pragma optsize-
;    CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
;    CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
;    #ifdef _OPTIMIZE_SIZE_
;    #pragma optsize+
;    #endif
;}
	RET
; .FEND
;
;void setTimers(void){
_setTimers:
; .FSTART _setTimers
;    // Timer/Counter 0 initialization
;    // Clock source: System Clock
;    // Clock value: 15,625 kHz
;    // Mode: Normal top=0xFF
;    // OC0A output: Disconnected
;    // OC0B output: Disconnected
;    // Timer Period: 16,384 ms
;    TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
;    TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x25,R30
;    TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;    OCR0A=0x00;
	OUT  0x27,R30
;    OCR0B=0x00;
	OUT  0x28,R30
;
;
;    // Timer/Counter 0 Interrupt(s) initialization
;    TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
;
;
;    // Timer/Counter 1 initialization
;    // Clock source: System Clock
;    // Clock value: 2000,000 kHz
;    // Mode: Ph. correct PWM top=0x00FF
;    // OC1A output: Non-Inverted PWM
;    // OC1B output: Disconnected
;    // Noise Canceler: Off
;    // Input Capture on Falling Edge
;    // Timer Period: 0,255 ms
;    // Output Pulse(s):
;    // OC1A Period: 0,255 ms Width: 0,127 ms
;    // Timer1 Overflow Interrupt: Off
;    // Input Capture Interrupt: Off
;    // Compare A Match Interrupt: Off
;    // Compare B Match Interrupt: Off
;    TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(131)
	STS  128,R30
;    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	STS  129,R30
;    TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
;    TCNT1L=0x00;
	STS  132,R30
;    ICR1H=0x00;
	STS  135,R30
;    ICR1L=0x00;
	STS  134,R30
;    OCR1AH=0xFF;
	LDI  R30,LOW(255)
	STS  137,R30
;    OCR1AL=0xFA;
	LDI  R30,LOW(250)
	STS  136,R30
;    OCR1BH=0x00;
	RCALL SUBOPT_0x0
;    OCR1BL=0x00;
;    // Timer/Counter 1 Interrupt(s) initialization
;    TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
;
;}
	RET
; .FEND
;void setEXT(void){
_setEXT:
; .FSTART _setEXT
;    // External Interrupt(s) initialization
;    // INT0: On
;    // INT0 Mode: Rising Edge
;    // INT1: Off
;    // Interrupt on any change on pins PCINT0-7: Off
;    // Interrupt on any change on pins PCINT8-14: Off
;    // Interrupt on any change on pins PCINT16-23: Off
;    EICRA=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(3)
	STS  105,R30
;    EIMSK=(0<<INT1) | (1<<INT0);
	LDI  R30,LOW(1)
	OUT  0x1D,R30
;    EIFR=(0<<INTF1) | (1<<INTF0);
	OUT  0x1C,R30
;    PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(0)
	STS  104,R30
;}
	RET
; .FEND
;
;void uartconfig(void){
_uartconfig:
; .FSTART _uartconfig
;
;    // USART initialization
;    // Communication Parameters: 8 Data, 1 Stop, No Parity
;    // USART Receiver: Off
;    // USART Transmitter: On
;    // USART Mode: Asynchronous
;
;    // Настройка UART на скорость 115200
;    UCSR0A = (1 << U2X0);  // Включение режима двойной скорости (если требуется)
	LDI  R30,LOW(2)
	STS  192,R30
;    UCSR0B = (0 << RXCIE0) | (0 << TXCIE0) | (0 << UDRIE0) | (0 << RXEN0) | (1 << TXEN0) | (0 << UCSZ02) | (0 << RXB80)  ...
	LDI  R30,LOW(8)
	STS  193,R30
;    UCSR0C = (0 << UMSEL01) | (0 << UMSEL00) | (0 << UPM01) | (0 << UPM00) | (0 << USBS0) | (1 << UCSZ01) | (1 << UCSZ00 ...
	LDI  R30,LOW(6)
	STS  194,R30
;
;    // Установка baud rate
;    UBRR0H = 0x00;  // Старший байт UBRR0
	LDI  R30,LOW(0)
	STS  197,R30
;    UBRR0L = 0x10;  // Младший байт UBRR0 (для U2X0 = 1)
	LDI  R30,LOW(16)
	STS  196,R30
;    // Включение приемника и передатчика
;    UCSR0B = (1 << RXEN0) | (1 << TXEN0)| (1 << RXCIE0);;
	LDI  R30,LOW(152)
	STS  193,R30
;    //// Включение прерывания по завершению приема данных (RX Complete)
;    UCSR0B |= (1 << RXCIE0);
	LDS  R30,193
	ORI  R30,0x80
	STS  193,R30
;}
	RET
; .FEND
;
;void send_byte(uint8_t byte){
_send_byte:
; .FSTART _send_byte
;    while (!(UCSR0A & (1 << UDRE0))); // ждём готовности
	ST   -Y,R17
	MOV  R17,R26
;	byte -> R17
_0x3:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x3
;    UDR0 = byte;
	RJMP _0x20A0002
;}
; .FEND
;// === Расчёт CRC8 ===
;uint8_t calculate_crc(uint8_t *data, uint8_t len) {
_calculate_crc:
; .FSTART _calculate_crc
;    uint8_t crc = 0;
;    int i;
;    for ( i = 0; i < len; i++) {
	RCALL __SAVELOCR6
	MOV  R16,R26
	__GETWRS 20,21,6
;	*data -> R20,R21
;	len -> R16
;	crc -> R17
;	i -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x7:
	MOV  R30,R16
	MOVW R26,R18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x8
;        crc = data[i] ^ crc;
	MOVW R30,R18
	ADD  R30,R20
	ADC  R31,R21
	LD   R30,Z
	EOR  R17,R30
;    }
	__ADDWRN 18,19,1
	RJMP _0x7
_0x8:
;    return crc;
	MOV  R30,R17
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;}
; .FEND
;#include "createmassiveSIN.h"
_generSin:
; .FSTART _generSin
	CLR  R3
	CLR  R4
_0xA:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CP   R3,R30
	CPC  R4,R31
	BRGE _0xB
	__GETW1R 3,4
	RCALL __CWD1
	RCALL __CDF1
	RCALL SUBOPT_0x1
	__GETD2N 0x40000000
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43800000
	RCALL SUBOPT_0x2
	__GETW1R 3,4
	RCALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	RJMP _0xA
_0xB:
	RJMP _0x20A0003
; .FEND
_generSinUgol:
; .FSTART _generSinUgol
	CLR  R5
	CLR  R6
_0xD:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R5,R30
	CPC  R6,R31
	BRGE _0xE
	__GETW1R 5,6
	SUBI R30,LOW(400)
	SBCI R31,HIGH(400)
	ASR  R31
	ROR  R30
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3F666666
	RCALL __MULF12
	RCALL SUBOPT_0x1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43340000
	RCALL SUBOPT_0x2
	__GETW1R 5,6
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RJMP _0xD
_0xE:
_0x20A0003:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; .FEND
;#define dt 0.0163
;
;
;#define PACKET_SIZE 9
;#define PREAMBLE 0x88
;
;typedef struct {
;    uint8_t preamble;
;    uint8_t type;
;    uint8_t length;
;    uint8_t data[6];
;    uint8_t crc;
;} Packet;
;
;Packet rx_packet;
;volatile uint8_t rx_index = 0;
;volatile uint8_t packet_received = 0;
;
;volatile int ugol = 0;
;unsigned char byte1,byte2,byte3,byte4 ;
;int32_t result = 0;    // результат функции
;//задаем параметры функции синуса(из которой будем получать ошибку) y = A*sin(T*t)
;int32_t A = 60 ;//амплитуда , потом будем задавать матлабом

	.DSEG
;int T = 3 ; // период , потом будем принимать с матлаба    //3~0.684 ms  каждое увеличение в 2 раза
;int32_t error = 0;// для расчета ошибки
;int time12 = 0;
;int flag = 0;
;
;int32_t integral = 0;       // Интегральная составляющая
;int32_t previous_error = 0; // Предыдущее значение ошибки
;int32_t derivative;
;//коэффициенты ПИД регулятора
;volatile int16_t Kp = 200;
;volatile int16_t Ki = 0;
;volatile int16_t Kd = 1;
;uint8_t flagPWM = 0;
;uint32_t pwm_value = 0;
;uint32_t my_abs(int32_t value) {
; 0000 0041 uint32_t my_abs(int32_t value) {

	.CSEG
_my_abs:
; .FSTART _my_abs
; 0000 0042     return (value < 0) ? -value : value;
	RCALL __PUTPARD2
;	value -> Y+0
	LDD  R26,Y+3
	TST  R26
	BRPL _0x12
	RCALL SUBOPT_0x6
	RCALL __ANEGD1
	RJMP _0x13
_0x12:
	RCALL SUBOPT_0x6
_0x13:
	JMP  _0x20A0001
; 0000 0043 }
; .FEND
;uint8_t flagT = 0   ;
;uint8_t flagA = 0   ;
;uint8_t flagP = 0   ;
;uint8_t flagI = 0   ;
;uint8_t flagD = 0   ;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 004C {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D                   //PORTB ^= (1 << PORTB5); // Переключение состояния светодиода L (PB5)
; 0000 004E if (PINB.4 == 1)
	SBIS 0x3,4
	RJMP _0x15
; 0000 004F {
; 0000 0050   ugol++;
	RCALL SUBOPT_0x7
	ADIW R30,1
	RJMP _0x4F
; 0000 0051 }
; 0000 0052 else
_0x15:
; 0000 0053 {
; 0000 0054   ugol--;
	RCALL SUBOPT_0x7
	SBIW R30,1
_0x4F:
	ST   -X,R31
	ST   -X,R30
; 0000 0055 }
; 0000 0056 EIFR |= (1 << INTF0); // Установка флага INTF0 для вызова прерывания INT0
	SBI  0x1C,0
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 005A 
; 0000 005B {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x8
; 0000 005C         //PORTB ^= (1 << PORTB5); // Переключение состояния светодиода L (PB5)
; 0000 005D 
; 0000 005E         byte1 = (ugol >> 8) & 0xFF;
	RCALL SUBOPT_0x9
	RCALL __ASRW8
	MOV  R8,R30
; 0000 005F         byte2 = ugol & 0xFF;
	LDS  R30,_ugol
	MOV  R7,R30
; 0000 0060         putchar(0x1c);   // преамбула для пакета угла
	LDI  R26,LOW(28)
	RCALL SUBOPT_0xA
; 0000 0061         putchar(byte1);
; 0000 0062         putchar(byte2);
; 0000 0063         byte1 = (pwm_value >> 8) & 0xFF;
	RCALL SUBOPT_0xB
	LDI  R30,LOW(8)
	RCALL __LSRD12
	MOV  R8,R30
; 0000 0064         byte2 = pwm_value & 0xFF;
	LDS  R30,_pwm_value
	MOV  R7,R30
; 0000 0065         putchar(0x2d);  // преамбула для пакета управления
	LDI  R26,LOW(45)
	RCALL SUBOPT_0xA
; 0000 0066         putchar(byte1);
; 0000 0067         putchar(byte2);
; 0000 0068         byte4 = (error >> 24) & 0xFF;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(24)
	RCALL __ASRD12
	MOV  R9,R30
; 0000 0069         byte3 = (error >> 16) & 0xFF;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(16)
	RCALL __ASRD12
	MOV  R10,R30
; 0000 006A         byte1 = (error >> 8) & 0xFF;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(8)
	RCALL __ASRD12
	MOV  R8,R30
; 0000 006B         byte2 = error & 0xFF;
	LDS  R30,_error
	MOV  R7,R30
; 0000 006C         putchar(0x2c);       // преамбула для ошибки
	LDI  R26,LOW(44)
	RCALL _putchar
; 0000 006D         putchar(byte4);
	MOV  R26,R9
	RCALL _putchar
; 0000 006E         putchar(byte3);
	MOV  R26,R10
	RCALL SUBOPT_0xA
; 0000 006F         putchar(byte1);
; 0000 0070         putchar(byte2);
; 0000 0071         time12=time12+100;
	__GETW1R 13,14
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	__PUTW1R 13,14
; 0000 0072         if(time12>(samls*(1<<T)))time12 = 0;
	MOV  R30,R11
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	MOV  R31,R30
	LDI  R30,0
	CP   R30,R13
	CPC  R31,R14
	BRSH _0x17
	CLR  R13
	CLR  R14
; 0000 0073         if(time12>16128)time12 =0;
_0x17:
	LDI  R30,LOW(16128)
	LDI  R31,HIGH(16128)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x18
	CLR  R13
	CLR  R14
; 0000 0074 
; 0000 0075         //cordic
; 0000 0076         //PORTB ^= (1 << PORTB5); // Переключение состояния светодиода L (PB5)
; 0000 0077 
; 0000 0078         //result =  A*sin(0.016384*T*time12*2*PI);
; 0000 0079         //error = (A*((sin_ugol[ugol>>1])) -  result)/100;
; 0000 007A         //error =((int16_t)(A*sin(ugol/1.39*PI/180))) - result;
; 0000 007B         //    //error = (int16_t)(error>>2);
; 0000 007C         result = A*(fix16_sin[(time12>>T)]);
_0x18:
	MOV  R30,R11
	__GETW2R 13,14
	RCALL __ASRW12
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xD
	STS  _result,R30
	STS  _result+1,R31
	STS  _result+2,R22
	STS  _result+3,R23
; 0000 007D         error = (A*((sin_ugol[ugol>>1])) -  result)/100;
	RCALL SUBOPT_0x9
	ASR  R31
	ROR  R30
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xD
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_result
	LDS  R31,_result+1
	LDS  R22,_result+2
	LDS  R23,_result+3
	RCALL __SUBD21
	__GETD1N 0x64
	RCALL __DIVD21
	STS  _error,R30
	STS  _error+1,R31
	STS  _error+2,R22
	STS  _error+3,R23
; 0000 007E         // Вычисление интегральной составляющей
; 0000 007F         integral += error * dt;
	RCALL SUBOPT_0xE
	RCALL __CDF1
	__GETD2N 0x3C858794
	RCALL __MULF12
	LDS  R26,_integral
	LDS  R27,_integral+1
	LDS  R24,_integral+2
	LDS  R25,_integral+3
	RCALL __CDF2
	RCALL __ADDF12
	STS  _integral,R30
	STS  _integral+1,R31
	STS  _integral+2,R22
	STS  _integral+3,R23
; 0000 0080         // Вычисление дифференциальной составляющей
; 0000 0081         derivative = error - previous_error;
	LDS  R26,_previous_error
	LDS  R27,_previous_error+1
	LDS  R24,_previous_error+2
	LDS  R25,_previous_error+3
	RCALL SUBOPT_0xE
	RCALL __SUBD12
	STS  _derivative,R30
	STS  _derivative+1,R31
	STS  _derivative+2,R22
	STS  _derivative+3,R23
; 0000 0082         pwm_value = (my_abs(Kp * error + Ki * integral + Kd * derivative)/10);
	RCALL SUBOPT_0xE
	LDS  R26,_Kp
	LDS  R27,_Kp+1
	RCALL __CWD2
	RCALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_integral
	LDS  R31,_integral+1
	LDS  R22,_integral+2
	LDS  R23,_integral+3
	LDS  R26,_Ki
	LDS  R27,_Ki+1
	RCALL __CWD2
	RCALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_derivative
	LDS  R31,_derivative+1
	LDS  R22,_derivative+2
	LDS  R23,_derivative+3
	LDS  R26,_Kd
	LDS  R27,_Kd+1
	RCALL __CWD2
	RCALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDD21
	RCALL _my_abs
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RCALL __DIVD21U
	RCALL SUBOPT_0xF
; 0000 0083 
; 0000 0084 
; 0000 0085         if (pwm_value > 65535) {
	RCALL SUBOPT_0x10
	BRLO _0x19
; 0000 0086             pwm_value = 65535;
	__GETD1N 0xFFFF
	RCALL SUBOPT_0xF
; 0000 0087 
; 0000 0088         }
; 0000 0089         if (error<0){
_0x19:
	LDS  R26,_error+3
	TST  R26
	BRPL _0x1A
; 0000 008A 
; 0000 008B             if(flagPWM == 0){
	LDS  R30,_flagPWM
	CPI  R30,0
	BRNE _0x1B
; 0000 008C             flagPWM = 1;
	LDI  R30,LOW(1)
	STS  _flagPWM,R30
; 0000 008D             PORTD.7 = 0;
	CBI  0xB,7
; 0000 008E             PIND.6=1;
	SBI  0x9,6
; 0000 008F             }
; 0000 0090             if(pwm_value <= 65535){
_0x1B:
	RCALL SUBOPT_0x10
	BRSH _0x20
; 0000 0091                OCR1AH = (pwm_value >> 8) & 0xFF; // Высший байт
	RCALL SUBOPT_0x11
; 0000 0092                OCR1AL = pwm_value & 0xFF; // Нижний байт
; 0000 0093             }
; 0000 0094         }
_0x20:
; 0000 0095             else if(error>0){
	RJMP _0x21
_0x1A:
	RCALL SUBOPT_0xC
	RCALL __CPD02
	BRGE _0x22
; 0000 0096             if(flagPWM == 1)
	LDS  R26,_flagPWM
	CPI  R26,LOW(0x1)
	BRNE _0x23
; 0000 0097             {
; 0000 0098             flagPWM = 0;
	LDI  R30,LOW(0)
	STS  _flagPWM,R30
; 0000 0099             PORTD.7 = 1;
	SBI  0xB,7
; 0000 009A             PIND.6 = 0;
	CBI  0x9,6
; 0000 009B             }
; 0000 009C             if(pwm_value <= 65535) {
_0x23:
	RCALL SUBOPT_0x10
	BRSH _0x28
; 0000 009D                 OCR1AH = (pwm_value >> 8) & 0xFF; // Высший байт
	RCALL SUBOPT_0x11
; 0000 009E                 OCR1AL = pwm_value & 0xFF; // Нижний байт
; 0000 009F             }
; 0000 00A0             else {
	RJMP _0x29
_0x28:
; 0000 00A1                 OCR1BH = 0;
	RCALL SUBOPT_0x0
; 0000 00A2                 OCR1BL = 0;
; 0000 00A3                previous_error = 0;
	STS  _previous_error,R30
	STS  _previous_error+1,R30
	STS  _previous_error+2,R30
	STS  _previous_error+3,R30
; 0000 00A4             }
_0x29:
; 0000 00A5 
; 0000 00A6         }
; 0000 00A7     previous_error =  error;
_0x22:
_0x21:
	RCALL SUBOPT_0xE
	STS  _previous_error,R30
	STS  _previous_error+1,R31
	STS  _previous_error+2,R22
	STS  _previous_error+3,R23
; 0000 00A8     //PORTB ^= (1 << PORTB5); // Переключение состояния светодиода L (PB5)
; 0000 00A9 }
	RJMP _0x51
; .FEND
;// Declare your global variables here
;interrupt[USART_RXC] void usartRX_data(void) {
; 0000 00AB interrupt[19] void usartRX_data(void) {
_usartRX_data:
; .FSTART _usartRX_data
	RCALL SUBOPT_0x8
; 0000 00AC     int i = 0;
; 0000 00AD     uint8_t ack[5] = {0x88, 0x01, 0x01, 0x00, 0x00};
; 0000 00AE     uint8_t calc_crc ;
; 0000 00AF     static uint8_t state = 0;
; 0000 00B0     uint8_t received_data = UDR0;
; 0000 00B1     switch (state)
	SBIW R28,5
	LDI  R30,LOW(136)
	ST   Y,R30
	LDI  R30,LOW(1)
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(0)
	STD  Y+3,R30
	STD  Y+4,R30
	RCALL __SAVELOCR4
;	i -> R16,R17
;	ack -> Y+4
;	calc_crc -> R19
;	received_data -> R18
	__GETWRN 16,17,0
	LDS  R30,198
	MOV  R18,R30
	LDS  R30,_state_S000000C000
	LDI  R31,0
; 0000 00B2            {
; 0000 00B3 
; 0000 00B4            case 0: if (received_data == PREAMBLE) state++;
	SBIW R30,0
	BRNE _0x2D
	CPI  R18,136
	BRNE _0x2E
	LDS  R30,_state_S000000C000
	SUBI R30,-LOW(1)
	RJMP _0x50
; 0000 00B5            else state = 0;
_0x2E:
	LDI  R30,LOW(0)
_0x50:
	STS  _state_S000000C000,R30
; 0000 00B6            break;
	RJMP _0x2C
; 0000 00B7 
; 0000 00B8            case 1:   rx_packet.type = received_data;
_0x2D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x30
	__PUTBMRN _rx_packet,1,18
; 0000 00B9            state++;
	RCALL SUBOPT_0x12
; 0000 00BA 
; 0000 00BB            break;
	RJMP _0x2C
; 0000 00BC            case 2: rx_packet.length = received_data; state++; break;
_0x30:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x31
	__PUTBMRN _rx_packet,2,18
	RCALL SUBOPT_0x12
	RJMP _0x2C
; 0000 00BD            case 3: if (rx_index < rx_packet.length) {
_0x31:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x32
	RCALL SUBOPT_0x13
	CP   R26,R30
	BRSH _0x33
; 0000 00BE                     rx_packet.data[rx_index++] = received_data;
	__POINTW2MN _rx_packet,3
	LDS  R30,_rx_index
	SUBI R30,-LOW(1)
	STS  _rx_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R18
; 0000 00BF                     if (rx_index == rx_packet.length) state++;
	RCALL SUBOPT_0x13
	CP   R30,R26
	BRNE _0x34
	RCALL SUBOPT_0x12
; 0000 00C0                 }
_0x34:
; 0000 00C1                 break;
_0x33:
	RJMP _0x2C
; 0000 00C2            case 4: rx_packet.crc = received_data;
_0x32:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2C
	__PUTBMRN _rx_packet,9,18
; 0000 00C3                 calc_crc = calculate_crc((uint8_t*)&rx_packet, rx_index + 3); // без CRC
	LDI  R30,LOW(_rx_packet)
	LDI  R31,HIGH(_rx_packet)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_rx_index
	SUBI R26,-LOW(3)
	RCALL _calculate_crc
	MOV  R19,R30
; 0000 00C4                 if (calc_crc == rx_packet.crc) {
	__GETB1MN _rx_packet,9
	CP   R30,R19
	BREQ PC+2
	RJMP _0x36
; 0000 00C5                     // Пакет корректный
; 0000 00C6                     switch(rx_packet.type) {
	__GETB1MN _rx_packet,1
	LDI  R31,0
; 0000 00C7                         case 0x02: { // установка PID
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
; 0000 00C8                             Kp = (rx_packet.data[0] << 8) | rx_packet.data[1];
	__GETB1HMN _rx_packet,3
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _rx_packet,4
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _Kp,R30
	STS  _Kp+1,R31
; 0000 00C9                             Ki = (rx_packet.data[2] << 8) | rx_packet.data[3];
	__GETBRMN 27,_rx_packet,5
	LDI  R26,LOW(0)
	__GETB1MN _rx_packet,6
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _Ki,R30
	STS  _Ki+1,R31
; 0000 00CA                             Kd = (rx_packet.data[4] << 8) | rx_packet.data[5];
	__GETBRMN 27,_rx_packet,7
	LDI  R26,LOW(0)
	__GETB1MN _rx_packet,8
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _Kd,R30
	STS  _Kd+1,R31
; 0000 00CB                             // Отправить подтверждение
; 0000 00CC                             ack[4] = calculate_crc(ack, 5);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _calculate_crc
	STD  Y+8,R30
; 0000 00CD                             for (i = 0; i < 5; i++) {
	__GETWRN 16,17,0
_0x3C:
	__CPWRN 16,17,5
	BRGE _0x3D
; 0000 00CE                                 send_byte(ack[i]);
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _send_byte
; 0000 00CF                             }
	__ADDWRN 16,17,1
	RJMP _0x3C
_0x3D:
; 0000 00D0                         } break;
; 0000 00D1                     }
_0x39:
; 0000 00D2                 }
; 0000 00D3                 state = 0;
_0x36:
	LDI  R30,LOW(0)
	STS  _state_S000000C000,R30
; 0000 00D4                 rx_index = 0;
	STS  _rx_index,R30
; 0000 00D5                 packet_received = 1;
	LDI  R30,LOW(1)
	STS  _packet_received,R30
; 0000 00D6                 break;
; 0000 00D7            }
_0x2C:
; 0000 00D8 //    if(received_data == 0x0A){
; 0000 00D9 //        flagA = 1;
; 0000 00DA //    }
; 0000 00DB //    if(flag == 1){
; 0000 00DC //        A = received_data;
; 0000 00DD //        flagA = 0;
; 0000 00DE //    }
; 0000 00DF //    if(received_data == 0x0B){
; 0000 00E0 //        flagT = 1;
; 0000 00E1 //    }
; 0000 00E2 //    if(flagT == 1){
; 0000 00E3 //        T = (received_data<<8);
; 0000 00E4 //        flagT = 2;
; 0000 00E5 //    }
; 0000 00E6 //    if(flagT == 2){
; 0000 00E7 //        T = T+received_data;
; 0000 00E8 //        flagT = 0;
; 0000 00E9 //    }
; 0000 00EA //    if(received_data == 0x1A){
; 0000 00EB //        flagP = 1;
; 0000 00EC //    }
; 0000 00ED //    if(flagP == 1){
; 0000 00EE //        Kp = (received_data<<8);
; 0000 00EF //        flagP = 2;
; 0000 00F0 //    }
; 0000 00F1 //    if(flagP == 2){
; 0000 00F2 //        Kp = Kp + received_data;
; 0000 00F3 //        flagP = 0;
; 0000 00F4 //    }
; 0000 00F5 //    if(received_data == 0x1B){
; 0000 00F6 //        flagI = 1;
; 0000 00F7 //    }
; 0000 00F8 //    if(flagI == 1){
; 0000 00F9 //        Ki = (received_data<<8);
; 0000 00FA //        flagI = 2;
; 0000 00FB //    }
; 0000 00FC //    if(flagI == 2){
; 0000 00FD //        Ki = Ki + received_data;
; 0000 00FE //        flagI = 0;
; 0000 00FF //    }
; 0000 0100 //    if(received_data == 0x1F){
; 0000 0101 //        flagD = 1;
; 0000 0102 //    }
; 0000 0103 //    if(flagD == 1){
; 0000 0104 //        Kd = (received_data<<8);
; 0000 0105 //        flagD = 2;
; 0000 0106 //    }
; 0000 0107 //    if(flagD == 2){
; 0000 0108 //        Kd = Kd + received_data;
; 0000 0109 //        flagD = 0;
; 0000 010A //    }
; 0000 010B }
	RCALL __LOADLOCR4
	ADIW R28,9
_0x51:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;void main(void)
; 0000 010F {
_main:
; .FSTART _main
; 0000 0110 
; 0000 0111     //peripherals config
; 0000 0112     setCLK();
	RCALL _setCLK
; 0000 0113     setPORTS();
	RCALL _setPORTS
; 0000 0114     setTimers();
	RCALL _setTimers
; 0000 0115     setEXT();
	RCALL _setEXT
; 0000 0116     uartconfig();
	RCALL _uartconfig
; 0000 0117 
; 0000 0118 
; 0000 0119     #asm("sei")
	SEI
; 0000 011A     PIND.6=0;
	CBI  0x9,6
; 0000 011B     PORTB.5 = 0;
	CBI  0x5,5
; 0000 011C     PORTD.7 = 0;
	CBI  0xB,7
; 0000 011D     PORTB.1 = 1;
	SBI  0x5,1
; 0000 011E     generSin();        // заполнениение массива синуса
	RCALL _generSin
; 0000 011F     generSinUgol();
	RCALL _generSinUgol
; 0000 0120     PORTD.7 = 1;
	SBI  0xB,7
; 0000 0121     PIND.6 = 0;
	CBI  0x9,6
; 0000 0122     OCR1BH = 244;
	LDI  R30,LOW(244)
	STS  139,R30
; 0000 0123     OCR1BL = 244;
	STS  138,R30
; 0000 0124 
; 0000 0125 
; 0000 0126     while (1)
_0x4A:
; 0000 0127     {
; 0000 0128         if (packet_received) {
	LDS  R30,_packet_received
	CPI  R30,0
	BREQ _0x4D
; 0000 0129             // Обработка принятого пакета
; 0000 012A             packet_received = 0;
	LDI  R30,LOW(0)
	STS  _packet_received,R30
; 0000 012B         }
; 0000 012C 
; 0000 012D         // result =A*datay[5];
; 0000 012E         //    if(time12>16128)time12 =0;
; 0000 012F         //    result = A*(fix16_sin[(time12>>6)]);
; 0000 0130         //    //result = 1966080;
; 0000 0131         //    //result =  A*sin(0.016384*T*time12*2*PI);
; 0000 0132         //    error = (A*((sin_ugol[ugol>>1])) -  result)/100;
; 0000 0133         //    //error =((int16_t)(A*sin(ugol/1.39*PI/180))) - result;
; 0000 0134         //    //error = (int16_t)(error>>2);
; 0000 0135         //    // Вычисление интегральной составляющей
; 0000 0136         //    integral += error * dt;
; 0000 0137         //    // Вычисление дифференциальной составляющей
; 0000 0138         //    derivative = error - previous_error;
; 0000 0139         //    pwm_value = (my_abs(Kp * error + Ki * integral + Kd * derivative)/100);
; 0000 013A         //    //pwm_value = (Y); // Преобразование float в uint16_t
; 0000 013B         //    //error = 1;
; 0000 013C         //                    //OCR1AH = 0xFF; // Высший байт
; 0000 013D         //
; 0000 013E         //    //OCR1AL = 254;
; 0000 013F         //        if (pwm_value > 65535) {
; 0000 0140         //            pwm_value = 65535;
; 0000 0141         //
; 0000 0142         //        }
; 0000 0143         //        if (error<0){
; 0000 0144         //            flagPWM = 1;
; 0000 0145         //            PORTD.7 = 0;
; 0000 0146         //            PIND.6=1;
; 0000 0147         //            if(pwm_value <= 65535){
; 0000 0148         //               //#asm("cli")
; 0000 0149         //               OCR1AH = (pwm_value >> 8) & 0xFF; // Высший байт
; 0000 014A         //               OCR1AL = pwm_value & 0xFF; // Нижний байт
; 0000 014B         //               //#asm("sei")
; 0000 014C         //            }
; 0000 014D         //        }
; 0000 014E         //            else if(error>0){
; 0000 014F         //            flagPWM = 0;
; 0000 0150         //            PORTD.7 = 1;
; 0000 0151         //            PIND.6 = 0;
; 0000 0152         //            if(pwm_value <= 65535) {
; 0000 0153         //                //#asm("cli")
; 0000 0154         //                OCR1AH = (pwm_value >> 8) & 0xFF; // Высший байт
; 0000 0155         //                OCR1AL = pwm_value & 0xFF; // Нижний байт
; 0000 0156         //                //#asm("sei")
; 0000 0157         //            }
; 0000 0158         //            else {
; 0000 0159         //                //OCR1BH = 0;
; 0000 015A         //                //OCR1BL = 0;
; 0000 015B         //                previous_error = 0;
; 0000 015C         //            }
; 0000 015D         //        }
; 0000 015E         //    previous_error =  error;
; 0000 015F         //    // OCR1AH = 0;
; 0000 0160 
; 0000 0161     }
_0x4D:
	RJMP _0x4A
; 0000 0162 }
_0x4E:
	RJMP _0x4E
; .FEND
;
;
;
;
;
;

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R17
	MOV  R17,R26
_0x2020006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
_0x20A0002:
	STS  198,R17
	LD   R17,Y+
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x6
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x6
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20A0001:
	ADIW R28,4
	RET
; .FEND
_sin:
; .FSTART _sin
	RCALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	RCALL SUBOPT_0x14
	__GETD1N 0x3E22F983
	RCALL __MULF12
	RCALL SUBOPT_0x15
	RCALL _floor
	RCALL SUBOPT_0x14
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040017
	RCALL SUBOPT_0x17
	__GETD2N 0x3F000000
	RCALL SUBOPT_0x18
	LDI  R17,LOW(1)
_0x2040017:
	RCALL SUBOPT_0x14
	__GETD1N 0x3E800000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040018
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	RCALL SUBOPT_0x17
	RCALL __ANEGF1
	__PUTD1S 5
_0x2040019:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x14
	RCALL __MULF12
	__PUTD1S 1
	RCALL SUBOPT_0x19
	__GETD2N 0x4226C4B1
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x1A
	__GETD2N 0x4104534C
	RCALL __ADDF12
	RCALL SUBOPT_0x14
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x19
	__GETD2N 0x3FDEED11
	RCALL __ADDF12
	RCALL SUBOPT_0x1A
	__GETD2N 0x3FA87B5E
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_fix16_sin:
	.BYTE 0x200
_x:
	.BYTE 0x4
_sin_ugol:
	.BYTE 0x320
_rx_packet:
	.BYTE 0xA
_rx_index:
	.BYTE 0x1
_packet_received:
	.BYTE 0x1
_ugol:
	.BYTE 0x2
_result:
	.BYTE 0x4
_A:
	.BYTE 0x4
_error:
	.BYTE 0x4
_integral:
	.BYTE 0x4
_previous_error:
	.BYTE 0x4
_derivative:
	.BYTE 0x4
_Kp:
	.BYTE 0x2
_Ki:
	.BYTE 0x2
_Kd:
	.BYTE 0x2
_flagPWM:
	.BYTE 0x1
_pwm_value:
	.BYTE 0x4
_state_S000000C000:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  139,R30
	STS  138,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__GETD2N 0x4048F5C3
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	RCALL __DIVF21
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_fix16_sin)
	LDI  R27,HIGH(_fix16_sin)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	LDS  R26,_x
	LDS  R27,_x+1
	LDS  R24,_x+2
	LDS  R25,_x+3
	RCALL _sin
	__GETD2N 0x47000000
	RCALL __MULF12
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_sin_ugol)
	LDI  R27,HIGH(_sin_ugol)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_ugol)
	LDI  R27,HIGH(_ugol)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R30,_ugol
	LDS  R31,_ugol+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	RCALL _putchar
	MOV  R26,R8
	RCALL _putchar
	MOV  R26,R7
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xB:
	LDS  R26,_pwm_value
	LDS  R27,_pwm_value+1
	LDS  R24,_pwm_value+2
	LDS  R25,_pwm_value+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xC:
	LDS  R26,_error
	LDS  R27,_error+1
	LDS  R24,_error+2
	LDS  R25,_error+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	LDS  R26,_A
	LDS  R27,_A+1
	LDS  R24,_A+2
	LDS  R25,_A+3
	RCALL __CWD1
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE:
	LDS  R30,_error
	LDS  R31,_error+1
	LDS  R22,_error+2
	LDS  R23,_error+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	STS  _pwm_value,R30
	STS  _pwm_value+1,R31
	STS  _pwm_value+2,R22
	STS  _pwm_value+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xB
	__CPD2N 0x10000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xB
	LDI  R30,LOW(8)
	RCALL __LSRD12
	STS  137,R30
	LDS  R30,_pwm_value
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDS  R30,_state_S000000C000
	SUBI R30,-LOW(1)
	STS  _state_S000000C000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__GETB1MN _rx_packet,2
	LDS  R26,_rx_index
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__PUTD1S 5
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	RCALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETD2S 1
	RCALL __MULF12
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ANEGD2:
	COM  R27
	COM  R24
	COM  R25
	NEG  R26
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12S8:
	CP   R0,R1
	BRLO __LSLW12L
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12S8:
	CP   R0,R1
	BRLO __ASRW12L
	MOV  R30,R31
	LDI  R31,0
	SBRC R30,7
	LDI  R31,0xFF
	SUB  R0,R1
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12S8:
	CP   R0,R1
	BRLO __ASRD12L
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	LDI  R23,0
	SBRC R22,7
	LDI  R23,0xFF
	SUB  R0,R1
	BRNE __ASRD12S8
	RET
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12S8:
	CP   R0,R1
	BRLO __LSRD12L
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	LDI  R23,0
	SUB  R0,R1
	BRNE __LSRD12S8
	RET
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	RCALL __ANEGD2
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

;END OF CODE MARKER
__END_OF_CODE:
