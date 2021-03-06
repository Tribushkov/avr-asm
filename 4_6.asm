;************************************************************************
;��������� 4.6 ��� �� AT9x8515:
;������������ ������ ����������� ������� � ����������� �����������.
;��� ������� �� SW0 (PERIOD_1) ����������� ����-���� ���������� ����� 0,49 �
;(����� ��������� �����������), SW1 (PERIOD_2) - ����� 1,9 �.
;����������:PD0:PD1--SW0:SW1, PB-LED(10-��������� �����)
;************************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.def temp = r16				;��������� �������
;***������ ����� PD
.equ PERIOD_1 = 0				
.equ PERIOD_2 = 1				
.org $000
		rjmp INIT			;��������� ������
;***������������� ��
INIT:	ldi temp,low(RAMEND);���������
		out SPL,temp		; ��������� �����
		ldi temp,high(RAMEND); �� ���������
		out SPH,temp		; ������ ���
		clr temp			;������������� ������� ����� PD
		out DDRD,temp		; �� ����
		ldi temp,0x03		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD
		ser temp			;������������� ������� ����� PB
		out DDRB,temp		; �� �����
		out PORTB,temp		;���������� �����������
		ldi temp,$18		;����������
		out WDTCR,temp		; �����������
		ldi temp,$10		; �������:
		out WDTCR,temp		;WDE=0
WAIT_SW0: sbic PIND,PERIOD_1;�������� �������
		rjmp WAIT_SW1		;  ������ PERIOD_1
;***���������� ������� ����������� ����-���� = 0,49�
		clr temp			;���������
		out PORTB,temp		; �����������
		ldi temp,$0D		;��������� ����������� �������,
		out WDTCR,temp		; ������ 0,49�
WAIT_SW1: sbic PIND,PERIOD_2;�������� �������
		rjmp WAIT_SW0		;  ������ PERIOD_2
;***���������� ������� ����������� ����-���� = 1,9�
		clr temp			;���������
		out PORTB,temp		; �����������
		ldi temp,$0F		;��������� ����������� �������,
		out WDTCR,temp		; ������ 1,9�
		rjmp WAIT_SW0
