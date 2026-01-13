

class City{
  float lat, lng, x, y, pop;
 
  String name, code;
  
  boolean over = false;
  
  // Create  the Bubble
  City(float lat_, float lng_, String name_, String code_, float pop_) {
    lat = lat_;
    lng = lng_;
    name = name_;
    code = code_;
    pop = pop_;
    mapCoordinates();
  }
  
  void mapCoordinates(){
     y = map(lat, 90, -90, 0, 2000);
     x = map(lng, -180, 180, 0, 4000);
  }
  
  
  
  // Display the Bubble
  void display() {
    stroke(0);
    strokeWeight(0.1);
    noFill();
    ellipse(x,y,2, 2);
    line(x-2, y-2, x+2, y+2);
    line(x-2, y+2, x+2, y-2);
     //if(code.equals("PPLC")){
     //  text(name, x, y);
     //}
     if(pop > 5000000){
       fill(0);
        textSize(30);
        text(name, x, y);
     }
  }
}
