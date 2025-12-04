
    #include "p18f23k20.inc"

; CONFIG1H
  CONFIG  FOSC = INTIO7         ; Oscillator Selection bits (External RC oscillator, port function on RA6)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 18             ; Brown Out Reset Voltage bits (VBOR set to 1.8 V nominal)

; CONFIG2H
  CONFIG  WDTEN = OFF            ; Watchdog Timer Enable bit (WDT is always enabled. SWDTEN bit has no effect)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTBE        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  HFOFST = ON           ; HFINTOSC Fast Start-up (HFINTOSC starts clocking the CPU without waiting for the oscillator to stablize.)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection Block 0 (Block 0 (000200-000FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection Block 1 (Block 1 (001000-001FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0001FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000200-000FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (001000-001FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0001FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000200-000FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (001000-001FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0001FFh) not protected from table reads executed in other blocks)
  
  
 INT_VAR UDATA_ACS
    payload RES 1

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    MAIN_CODE                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

MAIN_CODE

    MOVLW b'01010010' ; Configuration de l'oscillateur
	; 0 : mode Sleep lors de l'instruction SLEEP (inutilisï¿½)
	; 101 : frï¿½quence de 4MHz (1M instructions / s)
	; 0 : Oscillateur interne
	; 0 : inutilisï¿½
	; 1x : Bloc mï¿½moire de l'oscillateur interne
    MOVWF OSCCON
    
    BCF BAUDCON, DTRXP ; Non inversé
    BCF BAUDCON, CKXTP ; Etat haut par défaut
    BCF BAUDCON, ABDEN ; Pas d'auto-détection
    BCF BAUDCON, BRG16 ; Baud rate sur 8 bits
    
    BSF TXSTA, BRGH ; Haute Baud rate
    
    ; Br = Fosc / (16 * (SPBRG+1))
    ; SPBRG = Fosc / (Br * 16) - 1
    ;	    = 4MHz / (16 * 9600) - 1 = 25.04 = 25
    ; Br = 4MHz / (16 * 25) = 9615 Bauds
    MOVLW d'25'
    MOVWF SPBRG
    
    BCF TXSTA, TX9 ; Transmission sur 8 bits
    BCF TXSTA, SYNC ; Asynchrone
    BSF TXSTA, TXEN ; Transmission activée
    
    BCF RCSTA, RX9 ; Réception sur 8 bits
    BSF RCSTA, SPEN ; Ports activés
    BSF RCSTA, CREN ; Réception activée
    
    MOVLW 0x0
    MOVWF payload
    
    loop
	MOVF payload, 0
	INCF WREG ; Incrémentation du payload
	MOVWF TXREG ; Envoi du payload
    
	wait
	    BTFSS PIR1, RCIF ; Attente tant que le payload n'a pas été reçu
	    BRA wait
	    NOP
	MOVFF RCREG, payload ; Lecture du payload reçu. Devrait être l'ancien payload + 1
	
	BRA loop
    END