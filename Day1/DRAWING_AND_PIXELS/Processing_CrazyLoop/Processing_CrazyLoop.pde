float x = 0;

void setup(){
  size(600, 600);
  rectMode(CENTER);
  stroke(255,0,0);
  strokeWeight(0.1);
  noFill();
}

void draw(){
  background(0, 255, 255);
  for(int i = 512; i > 0; i --){
    pushMatrix();
    translate(width / 2, height / 2);
    float f = i / 10.5;
    rotate(x*(f));
    rect(0, 0, 4 * i, 4 * i);
    popMatrix();
  }
  
  x = x + 0.001;
}

void mousePressed(){
  noLoop();
  
}

void mouseReleased(){
  loop();
}
