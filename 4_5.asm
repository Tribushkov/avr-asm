;************************************************************************
;Программа 4.5 для МК ATx8515:;демонстрация работы таймера Т1 в режиме ШИМ.
;Для наглядности необходимо выставить частоту тактового генератора = 2048 Гц.
;При нажатии на SW0 (SHOW_0) на выходах OC1A и OC1B устанавливаются 0 и 1,
;SW1 (SHOW_F1) - генерация ШИМ-сигнала со скважностью F1,
;SW2 (SHOW_F2) - со скважностью F2,
;SW3 (SHOW_1) - на выходах устанавливаются 1 и 0
;Соединения: PD5-LED0,PE2-LED1,PD0:PD1--SW0:SW1,PD2:PD3-SW2:SW3  
;************************************************************************
;.include "8515def.inc"		;файл определений AT90S8515
.include "m8515def.inc"		;файл определений ATmega8515
.def temp = r16				;временный регистр
;***Выводы порта PD
.equ SHOW_0 = 0				
.equ SHOW_F1 = 1				
.equ SHOW_F2 = 2				
.equ SHOW_3 = 3				
.org $000
		rjmp INIT			;обработка сброса
;***Инициализация МК
INIT:	ldi temp,low(RAMEND);установка
		out SPL,temp		; указателя стека
		ldi temp,high(RAMEND); на последнюю
		out SPH,temp		; ячейку ОЗУ
		ldi temp,0x20		;инициализация выводов порта PD:
		out DDRD,temp		; 0-3 - на ввод, 5 - на вывод
		ldi temp,0x0F		;включение подтягивающих 
		out PORTD,temp		; резисторов порта PD
		
		ldi temp, 0x04	; /// для ATMega8515 линия PE2
		out DDRE,temp	; /// на вывод
		
		ldi temp,0xB3		;настройка таймера на ШИМ 
		out TCCR1A,temp		; c выводами OC1A и OC1B
		clr temp			;обнуление
		out OCR1AH,temp		; регистров
		out OCR1AL,temp		; сравнения и
		out OCR1BH,temp		;   ...
		out OCR1BL,temp		;   ...
		out TCNT1H,temp		; счётного
		out TCNT1L,temp		; регистра
		ldi temp,0x01		;таймер
		out TCCR1B,temp		; запущен: частота = СК
		
WAIT_0:	sbic PIND,SHOW_0	;ожидание нажатия
		rjmp WAIT_F1		; кнопки SHOW_0
;***Перевод в устойчивые состояния выводов OC1A=0, OC1B=1
		clr temp			;запись числа в
		out OCR1AH,temp		; регистр сравнения, первым
		out OCR1AL,temp		; записывается старший байт
		out OCR1BH,temp		
		out OCR1BL,temp	
	
WAIT_F1: sbic PIND,SHOW_F1	;ожидание нажатия
		rjmp WAIT_F2		; кнопки SHOW_F1
;***Настройка таймера на режим ШИМ со скважностью F1
		ldi temp,0x01		;запись числа в
		out OCR1AH,temp		; регистры сравнения,
		out OCR1BH,temp		; первым записывается
		ldi temp,0x00		; старший байт
		out OCR1AL,temp 
		out OCR1BL,temp

WAIT_F2: sbic PIND,SHOW_F2	;ожидание нажатия
		rjmp WAIT_3			; кнопки SHOW_F2
;***Настройка таймера на режим ШИМ со скважностью F2
		ldi temp,0x03		;запись числа в
		out OCR1AH,temp		; регистры сравнения,
		out OCR1BH,temp		; первым записывается
		ldi temp,0x00		; старший байт
		out OCR1AL,temp 
		out OCR1BL,temp

WAIT_3:	sbic PIND,SHOW_3	;ожидание нажатия
		rjmp WAIT_0			; кнопки SHOW_3
;***Перевод в устойчивые состояния выводов OC1A=1, OC1B=0
		ser temp			;запись числа в
		out OCR1AH,temp		; регистры сравнения, первым
		out OCR1AL,temp		; записывается старший байт
		out OCR1BH,temp		
		out OCR1BL,temp		
		rjmp WAIT_0
