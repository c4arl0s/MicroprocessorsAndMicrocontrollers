         ORG  $00EB
         JMP  FLASHB

         ORG $100
PORTA    EQU $1000
PORTB    EQU $1004
MASKA    EQU $03
TMSK2    EQU $1024
TFLG2    EQU $1025
PACTL    EQU $1026

INICIO   CLR PORTB
         CLR BANFLASH
         LDAA #$40
         STAA TMSK2
         LDAA #$03
         STAA  PACTL

         ;LDS #FINPRO+10
SECDEC   JSR RUTEC
         LDAA BANTEC
         BEQ SECDEC
PRUINC   LDAA REGTEC
         CMPA #$01
         BEQ INCREPB
         CMPA #$02
         BEQ DECREPB
         CMPA #03
         BEQ  FLASH
         BRA SECDEC
INCREPB  INC PORTB
         SEI
         BRA SECDEC
DECREPB  DEC PORTB
         SEI
         BRA SECDEC
FLASH    CLI
         BRA SECDEC


RUTEC    CLR BANTEC
         LDAA PORTA
         ANDA #MASKA
         CMPA #MASKA
         BEQ SALTEC
         BSR REBOTE
         LDAA PORTA
         ANDA #MASKA
         CMPA #MASKA
         BEQ SALTEC
         CLR REGTEC
         STAA BANTEC
         CMPA #$02
         BNE RUTEC1
         INC REGTEC
         CLR BANTEC
         DEC BANTEC
         BRA SALTEC
RUTEC1   CMPA #$01
         BNE  RUTEC3
         ;BEQ RUTEC2
         ;CLR BANTEC
         ;BRA SALTEC
RUTEC2   INC REGTEC
         INC REGTEC
         CLR BANTEC
         DEC BANTEC
SALTEC   LDAA PORTA
         ANDA #MASKA
         CMPA #MASKA
         BNE SALTEC
         BSR REBOTE
         RTS

RUTEC3   CMPA #$00
         BEQ  RUTEC4
         CLR  BANTEC
         BRA  SALTEC
RUTEC4   INC  REGTEC
         INC  REGTEC
         INC  REGTEC
         CLR  BANTEC
         DEC  BANTEC
         BRA  SALTEC

REBOTE   LDX #$1000
REB1     DEX
         BNE REB1
         RTS

FLASHB   LDAA BANFLASH
         BEQ  APAGAB
         INC  BANFLASH
         LDAA #$FF
         STAA PORTB
         BRA FINRTI
APAGAB   DEC BANFLASH
         CLR  PORTB
FINRTI   LDAA  #$40
         STAA  TFLG2
         RTI


REGTEC   RMB 1
BANTEC   RMB 1
BANFLASH RMB 1
FINPRO   NOP
