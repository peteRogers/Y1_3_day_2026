// include the library
#include <Unistep2.h>

 
Unistep2 stepper( 8, 9,10,11, 4096, 800); // pins for IN1, IN2, IN3, IN4, steps per rev, step delay(in micros)
int prevPos = 0;

void setup(){

}


void loop(){
  stepper.run();
  if(stepper.stepsToGo() == 0){
    stepper.move(1);
    int s = analogRead(A0);
    delayMicroseconds(s*8);
  }
}


//void loop(){
//  stepper.run();
//  int pos = analogRead(A0);
//  if(abs(prevPos - pos) > 10){
//    prevPos = pos;
//    stepper.moveTo(pos);
//  }
//  if(stepper.stepsToGo() == 0){
//    stepper.stop();
//  }
//}
