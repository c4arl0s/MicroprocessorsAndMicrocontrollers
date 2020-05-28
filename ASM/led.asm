;------------------------------------------------------
;PROGRAMA PORTB.ASM
;Apagar y encender el puerto B cada segundo
;-------------------------------------------------------
	list p=16f84A					;identificar el micro usado.
	RADIX HEX
	#include <p16F84A.inc>			;archivo con los registros definidos.
 			
	org		0x00					;posición de memoria de comienzo del  re-
									;set ( 0000h ).
	clrf 	STATUS
reset								;etiqueta = posición de memoria.	
	goto	inicio					; salto a posición de memoria donde comien-
									;za el programa.
 
	org     0x05						;posición de memoria donde comienza el
									;programa ( 0010h ).
inicio								;etiqueta = dirección  0010h.

;-------------------------------------------------------
; configurar puerto B como salidas
;-------------------------------------------------------
	bsf	    STATUS,5				;pongo a uno el bit 5 del registro 
									;STATUS para entrar en el banco1.
	movlw	0x00					;cargo w con el dato 00h.		  	
	movwf	TRISB					;cargo el registro TRISB con el w para
									;hacer el puerto B como salida.
	bcf     STATUS,5				;pongo a cero el bit 5 del registro
									;STATUS para entrar en el banco 0.
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++
;PROGRAMA PRINCIPAL
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++
programa					;etiqueta de programa principal.	
	movlw 	b'01010101'			;carga w con el dato 00h	
	movwf 	PORTB			;manda w por el puerto B, y se apagan leds
 	call 		unseg			;subrutina de retardo de 1 seg.	
	movlw 	b'10101010'			;cargo w con el dato ffh.
	movwf 	PORTB			;cargo el registro PORTB con w, encienden leds
	call 		unseg			;subrutina del retardo de 1 seg.	
	goto	programa		;salta al comienzo del programa.   
;/////////////////////////////////////////////////////////
;RETARDOS
;------------------------------------------------
;RETARDOS
;------------------------------------------------
;ffh=255  goto=2 useg.    decfsz=1 useg.
; [1us(decfsz) +2us(goto)]*255 veces= 765 useg
;(765 x 765) + 255= 585480 useg.
;(585480 x 2) + 1= 1170961 useg.
;primero entra a un loop de 255 veces, despues entra a otro de 255, sale y 
; entra a un loop de una sola vez,
;completando el segundo.
;////////////////////////////////////////////////////////
; a continuación se preparan las direcciones donde se hará el conteo.

unseg					    		;etiqueta = subrutina del retardo de 1 seg.	
	movlw     0xff				;cargo w con el dato ffh.
	movwf    0x0c				;cargo la direccion con 0ch con el w.
      movwf    0x0d				;cargo la direccion con 0dh con el w.
	movlw     0x01				; cargo w con el dato 01h. 
	movwf    0x0e				; cargo el registro 0eh con w.
 
salto1							; etiqueta del bucle de repetición.								
		decfsz   0x0c,1			; decremento el registro 0ch y salto si es
								; cero depositando el resultado en 0ch.		       
    		goto	 salto1			; alto a la etiqueta salto1.
		decfsz   0x0d,1			; decremento el registro 0dh y salto si es
								; cero depositando el resultado en 0dh.	       
    		goto	 salto1			; salto a salto1.
		decfsz   0x0e,1			; decremento el registro 0eh y salto si es
								; cero depositando el resultado en 0eh.
    		goto	 salto1			; salto a salto1.
 		return					; regreso de subrutina.				
 
		
    		end				;fin del programa PORTB.	
;/////////////////////////////////////////////////////////////////
