// include the library
#include <Unistep2.h>


Unistep2 stepper( 8, 9,10, 11, 4096, 800); // pins for IN1, IN2, IN3, IN4, steps per rev, step delay(in micros)
int pos = 4096;

void setup(){

}

void loop(){
  stepper.run();
  if ( stepper.stepsToGo() == 0 ){
    stepper.move(pos);
    pos = pos *-1;
  }
}
