ArrayList <HitDetection> hits;
void setup(){
  size(1024, 1024);
  hits = new ArrayList();
  for(int x = 0; x < width; x = x + 128){
    for(int y = 0; y < height; y = y + 128){
     HitDetection h = new HitDetection(x, y, 128, 128);
     hits.add(h);
    }
  }
}

void draw(){
  for(HitDetection h : hits){
    h.makeDetection(mouseX, mouseY);
    h.update();
  }
}
