__Config _WDT_OFF & _PWRTE_ON & _XT_OSC & _LVP_OFF & _CP_OFF
    List p=16F877A
    INCLUDE <P16F877A.INC> 
    Reset Org 0x00
    goto Inicio
    Org 0x04
    goto interrupcion
	
auxA equ 0x21
auxB equ 0x25 
resultadoA equ 0x23
resultadoB equ 0x24

Inicio
    ; Configurar los puertos B y C
    bsf STATUS, RP0       ; Seleccionar banco 1
    movlw b'00000011'     ; Configurar el puerto A como entrada
    movwf TRISA
    movlw b'00000000'     ; Configurar el puerto C como salida
    movwf TRISC
    movwf TRISD
    bcf STATUS, RP0       ; Volver al banco 0
    
    ;interrupcion
    movlw b'10010000'
    movwf INTCON 
    
   ;configuracion parcial de adcon0
    bsf ADCON0, 7    ;bit 7 y 6, para configuracion de frecuencia de reloj 
    bsf ADCON0, 6
    bcf ADCON0, 1    ;sin implementar A
    bsf ADCON0, 0    ;convertidor A/D activado
    
    bsf STATUS, RP0
    
    bcf ADCON1, 7 ;bit 7, justificación a la izquierda de bits. usar ADRESH
    bcf ADCON1, 6 ;bit 6,5,4 sin implementar
    bcf ADCON1, 5
    bcf ADCON1, 4
    bcf ADCON1, 3;bit 3,2,1,0 configurar pines como entrada analógica.(tabla)
    bsf ADCON1, 2
    bcf ADCON1, 1
    bcf ADCON1, 0
   
    bcf STATUS, RP0
    clrf PORTC
    clrf PORTD
    
    ;esperar conversion
    call Retardo_200ms
    
;el joystick primero debe moverse en eje x y despues en eje y   
;cuando eje x este en 5, eje y ya puede moverse 
;cuando eje y este en 5, el eje x ya puede moverse
   
   
Display_A
   ;iniciar conversion 
    bsf ADCON0, 2 
    
    ;configuracion del canal de entrada en RA0
    bcf 
    
    ADCON0, 5
    bcf ADCON0, 4
    bcf ADCON0, 3
    
    ;verificar que la conversion esté disponible 
    btfsc ADCON0,2
    goto Display_A 
    
    ;leer entrada POT1
    movf ADRESH, W
    movwf auxA  ;guardar valor para mapeo

    ;mapear entrada
    call testeo_A
    
    movwf resultadoA                ;mantiene el estado anterior válido
    movwf PORTC
    call Retardo_10micros   

    
Display_B
    ;iniciar conversion 
    bsf ADCON0, 2 
    
    ;configuracion de canal de entrada RA1
    bcf ADCON0, 5
    bcf ADCON0, 4
    bsf ADCON0, 3
    
    ;verificar que la conversión este disponible
    btfsc ADCON0,2
    goto Display_B

    ;leer entrada 
    movf ADRESH, W
    movwf auxB    ;guardar valor para mapeo
    
    call testeo_B                 ;mapear entrada
    movwf resultadoB              ;mantiene el estado anterior valido
    movwf PORTD
    call Retardo_10micros
   
    goto Display_A
    
    
testeo_A   
    ;comprobar 0
    movlw d'0'  ;0%   comparar con valor digital válida
    subwf auxA, w     
    btfsc STATUS, Z
    goto mostrar_0     ;ir al valor del display
    
     ;comprobar 1
    movlw d'28'  
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_1
    
     ;comprobar 2
    movlw d'51' 
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_2
     
    ;comprobar 3
    movlw d'76'  
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_3
    
    ;comprobar 4
    movlw d'102' 
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_4
    
    ;comprobar 5
    movlw d'127' 
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_5
    
    ;comprobar 6
    movlw d'153'  
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_6
    
    ;comprobar 7
    movlw d'179' 
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_7
    
    ;comprobar 8
    movlw d'204' 
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_8
    
    ;comprobar 9
    movlw d'230'  
    subwf auxA, w
    btfsc STATUS, Z
    goto mostrar_9
    
    ;si no es ninguno de los casos, retorna el estado anterior
    movf resultadoA, w
    return

testeo_B  
    ;comprobar 0
    movlw d'0'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_0
    
     ;comprobar 1
    movlw d'28'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_1
    
     ;comprobar 2
    movlw d'51'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_2
     
    ;comprobar 3
    movlw d'76'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_3
    
    ;comprobar 4
    movlw d'102' 
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_4
    
    ;comprobar 5
    movlw d'127' 
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_5
    
    ;comprobar 6
    movlw d'153'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_6
    
    ;comprobar 7
    movlw d'179' 
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_7
    
    ;comprobar 8
    movlw d'204' 
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_8
    
    ;comprobar 9
    movlw d'230'  
    subwf auxB, w
    btfsc STATUS, Z
    goto mostrar_9
    
    ;si no es ninguno de los casos,retorna el estado anterior
    movf resultadoB, w
    return    
    
    
;valores del display
mostrar_0
    retlw b'00111111'
    
mostrar_1
    retlw b'00110000'
    
mostrar_2
    retlw b'01011011'
    
mostrar_3
    retlw b'01001111'
 
mostrar_4
    retlw b'01100110'
    
mostrar_5
    retlw b'01101101'
    
mostrar_6
    retlw b'01111101' 
    
mostrar_7
    retlw b'00000111'
    
mostrar_8
    retlw b'01111111'
    
mostrar_9
    retlw b'01101111'     
    
interrupcion    
    movlw b'01111001'  ;valor E  7segmentos
    movwf PORTC
    movwf PORTD
      
    call Retardo_200ms
    call Retardo_200ms
    call Retardo_200ms
   
    bcf INTCON, INTF ;terminar interrupcion
    retfie

    include <Retardos.inc>
    end