           ORG $100  ; origen en dir $100
PORTA      EQU $00   ; equivalencia portA =00
PORTB      EQU $04   ; equivalencia portB =04
DDRA       EQU $01   ; equivalencia data direction registrer
INICIO     LDX #$1000   ; carga registro X con valor  direccion $1000
           LDAA #$FF    ; carga ac}unudador A con valor FF
           STAA DDRA,X  ; saca lo que hay en el acumulador A en la salida
           LDAA #$AA    ; carga el acumulador A con el valor AA
           STAA PORTB,X ; saca por el acumulador A por el puerto B
           BRA INICIO   ; BIFURCA A INICIO