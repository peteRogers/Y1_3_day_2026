
#include <Arduino.h>
#include <RotaryEncoder.h>

#define PIN_IN1 A2
#define PIN_IN2 A3

int pos = 0;

// Setup a RotaryEncoder with 4 steps per latch for the 2 signal input pins:
// RotaryEncoder encoder(PIN_IN1, PIN_IN2, RotaryEncoder::LatchMode::FOUR3);

// Setup a RotaryEncoder with 2 steps per latch for the 2 signal input pins:
RotaryEncoder encoder(PIN_IN1, PIN_IN2, RotaryEncoder::LatchMode::TWO03);

void setup()
{
  Serial.begin(9600);

} // setup()


// Read the current position of the encoder and print out when changed.
void loop(){
  encoder.tick();
  int newPos = encoder.getPosition();
  if (pos != newPos) {
    pos = newPos;
  } // if
  Serial.println(pos);
}

// The End

