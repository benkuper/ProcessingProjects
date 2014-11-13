final int numHubs = 3;

final float brightness = .3; // % of 255 on each color



class LedManager
{
  
  Hub[] hubs;
  
  public LedManager()
  {
    hubs = new Hub[numHubs];
    for(int i=0;i<numHubs;i++)
    {
      hubs[i] = new Hub(i);
    }
  }
  
  public void draw()
  {
    
    for(int i=0;i<numHubs;i++)
    {
      hubs[i].draw();
    }
    
  }
  
  public void mousePressed()
  {
    for(int i=0;i<numHubs;i++)
    {
      if(hubs[i].mousePressed()) break;
    }
  }
  
  public void mouseReleased()
  {
    for(int i=0;i<numHubs;i++)
    {
      hubs[i].mouseReleased();
    }
  }
}
