PImage img;
float r = 0;

void setup(){
  size(600,600);
  img = loadImage("stainWindow.png");
  imageMode(CENTER);
  background(255);
  
}

void draw(){
  translate(width/2, height/2);
  rotate(r);
  tint(255,255,255,10);
  image(img, 0, 0, width, height);
  float inc = map(mouseX, 0, width, -0.5,0.5);
  r = r + inc;
  
  
}
