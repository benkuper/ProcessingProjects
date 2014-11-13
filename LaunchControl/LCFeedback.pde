public class LCFeedback
{
  boolean pads[];
  color padColors[];
  int padLedColors[];
  
  int pots[];
  
  public int x;
  public int y;
  
  public LCFeedback()
  {
    pads = new boolean[8];
    padColors = new color[8];
    padLedColors = new int[8];
    pots = new int[16];
    
    for(int i=0;i<padColors.length;i++)
    {
      padColors[i] = color(100);
      padLedColors[i] = C_OFF;
    }
    
    x = 50;
    y = 50;
  }
  
  
  public void setPad(int pad, boolean value)
  {
    //println(pad+"/"+value);
    pads[pad-1] = value;
   
    if(value)
    {
       setLed(pad,C_YELLOW_FULL,false);
    }else
    {
      println("shut off pad :"+padLedColors[pad-1]);
      setLed(pad,padLedColors[pad-1],false);
    }
  }
  
  public void colorPad(int pad, int ledCol)
  {
    color col =  color(255,0,0);
    col = getColorForLC(ledCol);
    padColors[pad-1] =col;
    padLedColors[pad-1] = ledCol;
  }
  
  public void setPot(int pot, int value)
  {
    pots[pot-1] = value;
  }
  
  public void draw()
  {
    int spacing = 60;
    float start = 40*TWO_PI/127;
    float end = TWO_PI + 25*TWO_PI/127;
    float range = end-start;
    
    pushMatrix();
    translate(x,y);
    
    for(int i=0;i<pots.length;i++)
    {
      int tx = i%8;
      int ty = floor(i/8);
      float val = pots[i] * range/127;
      
      fill(100);
      noStroke();
      ellipse(tx*spacing,ty*spacing,30,30);
      noFill();
      stroke(255,255,255);
      strokeWeight(3);
      arc(tx*spacing, ty*spacing, 40,40, start,start+val);
      fill(255);
      text(pots[i]+"",tx*spacing-10,ty*spacing-7,40,20);
    }
    
    for(int i=0;i<pads.length;i++)
    {
      if(pads[i]) 
      {
        fill(180);
        stroke(255);
      }else 
      {
        fill(padColors[i]);
        noStroke();
      }
      
      rect(i*spacing-20,100,40,40);
    }
    
    popMatrix();
  }
  
}
