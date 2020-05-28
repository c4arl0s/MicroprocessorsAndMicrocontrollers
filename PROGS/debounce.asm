          ORG   $100
PORTA     EQU   $1000
PORTB     EQU   $1004
INICIO    LDAA   PORTA
          ANDA #$01
          BNE    INICIO
          JSR    RETRASO
         ; ANDA #$01
         ; BNE    INICIO
         ; JSR    RETRASO
          INC    PORTB
          ;SWITCH    ANDA #$01
          ;BEQ    SWITCH
          JSR    RETRASO
          BRA    INICIO
RETRASO   LDX  #$0000
RETRO     DEX
          BNE    RETRO
          RTS
