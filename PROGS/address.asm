                  ORG      $E000        ;define start address
                  CLRA                  ;clears ACCA
                  INCB                  ;increment ACCB
                  XGDY                  ;swap ACCD with IY
                  DEY                   ;decrement IY
CICLO             BRA      CICLO