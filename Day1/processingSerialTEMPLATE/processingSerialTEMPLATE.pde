
void setup() {
  size(1024, 1024);
  startSerial(5, 1);
}



void draw() {
  stroke(255);
  strokeWeight(50);
  background(0);
  drawInterface();
  if(pinPressed(0) == true){
    text("foofoofoof", 300,300);
  } 
  updateValues();
}
