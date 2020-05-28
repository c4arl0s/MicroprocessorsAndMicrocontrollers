;***************************************************************
	; PROGRAMA PARA HACER FUNCIONAR EL MODULADOR DE ANCHO DE PULSOS PWM
	; mediante el A/D ponemos un potenciometro en un canal y en funcion de este, cambia el ciclo de trabajo del PWM
	; y enciende y apaga un led.
	;title	"PIC Sample code: PIC16F88 program"
	;subtitle	"CARLOS SANTIAGO CRUZ - TESIS - prueba del convertidor analógico digital"

;	codigo para el 16f88 a 4 MHz
;***************************************************************
	list	p=16F88
	#include	<p16F88.inc>
	
	__CONFIG   _CONFIG1 & _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO
	ERRORLEVEL -302
;***************************************************************
z1	equ	20h		;REGISTROS COMODINES
z2	equ	21h
z3	equ	22h
z4	equ	23h

#DEFINE	BANCO0	BCF	STATUS,5
#DEFINE	BANCO1	BSF	STATUS,5

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



;############### #### INICIALIZANDO EL MICROCONTROLADOR ###########################

INIT		CLRF		PORTA			; limpia puerto A
		CLRF		PORTB			; limpia puerto B

		BANCO1
		BSF			OSCCON,6		;Pone el oscilador a 4 MHz con el oscilador interno RC; OSCCON controla varios aspectos de operacion del sistema de reloj; Banco 1
		BSF			OSCCON,5		;bit 6-4		110		4 MHZ
									;al reset inicia con 0's el registro.
		BANCO1
		MOVLW		H'07'			;carga el registro W con 07		0000 0111
		MOVWF		CMCON			;CMCON ->	C2OUT	C1OUT	C2INV	C1INV	CIS	 CM2  CM1  CM0
									; ver los modos de operacion de los comparadores
									; comparadores apagados
									;CLRF		TRISA			;Puerto A como salida		0 - salida; 1 - entrada
		BANCO1
		CLRF		TRISB			;Puerto B como salida		0 - salida; 1 - entrada
		
	

;##############CONFIGURANDO EL MODULO PWM E INICIALIZANDO CICLO DE TRABAJO A 0%  #######################

		BANCO1
		MOVLW		H'3F'			;cargamos periodo, inicializando con
		MOVWF		PR2				;lo almacenamos en PR2
		
		BANCO0
		MOVLW		H'3A'			;cargamos los 8 bits mas significativos del ciclo de trabajo
		MOVWF		CCPR1L			;lo movemos al registro CCPR1L
		BSF			CCP1CON,5		;configuramos bit 1 del ciclo de trabajo, supon ‘1’
		BSF			CCP1CON,4		;configuramos el bit 0 del ciclo de trabajo, supon ‘1’, 
									;recordar que son diez bits 
	
		BANCO1
		MOVLW		H'00'
		MOVWF		TRISB			;configuramos como salida el pin CCP1
		
		BANCO0
		BCF			T2CON,T2CKPS0	;Ponga el valor del preescalador TMR2 (banco 0, 11h) 	
		BCF			T2CON,T2CKPS1	;Ponga el valor del preescalador TMR2 (banco 0, 11h) 	
		BSF			T2CON,TMR2ON		;habilita timer2

		BANCO0
		BSF			CCP1CON,CCP1M3		;configura modulo CCP1 para operación PWM
		BSF			CCP1CON,CCP1M2		;configura modulo CCP1 para operación PWM

		
		MOVLW		H'0F'
		MOVWF		PORTB			; inicializo con el puertoB encendido, algunos pines
SALTA	GOTO		SALTA
;#######################################################################

		
		END
