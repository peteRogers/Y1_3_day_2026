#include <Wire.h>
#include "Adafruit_DRV2605.h"

Adafruit_DRV2605 drv;

void setup() {
  Serial.begin(9600);
  drv.begin();
  drv.setMode(DRV2605_MODE_INTTRIG); 
}


void loop() {

  
}

void serialEvent() {
  if(Serial.available()){
      String s = Serial.readStringUntil('\n');
      int input = s.toInt();
      drv.stop();
      drv.setWaveform(0, input); 
      drv.go();
  }
}
