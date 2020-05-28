          org    $100
porta     equ    $1000 ; direccion puerto A
portb     equ    $1004 ; direccion puerto B

inicio    ldaa   porta  ; carga el acumulador A con lo que hay en $1000
          anda   #$01   ; AND A with memory  A*M => A
                         ; 0  0  0  0   0  0  0  1 => #$01
                         ; a7 a6 a5 a4 a3 a2 a1 a0 => puertoA

                         ; revisa el pin a1
          JSR    DELAY20M

          anda   #$01   ; AND A with memory  A*M => A
                        ; 0  0  0  0   0  0  0  1 => #$01
                        ; a7 a6 a5 a4 a3 a2 a1 a0 => puertoA
          bne    inicio    ; branch no equal a inicio ; salta si no son iguales
          inc    portb     ; si son iguales continua ... incrementa el puerto B ; CORRESPONDE A ACCION EN EL DIAGRAMA

regreso    anda   #$01   ; AND A with memory  A*M => A
                        ; 0  0  0  0   0  0  0  1 => #$01
                        ; a7 a6 a5 a4 a3 a2 a1 a0 => puertoA
          beq    regreso

          JSR    DELAY20M
          bra    inicio    ; branch always a inicio

DELAY20M   LDX #$0000
LAZO       DEX
           BNE LAZO
           RTS
