import processing.serial.*;
Serial myPort;


void setup(){
  size(1024, 1024);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
  colorMode(HSB, 255);
}

void draw(){
  color c = color(mouseX/4,255,255);
  String s = ""+red(c)+">"+green(c)+">"+blue(c)+">"+"\n";
  myPort.write(s);
  drawSpectrum();
}

//draws interface
void drawSpectrum(){
    for(int x = 0; x < width; x++){
    stroke(x/4,255,255);
    line(x, height/2-50,x, height/2+50);
  }
  fill(255);
  noStroke();
  rect(mouseX, height/2-50, 20, 100);
}
