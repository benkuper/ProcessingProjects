import processing.serial.*;

Serial serial;  // Create object from Serial class

int numLeds = 3;


void setup()
{
  String portName = Serial.list()[0];
  serial = new Serial(this, "COM19", 9600);
  size(200, 200);
  background(0);
  
  frameRate(20);
}

void draw()
{
 
}

void mousePressed()
{
  sendContinuous = true;
}

void mouseReleased()
{
  sendContinuous = false;
}

void keyPressed()
{
  switch(key)
  {
  case 'o':
    sendValue(0,1f);
    break;

  case 'i':
    sendValue(0,.5f);
    break;

  case 'p':
    sendValue(0,0f);
    break;
    
 case 'l':
    sendValue(1,1f);
    break;

  case 'k':
    sendValue(1,.5f);
    break;

  case 'm':
    sendValue(1,0f);
    break;

  case 'c':
    try
    {
      serial = new Serial(this, "COM7", 9600);
    }
    catch(Exception e)
    {
      println(e);
    }
    break;
  }
}

void sendValue(int id, float val)
{

  int v = (int)map(constrain(val, 0, 1), 0f, 1f, 0, 254);
  println("send Value", v);
  serial.write('s');
  serial.write(id);
  serial.write(v);
  serial.write(255);
}



