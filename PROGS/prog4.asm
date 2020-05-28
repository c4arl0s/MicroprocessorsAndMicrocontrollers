


              ORG        $100
INICIO        LDX        #$50
              LDY        #$50
              LDAA       #$0A
              STAA        $50
              LDAA       #$02
              STAA        $51
              LDAA       #$0A
              STAA        $52
              LDAA       #$04
              STAA        $53
              LDAA        #$32
              STAA        $54
              LDAA        #$2F
              STAA        $55
              LDAA        #$02
              STAA        $56
              LDAA        #$1A
              STAA        $57
              LDAA        #$04
              STAA        $58
              LDAA        #$3B
              STAA        $59
              LDAA        #$FF
              STAA        $5A
              LDAA        #$00
              STAA        $5B
              LDAA        #$03
              STAA        $5C
              LDAA        #$04
              STAA        $5D
              LDAA        #$25
              STAA        $5E
              LDAA        #$0A
              STAA        $5F
              LDAA        #$2F
              STAA        $60
              LDAA        #$1C
              STAA        $61
              LDAA        #$02
              STAA        $62
              LDAA        #$1A
              STAA        $63
              LDAA        #$3B
              STAA        $64
              LDAA        #$FF
              STAA        $65
              LDAA        #$5A
              STAA        $66
              LDAA        #$1D
              STAA        $67
              LDAA        #$00
              STAA        $68
              LDAA        #$80
              STAA        $69
              LDAA        #$24
              STAA        $6A
              LDAA        #$2C
              STAA        $6B
              LDAA        #$4B
              STAA        $6C
              LDAA        #$3B
              STAA        $6D
              LDAA        #$1A
              STAA        $6E
              LDAA       #$30
              STAA        $6F

REGRE         LDAA        $00,X
              LDAB        $00,Y

              CBA

INCRE         INX

              BEQ         FIN
              CMPA       $00,X

              BRA        INCRE
VUELTA        STAA       $70


              CBA
              BEQ        VUELTA
              BCS        ALOTRO
ALOTRO        STAA       $71
              BGE        REGRE

              INY



FIN           BRA         FIN



