#include <Unistep2.h>
Unistep2 stepper(8,9,10,11, 4096, 800);

void setup() {
  Serial.begin(115200);
  pinMode(13, OUTPUT);
}

void loop() {
 stepper.run();
 if(stepper.stepsToGo() == 0){
  stepper.stop();
 }
}


//receiving serial messages
void serialEvent() {
  if(Serial.available()){
      String input = Serial.readStringUntil('<');
      stepper.moveTo(input.toInt());
  }
}
