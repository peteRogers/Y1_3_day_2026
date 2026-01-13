
#include "Adafruit_MPR121.h"

Adafruit_MPR121 cap = Adafruit_MPR121();

uint16_t lasttouched = 0;
uint16_t currtouched = 0;

void setup() {
  while (!Serial);        
  Serial.begin(9600);
  //Serial.println("Adafruit MPR121 Capacitive Touch sensor test"); 
  if (!cap.begin(0x5A)) {
      Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  cap.setAutoconfig(true);
}

void loop() {
  // Get the currently touched pads
 
  currtouched = cap.touched();
  for (uint8_t i=0; i<12; i++) {
    
    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
     
      Serial.print(i); 
      Serial.print(":"); 
      Serial.println("0");
      //delay(1);
    }
    if (!(currtouched & _BV(i)) && (lasttouched & _BV(i)) ) {
      
      Serial.print(i); 
      Serial.print(":"); 
      Serial.println("1");
      //delay(1);
    }
  }
  lasttouched = currtouched;
  
}
