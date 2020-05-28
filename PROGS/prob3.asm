        ORG  $100
        LDAA $200
        STAA $205
        ADDA
ROT     ROL  $205
        BRA  ROT
