; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p18F23K20.inc"
    
RES_VECT  CODE    0x0000            ; processor reset vector
   GOTO    MAIN                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

INT_VAR UDATA_ACS
  min RES 1
  max RES 1
  i RES 1
  taille_tableau RES 1
 
tab_decl CODE 0x0100
tableau DB 0x18, 0x04, 0x02, 0x0f, 0x10, 0x65, 0x21, 0x03

MAIN_PROG CODE                      ; let linker place main program
    
MAIN
    CLRF i
    MOVLW 8
    MOVWF taille_tableau
    DECF min
    
    MOVLW 0x01
    MOVWF TBLPTRH ; Pointe la table vers 0x100

loop
    MOVF taille_tableau,0
    CPFSLT i ; Continue la boucle si i < taille_tableau
    GOTO stop

    TBLRD*+ ; Lit la mémoire à l'emplacement, puis incrémente le pointuer
    MOVF TABLAT, 0 ; Met la valeur dans WREG
    
    ; Min
    CPFSLT min ; Si le nombre actuel < l'ancien min,
    MOVWF min  ; on définit le nouveau min
    
    ; Max
    CPFSGT max ; Si le nombre actuel > l'ancien max,
    MOVWF max  ; on définit le nouveau max
    
    INCF i ; i++
    
    GOTO loop
stop
    NOP
    END