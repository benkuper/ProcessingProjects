final int numLeds = 10;



class LedStrip
{
  
  public Handle start;
  public Handle end;
  
  Led[] leds;
  
  Hub hub;
  int index;
  
  
  public LedStrip(Hub hub, int index)
  {
    this.hub = hub;
    this.index = index;
    
    start = new Handle();
    end = new Handle();
    
     leds = new Led[numLeds];
     for(int i=0;i<numLeds;i++)
     {
       leds[i] = new Led();
     }
  }
  
  public void draw()
  {
    start.draw();
    end.draw();
    
    pushStyle();
    
    if(start.dragging || end.dragging) stroke(255,255,0);
    else stroke(150,50);
    
    strokeWeight(3);
    line(start.x*width,start.y*height,end.x*width,end.y*height);
    
    fill(255);
    textSize(10);
    text(hub.index+":"+this.index,start.x*width+15,start.y*height-15,100,30);
    popStyle();
    
    for(int i=0;i<numLeds;i++)
     {
       float f = (i+1)*1f/(numLeds+1);
       leds[i].x = lerp(start.x,end.x,f);
       leds[i].y = lerp(start.y,end.y,f);
       
       leds[i].draw();
     }
    
  }
  
  public boolean mousePressed()
  {
     if(start.mousePressed()) return true;
     if(end.mousePressed()) return true;
     
     return false;
  }
  
  public void mouseReleased()
  {
    start.mouseReleased();
    end.mouseReleased();
  }
}
