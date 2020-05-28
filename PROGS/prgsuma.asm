           ORG $0000
centena    EQU $100 ;la memoria ram empieza en cero
decena     EQU $101
unidad     EQU $102
dato       EQU $103
           clr centena
           clr decena
           clr unidad
           LDAA      dato
cien       SUBA      #$64
           BCS       ajucien
           INC       centena
           BRA       cien
ajucien    ADDA      #$64
diez       SUBA      #$0A
           BCS       ajudiez
           INC       decena
           BRA       diez
ajudiez    ADDA      #$0A
           STAA      unidad
           BRA       *
