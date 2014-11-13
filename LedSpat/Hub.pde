final int numStrips = 4;



class Hub
{
   public color col;
  
   public int index;
   LedStrip[] strips;
   
   public Hub(int index)
   {
     this.index = index;
     
     strips = new LedStrip[numStrips];
     
     float sx = random(1f);
     float sy = random(1f);
       
     for(int i=0;i<numStrips;i++)
     {
       strips[i] = new LedStrip(this,i);
       
       
       strips[i].start.x = sx;
       strips[i].start.y = sy;
     }
   }
   
   public void draw()
   {
     for(int i=0;i<numStrips;i++)
     {
       strips[i].draw();
     }
   }
   
    public boolean mousePressed()
    {
      for(int i=0;i<numStrips;i++)
      {
        if(strips[i].mousePressed()) return true;
      }
      
      return false;
    }
    
    public void mouseReleased()
    {
      for(int i=0;i<numStrips;i++)
      {
        strips[i].mouseReleased();
      }
    }
}
