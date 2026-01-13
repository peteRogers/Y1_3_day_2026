#include <Wire.h>
#include "Adafruit_DRV2605.h"

Adafruit_DRV2605 drv;

void setup() {
  drv.begin();
  drv.setMode(DRV2605_MODE_INTTRIG); 
}


void loop() {
  
  drv.setWaveform(0, 72);  // play effect 
  drv.setWaveform(1,83);
  drv.setWaveform(2,0);
 // end waveform
  drv.go();
  
  delay(1000);
  
}
