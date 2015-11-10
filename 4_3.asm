;**********************************************************************
;��������� 4.3 ��� �� ATx8515:
;������������ ������ ������� ��������� ������� �1 
;��� ����������� ���������� ��������� ������� ��������� 
;���������� CK=256 ��.
;��� ������� �� SW0 (START) ���������� ��������� �������� � �������� CK,
;��� ������� �� SW1 (STOP) ������� ���������������.
;��� ���������� ����������� �������� � �������� ���������
;OCR1B ���������� ������������ ���������� LED0, 
;��������  � �������� ��������� OCR1A - LED1.
;����������: LED0�PE2, LED1�PD5, SW0�PD0, SW1�PD2
;***********************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.def temp = r16				;��������� �������
.equ START = 0				;0-�� ����� ����� PD
.org $000
		rjmp INIT			;��������� ������
.org $003
		rjmp STOP_PRESSED	;��������� �������� ���������� INT0  													; ��� ������� STOP
;***������������� ��
INIT:	ldi temp,low(RAMEND);���������
		out SPL,temp		; ��������� �����
		ldi temp,high(RAMEND); �� ���������
		out SPH,temp		; ������ ���
		ldi temp,0x20		;������������� ������� ����� PD:
		out DDRD,temp		; 0,2 - �� ����, 5 - �� �����
		ldi temp,0x05		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD � ���������� ��
		ldi temp,0x04	;///  ��� ATmega8515 ������������� ������ ����� 
		out DDRE,temp	;///  PE2 (OC1B) �� �����!
		ldi temp,(1<<INT0)	;���������� ���������� INT0
		out GICR,temp		; � �������� GICR (��� GIMSK)
		clr temp			;��������� ���������� INT0 
		out MCUCR,temp		; �� ������� ������	
;***��������� ������� ��������� ������� �1 
		ldi temp,0x50		;��� ��������� ��������� ������� OC1A �
		out TCCR1A,temp		; OC1B ���������� �� ���������������
		ldi temp,0x00		;������
		out TCCR1B,temp		; ����������
		ldi temp,0x00		;������ ����� �
		out OCR1BH,temp		; ������� ���������,
		ldi temp,0x80		;  ������ ������������
		out OCR1BL,temp		;   ������� ����
		ldi temp,0x01		;������ ����� �
		out OCR1AH,temp		; ������� ���������,
		ldi temp,0x00		;  ������ ������������
		out OCR1AL,temp		;   ������� ����
		clr temp			;���������
		out TCNT1H,temp		; �����������
		out TCNT1L,temp		;  �������� ��������
		sei					;���������� ����������
WAITSTART: sbic PIND,START	;�������� �������
		rjmp WAITSTART		;  ������ START
		ldi temp,0x09		;������ �������, ���
		out TCCR1B,temp		; ���������� � OCR1A - �����
LOOP:	nop					;�� ����� ����� ����������
		rjmp LOOP			; ���������� ����������� �������� ��������
;***��������� ���������� �� ������ STOP
STOP_PRESSED:
		ldi temp,0x08		;���������
		out TCCR1B,temp		; �������
WAITSTART_2:				;��������
		sbic PIND,START		; �������
		rjmp WAITSTART_2	;  ������ START
		ldi temp,0x09		;������
		out TCCR1B,temp		; �������
		reti