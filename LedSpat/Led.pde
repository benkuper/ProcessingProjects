class Led
{
  int r;
  int g;
  int b;
  int a;
  
  float x;
  float y;
  
  float radius;
  
  public Led()
  {
    
    r = 200;
    g = 0;
    b = 50;
    a = 255;
    
    radius = 5f;
   
  }
  
  public void draw()
  {
    
    
    pushMatrix();
    pushStyle();
   
    translate(x*width,y*height);
     
     noStroke();
    fill(r,g,b,a);
    
    ellipse(0,0,radius,radius);
    
    popStyle();
    popMatrix();
  }
  
  
}
