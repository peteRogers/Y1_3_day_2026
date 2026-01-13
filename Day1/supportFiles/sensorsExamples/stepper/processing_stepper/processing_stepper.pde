// code sends mouseX out to serial port. 

import processing.serial.*;
Serial myPort; 
int x = 0;

void setup(){
  size(1024, 1024);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 115200);
  noCursor();
}


void draw(){
  background(0);
  fill(255,255,255, 50);
  ellipse(mouseX, height/2, 50, 50);
  myPort.write(""+mouseX);
  myPort.write("<");
  x = x ++;
}
