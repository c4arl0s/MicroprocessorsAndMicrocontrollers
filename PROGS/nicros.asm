             ORG    $0000
             LDAA   #$00
             LDAB   #$00
SIGUE        JSR    TIEMPO1
             INCA
             STAA   $1003
             CMPA   #$3C



             BNE    SIGUE
             LDAA   #00
             INCB
             STAB   $1000
             CMPB   #$64



             BNE    SIGUE
             LDAA   #$00
             LDAB   #$00
           ;  STAA   $00
           ;  STAB   $02
             RTI
TIEMPO1      LDX    #$6A
SIGUE1       NOP
             DEX
             BNE    SIGUE1
             RTS
