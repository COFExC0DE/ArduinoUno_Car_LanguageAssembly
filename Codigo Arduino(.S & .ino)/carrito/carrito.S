;Jose Pablo Barrinetos Rojas - 2014159894

;Sebas Retana Zúñiga - 2013007090

;Jefri Cárdenas - 2013101392

;Esteban Mora Soro - 2013113381

;Emmanuel Perez 

;PORTB = 0x05  va del 0,1,2,3,4,5 analogos(ademas pone en high los pines que en el binario tengan un 1)

;PORTD = 0x0b  va del 0,1,2,3,4,5,6,7(ademas pone en high los pines que en el binario tengan un 1)

;PINC  = 0x09  funciona diferente con Hexadecimal...(no creo que nos funcione para algo en este proyecto ya que es para los out en analogos)

;DDRB  = 0x04  va del 0,1,2,3,4,5(8,9,10,11,12,13)(prepara los pines para hacer un output)

;DDRD  = 0x0a  va del 0,1,2,3,4,5,6,7 (0,1,2,3,4,5,6,7)(prepara los pines para hacer un output)

; para poder usarlos en lugar de out ponemos sdi 0x05, y el numero en BYTE! del pin

; pines del 0 al 7
#define PORTD         0x0B 

; pines del 0 al 7
#define DDRD          0x0A 

; pines del 0 al 7
#define PIND          0x09

; pines del 8 al 13(bueno hasta el 17 pero no lo vamos a utilizar)
#define PORTB         0x05 

; pines del 8 al 13(bueno hasta el 17 pero no lo vamos a utilizar)
#define DDRB          0x04 

; pines del 8 al 13(bueno hasta el 17 pero no lo vamos a utilizar)
#define PINB          0x03 

;analogos(0 al 5)
#define PINC          0x06

;analogos(0 al 5)
#define DDRC          0x07
 
;analogos(0 al 5)
#define PORTC         0x08 

.extern proc()

  .global setup
  .global loop
 
setup:

  ;esta parte es solo para los motores
  
  ;pinMode(6, OUTPUT)
  ;pinMode(7, OUTPUT)
  ldi r19, 0b00000000      ;para tener lista el registro que vamos a utilizar en las salidas para mover el carro
  OUT DDRD,r19             ;cargamos en la parte D del arduno(los pines del 0 al 7)
  
  ;esta parte es solo para el sensor
  
  ;pinMode(9, OUTPUT)
  ldi r20, 0b00000010      ;para tener lista el registro que vamos a utilizar en las salidas para utilizar el senosr TRIGGER
  OUT DDRB, r20            ;cargamos en la parte B del arduno(solo el pin 9) 
  
  ;pinMode(8, INPUT)
  ldi r21, 0b00000001      ;para tener lista el registro que vamos a utilizar en las salidas para utilizar el senosr ECHO
  IN r20,DDRB              ;cargamos en la parte B del arduno(solo el pin 9) 

loop:
   
  jmp radar

  Delay:
    
    sbr   r16, 0xba          ;pedir memoria para hacer un timer
    
    sbr   r17, 0xba          ;pedir memoria para hacer un timer
    
    sbr   r18, 0xba          ;pedir memoria para hacer un timer
  
  wait:  
    
    dec   r16                ; DECREMENTAR r16
    
    brne  wait               ;regresar a saltar hasta que sea = a 0 if <> zero
    
    dec   r17                ; DECREMENTAR r17
    
    brne  wait               ;regresar a saltar hasta que sea = a 0  if <> zero
    
    dec   r18                ; DECREMENTAR r18
    
    brne  wait               ;regresar a saltar hasta que sea = a 0  if <> zero
    
    ret                      ; vuelve a la parte de la funcion que llamo a Delay
  
  Delay_TWO:
    
    clr r16
    
    clr r17
    
    sbr   r16, 0x70          ;pedir memoria para hacer un timer
    
    sbr   r17, 0x70          ;pedir memoria para hacer un timer
    
    sbr   r18, 0x70          ;pedir memoria para hacer un timer
    
  wait_TWO:  
    
    dec   r16                ; DECREMENTAR r16-1
    
    brne  wait               ;regresar a saltar hasta que sea = a 0 puede continuar if <> zero
    
    dec   r17                ; DECREMENTAR r17-1
    
    brne  wait               ;regresar a saltar hasta que sea = a 0 puede continuar if <> zero
    
    dec   r18                ; DECREMENTAR r18-1
    
    brne  wait               ;regresar a saltar hasta que sea = a 0 puede continuar if <> zero
    
    ret                      ; vuelve a la parte de la funcion que llamo a Delay
  
  ;mover hacia adelante
  radar:
  
    clr r24                   ;limpiar r24 y dejarlo en 0 r24 = 0  
    
    call proc                 ;llamar a la funcion de C para que el sensor funcione
    
    cpi r24,40                ;cpi compara inmediatos
    
    brlo STOP_MOTORS          ;si r24 < 9 esto quiere decir que tiene cerca una parad o un obstaculo y el carro va a chocar, por ello tiene que detenerse y dar vuelta 
    
    jmp ON_TWO_MOTORS         ; salta a ON_TWO_MOTORS para prender los 2 motores y avanzar hacia adelante
  
  ON_TWO_MOTORS:
   
    ldi r19, 0b11000000      ;PREPARA EL PIN 7 y 6
    
    out DDRD,r19             ;preparar los 2 pines 
    
    out PORTD, r19           ;poner en ON el pin 6 y 7
    
    call Delay_TWO
    
    jmp OFF_MOTORS              ;Salta a sensor para verificar si exite algun obstaculo para que el carrito no choque y dar vuelata a la izquierda
   
  ;mover a la izquierda
  LEFT_MOTOR:
  
    ldi r19,0b10000000       ;PREPARA EL PIN 7 y PONE EN OFF EL 6
    
    out DDRD,r19             ;cargar el pin 7
    
    out PORTD, r19           ;poner en ON el pin 7
    
    call Delay               ;tiempo
    
    jmp STOP_MOTOR_TWO       ;PARAR LOS 2 MOTORES IMPORTANTE DA TIEMPO PARA VERIFICAR SI HACIA LA IZQUIERDA EXITE OTRO OBSTACULO EN CASO DE NO HABER CONTINUA EL CARRITO
  
  
  ;mover a la derecha
  RIGHT_MOTOR:
  
    ldi r19,0b01000000       ;PREPARA EL PIN 6 y PONE EN OFF EL 79
    
    out PORTD, r19           ; poner en ON el pin 6
    
    call Delay               ;tiempo
    
    jmp STOP_MOTORS          ;parar motores
  
  ;que el cariito se pare 
  STOP_MOTORS:
  
    ldi r19,0b00000000        ;PONE EN OFF LOS PINES 7 y 6
    
    out DDRD,r19              ;cargar los 2 pines en 00
    
    out PORTD,r19             ;poner el off los 2 pines
    
    call Delay                ;tiempo
    
    jmp LEFT_MOTOR            ;salta a LEFT_MOTOR para poder dar vuelta para que no choque el cariito con la pared
  
  ;que el cariito se pare 
  OFF_MOTORS:
  
    ldi r19,0b00000000        ;PONE EN OFF LOS PINES 7 y 6
   
    out DDRD,r19              ;cargar los 2 pines en 00
    
    out PORTD,r19             ;poner el off los 2 pines
    
    jmp radar            ;salta a LEFT_MOTOR para poder dar vuelta para que no choque el cariito con la pared
    
  ;que el cariito se pare 
  STOP_MOTOR_TWO:
  
    ldi r19,0b00000000        ;PONE EN OFF LOS PINES 7 y 6
    
    out DDRD,r19              ;cargar los 2 pines en 00
    
    out PORTD,r19             ;poner el off los 2 pines
    
    call Delay                ;tiempo
    
    jmp radar                ;salta a sensor para ver si exite algun obstaculo en caso de no haber un obstaculo entonces sigue avanzando
    
  
  
