#include <Wire.h>
#include <VL53L0X.h>

VL53L0X distanceSensor;


void setup() {
  Serial.begin(9600);
  Wire.begin();
  distanceSensor.setTimeout(500);
  if (!distanceSensor.init()) {
    Serial.println("Failed to detect and initialize sensor!");
    while (1) {}
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  int dist = distanceSensor.readRangeSingleMillimeters();
  Serial.println(dist);
  delay(100);
}
