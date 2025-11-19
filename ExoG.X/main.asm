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

decl_tab CODE 0x0100
Table
MOVLW 0x00
MOVWF BSR
MOVLW 0x01
MOVWF PCLATH
RLNCF i, 0 ; modification du Program Counter pour
ADDWF PCL  ; aller pointer vers l?un des instructions RETLW qui suit
RETLW 0x18
RETLW 0x04
RETLW 0x02
RETLW 0x0f
RETLW 0x10
RETLW 0x65
RETLW 0x21
RETLW 0x03

MAIN_PROG CODE                      ; let linker place main program
    
MAIN
    CLRF i
    MOVLW 8
    MOVWF taille_tableau
    DECF min

loop
    MOVF taille_tableau,0
    CPFSLT i ; Continue la boucle si i < taille_tableau
    GOTO stop

    CALL Table ; Load la valeur voulue
    
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