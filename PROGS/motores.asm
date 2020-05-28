PORTB    EQU    $04
         LDX    #$1000

OTRAVEZ  LDAA   #$0F
         STAA   PORTB,X
         JSR    DELAY10

         LDAA   #$CF
         STAA   PORTB,X
         JSR    DELAY10

         LDAA    #$DF
         STAA    PORTB,X
         JSR     DELAY10

         LDAA   #$EF
         STAA   PORTB,X
         JSR    DELAY10

         LDAA   #$FF
STAA   PORTB,X
JSR    DELAY10
       BRA    OTRAVEZ

DELAY10 LDY    #$456
INLP    NOP
        DEY
        BNE    INLP  ;10X19e3=(4+9(*)+6 )
        RTS                             ; (*)=1110
                                         ; h456


