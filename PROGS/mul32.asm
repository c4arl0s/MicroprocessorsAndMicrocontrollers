     ORG  $100
C1   EQU  $20D
C2   EQU  $20E
N1L  EQU  $201
N1H  EQU  $200
N2L  EQU  $203
N2H  EQU  $202
D1   EQU  $205
D2   EQU  $206
D3   EQU  $207
D4   EQU  $208
D5   EQU  $209
D6   EQU  $20A
D7   EQU  $20B
D8   EQU  $20C
RH1  EQU  $210
RH2  EQU  $211
RL1  EQU  $212
RL2  EQU  $213
     CLR  C1
     CLR  C2
     LDAA N1L
     LDAB N2L
     MUL
     STD  D1
     LDAA N1H
     LDAB N2L
     MUL
     STD  D3
     LDAA N1L
     LDAB N2H
     MUL
     STD  D5
     LDAA N1H
     LDAB N2H
     MUL
     STD  D7
     LDAA D2
     STAA RL2
     LDAA D1
     LDAB D4
     ABA
     BCC  NC1
     INC  C1
NC1  LDAB D6
     ABA
     BCC  NC2
     INC  C1
NC2  STAA  RL1
     LDAA D3
     LDAB D5
     ABA
     BCC  NC3
     INC  C2
NC3  LDAB D8
     ABA
     BCC  NC4
     INC  C2
NC4  LDAB C1
     ABA
     BCC  NC5
     INC  C2
NC5  STAA RH2
     LDAA D7
     LDAB C2
     ABA
     STAA RH1
FIN  BRA  FIN

