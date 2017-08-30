extern "C" {

 int proc(void);
  
};
 int proc(void){
    
    Serial.begin(9600);  /*Es para poder hacer print, en el serial monitor*/
    
    long tiempo;        /*guarda el tiempo del pulsein*/
    
    int distancia;      /*para que guarde el int de la distancia*/
 
    digitalWrite(9,LOW); /* estabilizar sensor*/
    
    delayMicroseconds(5);
    
    digitalWrite(9, HIGH); /*pulso ultrasónico*/
    
    delayMicroseconds(10);
    
    tiempo=pulseIn(8, HIGH); /* Mide cuanto tiempo a transcurrido desde el envío del pulso hasta cuando el sensor recibe el rebote*/
    
    distancia= int(0.017*tiempo); /*distancia obteniendo la guarda en una variable int, esto en ensamblador se va a guardar en r24 o r25*/
    
    Serial.println(distancia);/*hace print de la ditancia por el serial monitor*/
    
    Serial.println(" cm");
    
    delay(1000);
    
    return distancia;/*regresa o gurada en el r24 el int de la distancoia en cm desde el sensor a un objeto*/
 }
  
 
