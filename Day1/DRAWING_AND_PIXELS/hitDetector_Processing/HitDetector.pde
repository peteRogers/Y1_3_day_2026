class HitDetection{
  int x, y, w, h;
  boolean hit = false;
  public HitDetection(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void makeDetection(int mx, int my){  
    if((mx > x && mx < x+w) && (my > y && my < y+h)){
       hit = true;
    }else{
      hit = false;
    }
  }
  
  void update(){
    if(hit == true){
      fill(0);
    }else{
      fill(255);
    }
    rect(x, y, w, h);
  }
}
