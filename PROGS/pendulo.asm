                        ORG $100

CONT                    EQU $180
PORTB                   EQU $1004
                        LDS #$0150
INICIO                  LDAA #$01
                        STAA PORTB
                        LDAA #7
                        STAA CONT

IZQ                     ROL PORTB
                        JSR RETRASO
                        DEC CONT
                        BNE IZQ
                        JSR RETRASO
                        LDAA #07
                        STAA CONT

DER                     ROR PORTB
                        JSR RETRASO
                        DEC CONT
                        BNE DER
                        JSR RETRASO
                        BRA INICIO

RETRASO                 LDX #$0000
RETRAS                  DEX
                        BNE RETRAS
                        RTS


