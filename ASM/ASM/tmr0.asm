;*******************************************
;*        http://www.electron.es.vg        *
;*******************************************
;*         EJEMPLO 4: USO DEL TMR0         *
;*******************************************
;* Este programa crea una señal cuadrada a *
;* la salida RB0, para ello utiliza el TMR0*
;* y la interrupción por desbordamiento del*
;* mismo. Se le asignará el prescaler con  *
;* un factor de división de 1/2. De esta   *
;* forma las interrupciones saltarán a     *
;* intervalos fijos de tiempo. Invirtiendo *
;* el estado de RB0 durante las            *
;* interrupciones se conseguirá una onda   *
;* cuadrada perfecta                       *
;*******************************************
			list	p=16F84a


OPTIONR	EQU		01H	;Registro para configuración del TMR0
STATUS		EQU		03H
TRISB		EQU		06H
PORTB		EQU		06H
INTCON		EQU		0BH

ACUM		EQU		0CH
STAT		EQU		0DH

F			EQU		1
w			EQU		0

#DEFINE	BANCO0	BCF	STATUS,5
#DEFINE	BANCO1	BSF	STATUS,5



			ORG	00H
			GOTO		INICIO		;ponemos este GOTO al principio para poder poner
			 						;el subprograma de las interrupciones a partir de
			 						;la dirección 04h

;########################################################################
INICIO		BANCO1		 			;Pasamos al banco 1
			BCF			TRISB,0	 	;RB0 como salida
			BCF			OPTIONR,3 	;Asignamos el preescaler a TMR0
			BCF			OPTIONR,0 	;\
			BCF			OPTIONR,1 	; }Prescaler a 1/2
			BCF			OPTIONR,2 	;/
			BCF			OPTIONR,5 	;Entrada de TMR0 por ciclo de
			 						;instrucción interna (se pone a contar)
			BANCO0		 			;Volvemos al banco 0
	
			 						;Configuración de las interrupciones:
			 						;====================================

			BSF			INTCON,7 			;Habilita las interrupciones globalmente
			BSF			INTCON,5 			;Habilita la interrupción por desbordamiento de TMR0

			 						;====================================
			 						;ya están configuradas las interrupciones, a
			 						;partir de ahora cuando cuando se desborde TMR0
			 						;saltará la interrupción (a la dirección 04h de
			 						;programa)

NADA		GOTO		NADA	 	;En este ejemplo no se hace nada en el programa
			 						;principal, simplemente se espera a que salte la
			 						;interrupción. La verdadera utilidad de las
			 						;interrupciones es que se pueden hacer "cosas"
			 						;mientras sin preocuparse de las interrupciones


			END		 				;FIN DE PROGRAMA
;########################################################################

;################COMIENZA LA INTERRUPCION #####################################

		ORG			04H	 			;El pic salta a esta dirección cuando se produce
			 						;una interrupción
		BCF			INTCON,2  		;bit que indica desbordamiento de TMR0, recuerda
			 						;que hay que ponerlo a "0" por programa, este es
			 						;el momento

			 						;comenzamos guardando el contenido del acumulador
			 						;y del STATUS para restaurarlos antes de salir de
			 						;la interrupción (es recomendable hacer esto
			 						;siempre que se usen interrupciones)

		MOVWF		ACUM	 		;Copia el acumulador al registro ACUM
		MOVF		STATUS,W 		;Guarda STATUS en el acumulador
					BANCO0		 	;Por si acaso, nunca se sabe en que parte de
			 						;programa principal salta la interrupción
		MOVWF		STAT	 		;Copia el acumulador al registro STAT

			 						;Para generar una onda cuadrada Invertimos el
                         						;estado de RB0 cada vez que salta una interrupción
			 						;=================================================

		BTFSC		PORTB,0  		;si RB0 es "0" salta la siguiente instrucción
		GOTO		ESUNO	 		;vete a ESUNO
		BSF			PORTB,0	 		;Pon a "1" RB0 (porque era "0")
		GOTO		HECHO	 		;ya está invertido RB0, vete a HECHO

ESUNO	BCF			PORTB,0	 		;Pon a "0" RA0 (Porque era "1")

			 						;Ya se ha invertido el estado de RB0
			 						;===================================

			 						;ahora hay que restaurar los valores del STATUS y
			 						;del acumulador antes de salir de la interrupción:

HECHO	MOVF		STAT,W	 		;Guarda el contenido de STAT en el acumulador
		MOVWF		STATUS	 		;Restaura el STATUS
		SWAPF		ACUM,F	 		;Da la vuelta al registro ACUM
		SWAPF		ACUM,W	 		;Vuelve a dar la vuelta al registro ACUM y restaura
			 						;el acumulador (Con la instruccion SWAPF para no
			 						;alterar el STATUS, la instrucción MOVF altera el
			 						;bit 2 del STATUS)
		RETFIE		 				;fin de la interrupción

			 						;Fin de la interrupción
			 						;======================
