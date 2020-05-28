;***************************************************************
	; PROGRAMA PARA HACER FUNCIONAR EL CONVERTIDOR A/D

	;title	"PIC Sample code: PIC16F88 program"
	;subtitle	"CARLOS SANTIAGO CRUZ - TESIS - prueba del convertidor analógico digital"

;	codigo para el 16f88 a 4 MHz
;***************************************************************
	list	p=16F88
	#include	<p16F88.inc>
	
	__CONFIG	_CONFIG1 & _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO
	ERRORLEVEL -302

;***************************************************************
z1	equ	20h		;REGISTROS COMODINES
z2	equ	21h
z3	equ	22h
z4	equ	23h
;***************************************************************
; registros 
;	ADRESH	1Eh		banco 0
;	ADRESL	9Eh		banco 1
;	ANSEL	9Bh		banco 1
; 	ADCON0	1Fh		banco 0
;	ADCON1	9Fh		banco 1
;****************************************************************
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


		BSF			OSCCON,6		;Pone el oscilador a 4 MHz con el oscilador interno RC; OSCCON controla varios aspectos de operacion del sistema de reloj; Banco 1
		BSF			OSCCON,5		;bit 6-4		110		4 MHZ
									;al reset inicia con 0's el registro.

		MOVLW		H'07'			;carga el registro W con 07		0000 0111
		MOVWF		CMCON			;CMCON ->	C2OUT	C1OUT	C2INV	C1INV	CIS	 CM2  CM1  CM0
									; ver los modos de operacion de los comparadores
									; comparadores apagados
									;CLRF		TRISA			;Puerto A como salida		0 - salida; 1 - entrada
		MOVLW		H'FF'
		MOVWF		TRISA		
		CLRF		TRISB			;Puerto B como salida		0 - salida; 1 - entrada

		BCF			STATUS,RP0		;Selecciona Banco 0

;###################### CONFIGURANDO EL CONVERTIDOR A/D ################################

									;1.	Configure el modulo A/D
									;		•	Configurar E/S analógica/digital 	(ANSEL)	BANCO 1		
		BSF			STATUS,RP0		; selecciona banco 1
		MOVLW		H'FF'
		MOVWF		ANSEL			; Registro ANSEL - ANS6 ANS5 ANS4 ANS3 ANS2 ANS1 ANS0 
									; Configura la funcion de los pines de los puertos
									; pueden ser configurados como entradas analògicas 
									; (RA3,RA2 tambien pueden ser tensiones de referencia)
									; o como entradas/salidas digitales; 
									;	1 - analog I/O; 
									;	0 - digital I/O
									; 
		MOVLW		H'00'							;		
		MOVWF		ADCON1			;		•	Configurar tensión de referencia. 	(ADCON1)	BANCO 1
									; ADCON1:	ADFM	ADCS2	VCFG1   	VCFG0	-	-	-	-
									; Bit 7	ADFM: selección de bit de resultado de formato A/D
									; 				1=justificación derecha: los seis bits mas significantes de ADRESH son leídos como ‘0’
									; 				0=justificación izquierda: los seis bits menos significativos de ADRESL son leidos como ‘0’.	*justificacion izquierda
									; Bit 6	ADSC2: bit de selección de división de reloj por 2 del A/D
									;				1=fuente de reloj es dividida por 2 cuando el sistema de reloj es usado.
									; 				0=deshabilitado.																*deshabilitado
									; Bit 5-4	VCFG <1:0> bits de configuración de las tensiones de referencia del A/D
									; 				Estado lógico    VREF+ VREF- 
									; 				00                   AVDD  AVSS		*Elegimos este
									; 				01                   AVDD   VREF-
									; 				10                   VREF+   AVSS
									; 				11                   VREF+   VREF-
									; Bit  3-0	Sin implementación leídos como ‘0’

									;primero vamos a poner el ADSC2=0, pero creo que en el reset es 0 :)							

		BCF			STATUS,RP0		;seleccionamos banco 0

		MOVLW		H'C0'
		MOVWF		ADCON0			;		•	Seleccionar canal de entrada A/D 	(ADCON0)	BANCO 0

									; ADCON0:	ADSC1 	ADCS0	CHS2	CHS1	CHS0	DO/DONE	-	ADON
									;Bit 7-6	ADSC<1:0> selección de bits del reloj de conversión
									;	If ADSC2=0
									;		00 Fosc/2
									;		01 Fosc/8
									;		10 Fosc/32
									;		11 FRC (reloj derivado del oscilador interno RC del modulo A/D) 
									;	if ADSC2=1
									;		00 Fosc/4
									;		01 Fosc/16
									;		10 Fosc/64
									;		11 FRC (reloj derivado del oscilador interno RC del modulo A/D) 
									;Bit 5-3	CHS <2:0> selección de bits para los canales analógicos
									;		000 canal 0 (RA0/AN0)
									;		001 canal 1 (RA1/AN1)
									;		010 canal 2 (RA2/AN2)
									;		011 canal 3 (RA3/AN3)
									;		100 canal 4 (RA4/AN4)
									;		101 canal 5 (RB6/AN5)
									;		110 canal 6 (RB7/AN6)
									;Bit 2	GO/DONE_ bit de estado de la conversión (A/D)
									;		If ADON=1
									;					1=la conversión esta en progreso (poniendo a ‘1’ este bit empieza la conversión
									;					0=la conversión no esta en progreso (este bit es puesto a ‘0’ por hardware cuando la conversión es completada
									;Bit 1 	Sin implementar: leído como ‘0’
									;Bit 0	ADON: bit de encendido del A/D
									;					1=modulo convertidor A/D esta operando
									;					0=modulo convertidor esta apagado y no consume corriente de operación.
	
		;hecho arriba					;		•	Seleccionar reloj de conversión A/D	(ADCON0)



;####################### EMPIEZA LA CONVERSION #############################

		BSF			ADCON0,ADON	;		•	Encienda el modulo A/D 	(ADCON0)
									;2.	Configurar interrupción A/D (si se desea)
									;		•	Poner a ‘0’ bit ADIF
		;no deseamos				;		•	Poner a ‘1’ bit ADIE
									;		•	Poner a ‘1’ bit PEIE
									;		•	Poner a ‘1’ bit GIE
REG		CALL 		RETRASO		;3.	Esperar el tiempo de adquisición requerido
									;4.	Empezar conversión.
		BSF			ADCON0,GO		;		•	Poner a ‘1’ bit GO/DONE_ (ADCON0)
ESP		BTFSC		ADCON0,GO		;5.	Esperar para completar la conversión A/D, por cualquiera de los siguientes:
		GOTO		ESP				;		•	Poleando (modo poleo o de ciclo) para que el bit GO/DONE_ sea puesto a ‘0’ (con interrupción deshabilitada)
									;		•	Esperando por interrupción de A/D
		MOVFW		ADRESH			;6.	Leer el registro par que da el resultado de la conversión. (ADRESH:ADRESL); en este caso nos mostrara los 8 bits mas significativos debido a la justificacion izquierda
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
