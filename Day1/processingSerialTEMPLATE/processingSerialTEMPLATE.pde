
void setup() {
  size(1024, 1024);
  startSerial(5, 1);
}



void draw() {
  stroke(255);
  strokeWeight(50);
  background(0);
  //line(0,0, arduinoValues[0], arduinoValues[1]);
  drawInterface();
}
