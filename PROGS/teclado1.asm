         ORG $100
PORTA    EQU $1000
PORTB    EQU $1004
MASKA    EQU $03
INICIO   CLR PORTB
         LDS #FINPRO+10
SECDEC   JSR RUTEC
         LDAA BANTEC
         BEQ SECDEC
PRUINC   LDAA REGTEC
         CMPA #$01
         BEQ INCREPB
         CMPA #$02
         BEQ DECREPB
         BRA SECDEC
INCREPB  INC PORTB
         BRA SECDEC
DECREPB  DEC PORTB
         BRA SECDEC
;xxxxxxxxxxxxxxxxxxxx
;
;XXXXXXXXXXXXXXXXXXXXX


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
         BEQ RUTEC2
         CLR BANTEC
         BRA SALTEC
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


REBOTE   LDX #$1000
REB1     DEX
         BNE REB1
         RTS

REGTEC   RMB 1
BANTEC   RMB 1
FINPRO   NOP
