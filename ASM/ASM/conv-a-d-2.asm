;***************************************************************
	; PROGRAMA QUE ENCIENDE Y APAGA LOS PUERTOS DEL 16F88

	title	"PIC Sample code: PIC16F88 program"
	subtitle	"CARLOS SANTIAGO CRUZ - TESIS - prueba del convertidor analógico digital"

;	codigo para el 16f88 a 4 MHz
;***************************************************************
	list	p=16F88
	#include	<p16F88.inc>
	
	__CONFIG	_CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO
	ERRORLEVEL -302
;***************************************************************
z1	equ	20h		;REGISTROS COMODINES
z2	equ	21h
z3	equ	22h
z4	equ	23h
;***************************************************************
		ORG			0x0000
		GOTO		INIT
		NOP
		NOP
		NOP
		NOP
		ORG			0x0005

INIT		CLRF		PORTA			; limpia puerto A
		CLRF		PORTB			; limpia puerto B
		BSF			STATUS,RP0		; selecciona Banco 1; Se encuentran registros TRISA y TRISB
									; al reset STATUS=00000000
									; REGISTRO STATUS = 	IRP 		RP1		RP0		T0_		PD_		Z		DC		C
									;  RP1 RP0
									;  0    0		banco 0
									;  0    1		banco 1		RP0=1
									;  1    0		banco 2
									;  1    1		banco 3
		MOVLW		H'00'
		MOVWF		ANSEL		; Registro ANSEL - ANS6 ANS5 ANS4 ANS3 ANS2 ANS1 ANS0 
									; Configura la funcion de los pines de los puertos
									; pueden ser configurados como entradas analògicas 
									; (RA3,RA2 tambien pueden ser tensiones de referencia)
									; o como entradas/salidas digitales; 
									;	1 - analog I/O; 
									;	0 - digital I/O
									;solo el primer canal es entrada analógica.		

		BSF			OSCCON,6		;Pone el oscilador a 4 MHz; OSCCON controla varios aspectos de operacion del sistema de reloj
		BSF			OSCCON,5		;bit 6-4		110		4 MHZ
									;al reset inicia con 0's el registro.

		MOVLW		H'07'			;carga el registro W con 07		0000 0111
		MOVWF		CMCON			;CMCON ->	C2OUT	C1OUT	C2INV	C1INV	CIS	 CM2  CM1  CM0
									; ver los modos de operacion de los comparadores
									; comparadores apagados
									;CLRF		TRISA			;Puerto A como salida		0 - salida; 1 - entrada
		CLRF		TRISB			;Puerto B como salida		0 - salida; 1 - entrada
		BCF			STATUS,RP0		;Selecciona Banco 0

;INICIA	MOVLW		0xFF			; mover 1111 1111 al registro W, enciende leds conectados a la salida
;		MOVWF		PORTA			; mover W al puerto A
;		MOVWF		PORTB			; mover W al puerto B
;		CALL		RETRASO			; llama a una subrutina de retraso
;		CLRF		PORTA			; mueve 0000 0000 al puerto A, apaga leds conectados a la salida
;		CLRF		PORTB			; mueve 0000 0000 al puerto B, apaga leds conectados a la salida
;		CALL		RETRASO		; llama a una subrutina de retraso
;		GOTO		INICIA			; regresa a la etiqueta start

		MOVLW		H'FF'			;1.	Configure el modulo A/D
		MOVWF		ANSEL			;		•	Configurar E/S analógica/digital 	(ANSEL)		elegimos un canal RA0/ pin17		
		BCF			ADCON1			;		•	Configurar tensión de referencia. 	(ADCON1)	Vdd Vss
		BCF			ADCON0			;		•	Seleccionar canal de entrada A/D 	(ADCON0)	canal0
					;ya arriba		;		•	Seleccionar reloj de conversión A/D	(ADCON0)
		BSF			ADCON0,ADON	;		•	Encienda el modulo A/D 	(ADCON0)
									;2.	Configurar interrupción A/D (si se desea)
									;		•	Poner a ‘0’ bit ADIF
		;no deseamos				;		•	Poner a ‘1’ bit ADIE
									;		•	Poner a ‘1’ bit PEIE
									;		•	Poner a ‘1’ bit GIE
REG		CALL 		RETRASO		;3.	Esperar el tiempo de adquisición requerido
									;4.	Empezar conversión.
		BSF			ADCON0,GO		;		•	Poner a ‘1’ bit GO/DONE_ (ADCON0)
		BTFSC		ADCON0,GO		;5.	Esperar para completar la conversión A/D, por cualquiera de los siguientes:
									;		•	Poleando (modo poleo o de ciclo) para que el bit GO/DONE_ sea puesto a ‘0’ (con interrupción deshabilitada)
									;		•	Esperando por interrupción de A/D
		MOVLW		ADRESL			;6.	Leer el registro par que da el resultado de la conversión. (ADRESH:ADRESL)
		MOVWF		PORTB			;		•	Poner a ‘0’ bit ADIF si es requerido.
		CALL 		RETRASO		
									;7.	Para la siguiente conversión, vaya a los pasos 1 o paso 2 como sea requerido. El tiempo de conversión por bit es definido como TAD. Un mínimo de 2TAD es requerido antes de que la siguiente adquisición empiece.
		GOTO		REG 			; regresa por otra conversion

;***************************************************************
;***************************************************************

	subtitle	"Delay subprogram"

RETRASO	MOVLW			D'3'
			MOVWF			z3
			MOVLW			D'137'
			MOVWF			z2
			DECFSZ			z1,f
			GOTO			$-1
			DECFSZ			z2,f
			GOTO			$-3
			DECFSZ			z3,f
			GOTO			$-5
			RETURN
	
			END
