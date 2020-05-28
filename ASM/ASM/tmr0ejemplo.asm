
		ORG		0x00
		GOTO	inicio

;########### RUTINA DE INTERRUPCION #####################

		ORG		0X04		; Atiendo la interrupción

		BTFSS	PORTB,0		; si el LED está apagado
		GOTO	LED			; voy a LED y lo enciendo
		BCF		PORTB,0		; sino apago el LED
		BCF		INTCON,2		; limpio la bandera T0IF
		RETFIE				; regreso habilitando la interrupción
LED		BSF		PORTB,0		; enciendo el LED
		BCF		INTCON,2	; borro la bandera T0IF
		RETFIE				; regreso habilitando la interrupción

;###################### PROGRAMA PRINCIPAL #########################

INICIO	BSF		STATUS,5            ; configurando puertos
		CLRF	TRISB	             ; puerto B es salida
		MOVLW 0x07 			; cargo w con 00000111
		MOVWF OPTION_REG 	; el Divisor = 256
		BCF		STATUS,5		; elijo el timer0 como temporizador

		MOVLW	0XA0			; cargo w con 10100000
		MOVWF	INTCON			; habilitamos GIE y T0IE
		CLRF	PORTB			; limpiamos PORTB
	
tiempo	MOVLW	0XD8		; cargo w con 216
		MOVWF	TMR0		; lo paso a TMR0
NADA	BTFSC	TMR0,7		; me quedo haciendo nada.
		GOTO	NADA		; hasta que TMR0 desborde, y entonces
		GOTO	tiempo		; volveré a cargar TMR0

;#############################################################

		END
