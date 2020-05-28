;*******************************************
;*       http://www.electron.es.vg         *
;*******************************************
;*    EJEMPLO 3: USO DE INTERRUPCIONES     *
;*******************************************
;* Este programa invierte el estado del pin*
;* RA0 cada vez que se modifica el estado  *
;* de alguno de los pines RB4, RB5, RB6 o  *
;* RB7. Para ello habilita la interrupción *
;* por cambio de RB4-RB7                   *
;*******************************************


STATUS	EQU	03H
TRISA	EQU	05H
PORTA	EQU	05H
TRISB	EQU	06H
PORTB	EQU	06H
INTCON	EQU	0BH

ACUM	EQU	0CH
STAT	EQU	0DH

F	EQU	1
w	EQU	0

#DEFINE	BANCO0	BCF	STATUS,5
#DEFINE	BANCO1	BSF	STATUS,5



	ORG	00H
	GOTO	INICIO	 ;ponemos este GOTO al principio para poder poner
			 ;el subprograma de las interrupciones a partir de
			 ;la dirección 04h

			 ;Comienza la interrupción:
			 ;=========================

	ORG		04H	 ;El pic salta a esta dirección cuando se produce
			 ;una interrupción
	BCF	INTCON,0 ;bit que indica un cambio en RB4-RB7, recuerda que
			 ;hay que ponerlo a "0" por programa, este es el
			 ;momento

			 ;comenzamos guardando el contenido del acumulador
			 ;y del STATUS para restaurarlos antes de salir de
			 ;la interrupción (es recomendable hacer esto
			 ;siempre que se usen interrupciones)

	MOVWF	ACUM	 ;Copia el acumulador al registro ACUM
	MOVF	STATUS,W ;Guarda STATUS en el acumulador
	BANCO0		 ;Por si acaso, nunca se sabe en que parte de
			 ;programa principal salta la interrupción
	MOVWF	STAT	 ;Copia el acumulador al registro STAT

			 ;Invertimos el estado de RA0:
			 ;============================

	BTFSC	PORTA,0  ;si RA0 es "0" salta la siguiente instrucción
	GOTO	ESUNO	 ;vete a ESUNO
	BSF	PORTA,0	 ;Pon a "1" RA0 (porque era "0")
	GOTO	HECHO	 ;ya está invertido RA0, vete a HECHO

ESUNO	BCF	PORTA,0	 ;Pon a "0" RA0 (Porque era "1")

			 ;Ya se ha invertido el estado de RA0
			 ;===================================

			 ;ahora hay que restaurar los valores del STATUS y
			 ;del acumulador antes de salir de la interrupción:

HECHO	MOVF	STAT,W	 ;Guarda el contenido de STAT en el acumulador
	MOVWF	STATUS	 ;Restaura el STATUS
	SWAPF	ACUM,F	 ;Da la vuelta al registro ACUM
	SWAPF	ACUM,W	 ;Vuelve a dar la vuelta al registro ACUM y restaura
			 ;el acumulador (Con la instruccion SWAPF para no
			 ;alterar el STATUS, la instrucción MOVF altera el
			 ;bit 2 del STATUS)
	RETFIE		 ;fin de la interrupción

			 ;Fin de la interrupción
			 ;======================


INICIO	BANCO1		 ;Pasamos al banco 1
	MOVLW	0FFH	 ;Todos los bits del acumulador a "1"
	MOVWF	TRISB	 ;configuramos todo el puerto B como entradas
	BCF	TRISA,0	 ;RA0 como salida
	BANCO0		 ;Volvemos al banco 0
	
			 ;Configuración de las interrupciones:
			 ;====================================

	BSF	INTCON,7 ;Habilita las interrupciones globalmente
	BSF	INTCON,3 ;Habilita la interrupción por cambio de puerto B

			 ;====================================
			 ;ya están configuradas las interrupciones, a
			 ;partir de ahora cuando haya un cambio en RB4-RB7
			 ;saltará la interrupción (a la dirección 04h de
			 ;programa)

NADA	GOTO	NADA	 ;En este ejemplo no se hace nada en el programa
			 ;principal, simplemente se espera a que salte la
			 ;interrupción. La verdadera utilidad de las
			 ;interrupciones es que se pueden hacer "cosas"
			 ;mientras sin preocuparse de la interrupción


	END		 ;FIN DE PROGRAMA






