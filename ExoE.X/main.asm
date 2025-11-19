; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p18F23K20.inc"
    
RES_VECT  CODE    0x0000            ; processor reset vector
   GOTO    MAIN                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

INT_VAR UDATA_ACS
  min RES 1
  max RES 1
  taille_tableau RES 1

MAIN_PROG CODE                      ; let linker place main program
 
ecrire_tableau
    MOVLW 0x01
    MOVWF FSR0H
    CLRF FSR0L ; Mise de FSR0 au pointeur 0x100
    
    MOVLW 0x18
    MOVWF POSTINC0 ; On met 0x18 (25) dans FSR0
    
    MOVLW 0x04
    MOVWF POSTINC0
    
    MOVLW 0x02
    MOVWF POSTINC0
    
    MOVLW 0x0f
    MOVWF POSTINC0
    
    MOVLW 0x10
    MOVWF POSTINC0
    
    MOVLW 0x65
    MOVWF POSTINC0
    
    MOVLW 0x21
    MOVWF POSTINC0
    
    MOVLW 0x03
    MOVWF POSTINC0
    
    MOVFF FSR0L, taille_tableau    
    RETURN ; Retourne taille_tableau
  
    
    
cherche_min
    CLRF FSR0L
    CLRF min
    DECF min
min_loop
    MOVF FSR0L, 0
    CPFSGT taille_tableau ; Tant que taille > FSR0L, on continue la boucle
    RETURN
    
    MOVF POSTINC0, 0 ; Load le nombre à l'index actuel du tableau
    CPFSLT min ; Si le nombre actuel < l'ancien min,
    MOVWF min  ; on définit le nouveau min
    
    GOTO min_loop
    

cherche_max
    CLRF FSR0L
    CLRF max
max_loop
    MOVF FSR0L, 0
    CPFSGT taille_tableau ; Tant que taille > FSR0L, on continue la boucle
    RETURN
    
    MOVF POSTINC0, 0 ; Load le nombre à l'index actuel du tableau
    CPFSGT max ; Si le nombre actuel > l'ancien max,
    MOVWF max  ; on définit le nouveau max
    
    GOTO max_loop

    
MAIN
    CALL ecrire_tableau
    
    CALL cherche_min
    
    CALL cherche_max

    END