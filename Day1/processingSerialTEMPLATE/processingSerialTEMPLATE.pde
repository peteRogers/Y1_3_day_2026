import processing.serial.*;
Serial myPort;
int[] arduinoValues = new int[8];


void setup() {
  size(1024, 1024);
  printArray(Serial.list());
  try {
    myPort = new Serial(this, Serial.list()[5], 9600);
  }
  catch(Exception e) {
    println(e);
  }
}



void draw() {
  stroke(255);
  strokeWeight(50);
  background(0);
  //line(0,0, arduinoValues[0], arduinoValues[1]);
  //drawInterface();
}
