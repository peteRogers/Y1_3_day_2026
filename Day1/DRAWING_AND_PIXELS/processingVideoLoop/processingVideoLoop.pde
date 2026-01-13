import processing.video.*;
Movie movie;

void setup() {
  size(1000, 1000);
  movie = new Movie(this, "hand4.mov");
  movie.loop();
  //println(movie.duration());
  noCursor();
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  fill(0,0,0,20);
  rect(0, 0, width, height);
  //draw video
  float angle=angleBetweenPoints(new PVector(width/2, height/2), new PVector(mouseX, mouseY));
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(angle);
  image(movie, -350, -110);
  popMatrix();
}


float angleBetweenPoints(PVector a, PVector mousePV) {
  PVector d = new PVector();
  pushMatrix();
  translate(a.x, a.y);
  // delta 
  d.x = mousePV.x - a.x;
  d.y = mousePV.y - a.y;
  // angle 
  float angle1 = atan2(d.y, d.x);
  popMatrix();
  return angle1;
} 
