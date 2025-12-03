
    #include "p18f23k20.inc"

; CONFIG1H
  CONFIG  FOSC = INTIO7         ; Oscillator Selection bits (External RC oscillator, port function on RA6)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
;  CONFIG  PWRTEN = OFF          ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 18             ; Brown Out Reset Voltage bits (VBOR set to 1.8 V nominal)

; CONFIG2H
  CONFIG  WDTEN = OFF            ; Watchdog Timer Enable bit (WDT is always enabled. SWDTEN bit has no effect)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
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
    incr RES 1
    LEDs RES 1

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
    
    MOVLW b'11110000'
    
    MOVWF TRISA ; Configuration de TRISA et TRISC
    MOVWF TRISC ; 4 bits de poids faible a 0 => acces aux 4 leds
    
    BSF ANSEL, ANS4 ; Désactivation de l'input digital pour RA5
    
    MOVLW b'00010001'
	; xx : Non implémenté
	; 0100 : AN4
	; 0 : Conversion status (don't set)
	; 1 : ADC activé
    MOVWF ADCON0
    
    CLRF ADCON1 ; Tensions données en interne
    
    MOVLW b'00100100'
	; 0 : Left-justified
	; x : Non implémenté
	; 100 : 8 Tad
	; 100 : Fosc / 4
    MOVWF ADCON2
    
loop
    BSF ADCON0, GO ; Mise en route du convertisseur
    poll
	BTFSC ADCON0,GO ; Test de fin de conversion
	BRA poll ; Si non fini, boucle
    MOVFF ADRESH, LEDs ; Récupération des 8 bits les plus hauts
    
    CLRF LATA ; Clear LEDs
    CLRF LATC
    
    CLRF incr
    
    MOVLW 0x1f
    CPFSLT LEDs
    BSF LATC, 3
    
    MOVLW 0x3f
    CPFSLT LEDs
    BSF LATC, 2
    
    MOVLW 0x5f
    CPFSLT LEDs
    BSF LATC, 1
    
    MOVLW 0x7f
    CPFSLT LEDs
    BSF LATC, 0
    
    MOVLW 0x9f
    CPFSLT LEDs
    BSF LATA, 3
    
    MOVLW 0xbf
    CPFSLT LEDs
    BSF LATA, 2
    
    MOVLW 0xdf
    CPFSLT LEDs
    BSF LATA, 1
    
    MOVLW 0xff
    CPFSLT LEDs
    BSF LATA, 0
	
    BRA loop

    END