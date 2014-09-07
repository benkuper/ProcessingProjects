import processing.serial.*;
int bufferIndex = 0;

import themidibus.*; //Import the library

Serial serial;  // Create object from Serial class

boolean sendContinuous;

int touchT[];
int touchR[];

boolean isTouched[];

int buffer[];

MidiBus myBus; // The MidiBus

//Save / Load
String[] lines;


void setup()
{
  String portName = Serial.list()[0];
  //serial = new Serial(this, "COM11", 9600);
  size(800, 600);
  background(0);

  buffer = new int[32];
  
  touchT= new int[24];
  
  touchR = new int[24];
  
  for(int i =0;i<24;i++)
  {
    touchT[i] = (int)random(254);
    touchR[i] = (int)random(254);
  }
  
  
  
  isTouched = new boolean[24];
}

void loadConfig()
{
   lines = loadStrings("config.txt");
   println("Num lines :"+lines.length);
  for(int i=0;i< lines.length;i++) {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 2) {
      touchT[i] = int(pieces[0]);
      touchR[i] = int(pieces[1]);
      println(touchT[i]+"/"+touchR[i]);
    }
  }
}

void saveConfig()
{
  String[] lines = new String[24];
  for (int i = 0; i < lines.length; i++) {
    lines[i] = touchT[i] + "\t" + touchR[i];
  }
  saveStrings("config.txt", lines);
}

void draw()
{
  background(0);
  float th = (height/24);
  
  for(int i=0;i<24;i++)
  {
    fill(0, 100, 0);
    rect(0, i*th, (touchT[i]*width/255), th/2);
    fill(255);
    text("["+i+"] Touch : "+touchT[i], 10, (i*th), 200, 20);
    fill(255, 0, 0);
    rect(0, i*th+(th/2), (touchR[i]*width/255), th/2);
    fill(255);
    text("["+i+"] Release : "+touchR[i], 10, (i*th)+th/2, 200, 20);
    
     if (isTouched[i])
      {
        fill(255, 255, 0);
        rect(width-100, i*th, 90, th);
      }
  }
  
 

  processSerial();

  if (sendContinuous)
  {
    float val = mouseX*1.0f/width;
    int calc = (int)(mouseY*48/height);
    boolean isT = (calc%2 == 0);
    int pin = (int)(calc/2);
    if (isT)
    {
      sendValue('t', pin, val);
      delay(10);
      //sendValue('r', 0, ((val*254)-1)/254f);
    } else
    {
      sendValue('r', pin, val);
    }
    //delay(15);
  }
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
  case 'c':
    try
    {
      serial = new Serial(this, "COM11", 9600);
    }
    catch(Exception e)
    {
      println(e);
    }
    break;
    
    case 't':
    //sendAll();
    break;
    
   case 's':
    saveConfig();
    break;
    
    case 'l':
    loadConfig();
    break;
  }
}

void sendValue(char type, int pin, float val)
{
  if(serial == null) return;
  int v = (int)map(constrain(val, 0, 1), 0f, 1f, 0, 254);
  serial.write(type);
  serial.write(pin);
  serial.write(v);
  serial.write(255);
}


void processSerial()
{
  if(serial == null) return;
  
  while (serial.available () > 0)
  {
    int b = serial.read();
    if (b == 255) 
    {
      processBuffer();
      bufferIndex = 0;
    } else if (bufferIndex < 31)
    {
      buffer[bufferIndex] = b;
      bufferIndex++;
    }
  }
}

void processBuffer()
{
  //println("Process Buffer ("+bufferIndex+"):"+(char)buffer[0]);
  char command = (char)buffer[0];
  switch(command)
  {
  case 'p':
  case 'P':
  {
    isTouched[buffer[1]] = buffer[2] > 0;
    println("set touched "+isTouched);
  }
    break;
    
    case 't':
    touchT[buffer[1]] = buffer[2];
    break;
    
    case 'r':
    touchR[buffer[1]] = buffer[2];
    break;
  }
}


