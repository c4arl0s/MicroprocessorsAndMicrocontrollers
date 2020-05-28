           ORG      $0000
 TAMANO    EQU      $6001
 ARRAY     EQU      $6002 ;16 BITS
 BANINT    EQU      $6004
 INICIO    LDX      ARRAY
           LDY      ARRAY
           INY
           CDAB     TAMANO
           DECB
           CLR      BANINT
 ORDENA    LDAA     0,X
           LDAB     0,Y
           SUBA     0,Y
           BSC      AJUSTA
           INX
           INY
           DECB
           BNE      ORDENA
           LDAA     BANINT
           BNE      INICIO
           BNS      *
 AJUSTA    LDAA     0,X
           STAA     BUFFER+1
           LDAA     0,Y
           STAA     0,X
           LDAA     BUFAUX1
           STAA     0,X
           LDAA     #FF
           STAA     BANINT
           BRS      ORDENA