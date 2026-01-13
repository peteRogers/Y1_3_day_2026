import processing.serial.*;
Serial myPort; 
int prem = 0;

void setup(){
  size(1024, 1024);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 115200);
}



void draw(){
  background(0);
  text("press screen", width/2, height/2);
  int m = round(map(mouseX, 0, width, 0, 99));
  
    myPort.write(m+"");
    myPort.write('\n');
    prem = m; 
  
}
