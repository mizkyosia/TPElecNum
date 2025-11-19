; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED
    
INT_VAR	    UDATA_ACS
   somme RES 1
   i RES 1

MAIN_PROG CODE                      ; let linker place main program

START

    CLRF somme ; Met somme à 0
    MOVLW 0x14 ; 14 en hexadécimal = 20 en décimal
    MOVWF i ; Met i à 20
    GOTO loop ; Commence la boucle
    
add_int
    MOVF i, 0 ; Met i dans WREG
    ADDWF somme ; Ajoute W (donc i) à somme
    DECF i ; Décrémente i
    GOTO loop ; Retourne à la boucle

loop
    
    TSTFSZ i ; Teste si i = 0
    GOTO add_int ; Si non, on continue la boucle
    
    END