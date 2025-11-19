; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED
    
INT_VAR	    UDATA_ACS
   somme_High RES 1
   somme_Low RES 1
   i RES 1

MAIN_PROG CODE                      ; let linker place main program
 
; Sous-programme
calcul_somme
    CLRF somme_High ; Met somme à 0
    CLRF somme_Low
    MOVWF i ; Met i à la valeur de W
    GOTO loop ; Commence la boucle
    
add_int
    MOVF i, 0 ; Met i dans WREG
    ADDWF somme_Low ; Ajoute W (donc i) à somme
    
    MOVLW 0 ; On remet W à 0
    ADDWFC somme_High ; On ajoute le bit de carry à somme_High (et W, qui vaut 0)
    
    DECF i ; Décrémente i
    GOTO loop ; Retourne à la boucle

loop
    
    TSTFSZ i ; Teste si i = 0
    GOTO add_int ; Si non, on continue la boucle
    
    RETURN ; Retourne au programme principal

START
    MOVLW 0x28 ; 28 en hexadécimal = 40 en décimal

    CALL calcul_somme
    
    END