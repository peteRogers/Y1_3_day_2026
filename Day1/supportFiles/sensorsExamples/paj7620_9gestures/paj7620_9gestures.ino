#include <Wire.h>
#include "paj7620.h"

#define GES_REACTION_TIME 50  // You can adjust the reaction time according to the actual circumstance.
#define GES_ENTRY_TIME 50     // When you want to recognize the Forward/Backward gestures, your gestures' reaction time must less than GES_ENTRY_TIME(0.8s).
#define GES_QUIT_TIME 100

void setup() {
  Serial.begin(9600);
  paj7620Init();  // initialize Paj7620 registers
}

void loop() {
  uint8_t data = 0, data1 = 0, error;
  error = paj7620ReadReg(0x43, 1, &data);  // Read Bank_0_Reg_0x43/0x44 for gesture result.
  if (!error) {
    if (data == GES_LEFT_FLAG) {
      Serial.println("1");
      delay(20);
    }
    if (data == GES_RIGHT_FLAG) {
      Serial.println("2");
      delay(20);
    }
  }
  delay(10);
}
