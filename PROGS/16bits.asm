            org $100
bufdat      equ $10
banint      equ $00
bufaux      equ $02
longitud    equ $01
temp0       equ $03
temp1       equ $05
inisort     ldx bufdat
            clr banint
            ldaa longitud
            deca
            deca
            lsra
            staa bufaux
            ldd 0,x
            inx
            inx
            subd 0,x
            bcc noajuste
            dec banint
            ldd 0,x
            std temp0
            dex
            dex
            ldd 0,x
            std temp1
            ldd temp0
            std 0,x
            inx
            inx
            ldd temp1
            std 0,x
noajuste    dec bufaux
            bne inisort
            ldaa banint
            bne inisort
            bra *

