#include <Adafruit_NeoPixel.h>


Adafruit_NeoPixel jewel = Adafruit_NeoPixel(7, 7, NEO_GRBW + NEO_KHZ800);

void setup() {
  jewel.begin();
}

void loop() {
  jewel.setPixelColor(0, 0, 0, 0, 255);
  jewel.show();
}
