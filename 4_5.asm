;************************************************************************
;��������� 4.5 ��� �� ATx8515:;������������ ������ ������� �1 � ������ ���.
;��� ����������� ���������� ��������� ������� ��������� ���������� = 2048 ��.
;��� ������� �� SW0 (SHOW_0) �� ������� OC1A � OC1B ��������������� 0 � 1,
;SW1 (SHOW_F1) - ��������� ���-������� �� ����������� F1,
;SW2 (SHOW_F2) - �� ����������� F2,
;SW3 (SHOW_1) - �� ������� ��������������� 1 � 0
;����������: PD5-LED0,PE2-LED1,PD0:PD1--SW0:SW1,PD2:PD3-SW2:SW3  
;************************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.def temp = r16				;��������� �������
;***������ ����� PD
.equ SHOW_0 = 0				
.equ SHOW_F1 = 1				
.equ SHOW_F2 = 2				
.equ SHOW_3 = 3				
.org $000
		rjmp INIT			;��������� ������
;***������������� ��
INIT:	ldi temp,low(RAMEND);���������
		out SPL,temp		; ��������� �����
		ldi temp,high(RAMEND); �� ���������
		out SPH,temp		; ������ ���
		ldi temp,0x20		;������������� ������� ����� PD:
		out DDRD,temp		; 0-3 - �� ����, 5 - �� �����
		ldi temp,0x0F		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD
		
		ldi temp, 0x04	; /// ��� ATMega8515 ����� PE2
		out DDRE,temp	; /// �� �����
		
		ldi temp,0xB3		;��������� ������� �� ��� 
		out TCCR1A,temp		; c �������� OC1A � OC1B
		clr temp			;���������
		out OCR1AH,temp		; ���������
		out OCR1AL,temp		; ��������� �
		out OCR1BH,temp		;   ...
		out OCR1BL,temp		;   ...
		out TCNT1H,temp		; ��������
		out TCNT1L,temp		; ��������
		ldi temp,0x01		;������
		out TCCR1B,temp		; �������: ������� = ��
		
WAIT_0:	sbic PIND,SHOW_0	;�������� �������
		rjmp WAIT_F1		; ������ SHOW_0
;***������� � ���������� ��������� ������� OC1A=0, OC1B=1
		clr temp			;������ ����� �
		out OCR1AH,temp		; ������� ���������, ������
		out OCR1AL,temp		; ������������ ������� ����
		out OCR1BH,temp		
		out OCR1BL,temp	
	
WAIT_F1: sbic PIND,SHOW_F1	;�������� �������
		rjmp WAIT_F2		; ������ SHOW_F1
;***��������� ������� �� ����� ��� �� ����������� F1
		ldi temp,0x01		;������ ����� �
		out OCR1AH,temp		; �������� ���������,
		out OCR1BH,temp		; ������ ������������
		ldi temp,0x00		; ������� ����
		out OCR1AL,temp 
		out OCR1BL,temp

WAIT_F2: sbic PIND,SHOW_F2	;�������� �������
		rjmp WAIT_3			; ������ SHOW_F2
;***��������� ������� �� ����� ��� �� ����������� F2
		ldi temp,0x03		;������ ����� �
		out OCR1AH,temp		; �������� ���������,
		out OCR1BH,temp		; ������ ������������
		ldi temp,0x00		; ������� ����
		out OCR1AL,temp 
		out OCR1BL,temp

WAIT_3:	sbic PIND,SHOW_3	;�������� �������
		rjmp WAIT_0			; ������ SHOW_3
;***������� � ���������� ��������� ������� OC1A=1, OC1B=0
		ser temp			;������ ����� �
		out OCR1AH,temp		; �������� ���������, ������
		out OCR1AL,temp		; ������������ ������� ����
		out OCR1BH,temp		
		out OCR1BL,temp		
		rjmp WAIT_0
