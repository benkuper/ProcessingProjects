static final int PAD_UP = 114;
static final int PAD_DOWN = 115;
static final int PAD_LEFT = 116;
static final int PAD_RIGHT = 117;

static final int C_OFF = 12;
static final int C_RED_LOW = 13;
static final int C_RED_FULL = 15;
static final int C_AMBER_LOW = 29; 
static final int C_AMBER_FULL = 63;
static final int C_YELLOW_FULL = 62; 
static final int C_GREEN_LOW = 28;
static final int C_GREEN_FULL = 60;

  
int getPadForPitch(int pitch)
{
  if(pitch >= 9 && pitch <= 12) return pitch-8;
  if(pitch >= 25 && pitch <= 28) return pitch-20;
  return pitch;
}

int getPotForNumber(int number)
{
  if(number >= 21 && number <= 28) return number-20;
  if(number >= 41 && number <= 48) return number-40+8;
  return number;
}



int getPitchForPad(int pad)
{
  if(pad >= 1 && pad <= 4) return pad+8;
  if(pad >= 5 && pad <= 8) return pad+20;
  return pad;
}

int getColorForString(String col)
{
  
  if(col.equals("red")) return C_RED_FULL;
  if(col.equals("green")) return C_GREEN_FULL;
  if(col.equals("amber")) return C_AMBER_FULL;
  if(col.equals("yellow")) return C_YELLOW_FULL;
  
  return C_OFF;
}

color getColorForLC(int lc)
{
  switch(lc)
  {
    case C_OFF:
      return color(100); 
    
    case C_RED_LOW:
      return color(150,0,0); 
      
    case C_RED_FULL:
      return color(255,0,0);
      
    case C_AMBER_LOW:
     return color(150,50,0);
 
    case C_AMBER_FULL:
      return color(255,150,0);
      
    case C_YELLOW_FULL:
      return color(255,255,0);
      
    case C_GREEN_LOW:
      return color(0,150,0);
      
    case C_GREEN_FULL:
      return color(0,255,0);
    
  }
  
  return color(100);
}

