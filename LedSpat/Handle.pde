class Handle
{
  
  public float x;
  public float y;
  
  float radius;
  float mouseRadius;
  
  boolean over;
  boolean dragging;
  
  public Handle()
  {
    x = random(1.0f);
    y = random(1.0f);
    
    radius = 15f;
     mouseRadius = radius*1.5f;
  }
  
  public void draw()
  {
    over = dist(mouseX,mouseY,x*width,y*height) < mouseRadius;
    
    if(dragging) 
    {
      x = mouseX*1f / width;
      y = mouseY*1f / height;
    }
    
    pushMatrix();
    pushStyle();
    translate(x*width,y*height);
     
    if(dragging) fill(255,255,0);
    else if(over) fill(200,150,0);
    else fill(150,200);
    
    ellipse(0,0,radius,radius);
    
    popStyle();
    popMatrix();
  }
  
  public boolean mousePressed()
  {
    if(over) dragging = true;
    return dragging;
  }
  
  public void mouseReleased()
  {
    if(dragging) dragging = false;
  }
  
}
