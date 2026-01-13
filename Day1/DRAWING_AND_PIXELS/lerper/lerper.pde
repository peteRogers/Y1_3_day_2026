import processing.serial.*;

float x = 0;
float y = 0;

void setup(){
  size(1024, 1024);

}

void draw(){
  background(0);
  x = lerp(x, mouseX, 0.1);
  y = lerp(y, mouseY, 0.1);
  ellipse(x, y, 50, 50);
}
