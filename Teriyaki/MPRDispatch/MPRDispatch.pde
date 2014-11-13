import oscP5.*;
import netP5.*;
import java.net.InetAddress;

import processing.serial.*;


import themidibus.*; //Import the library

//midi notes

int pitchLookup[] = {
  48, 49, 50, 51, 52, 53,0,0,0,0,0,0,
  0,54,55,56,57,58,0,59,0,0,0,0
};

Serial serial;  // Create object from Serial class

boolean sendContinuous;

int touchT[];
int touchR[];

boolean isTouched[];

int buffer[];
int bufferIndex = 0;
MidiBus myBus; // The MidiBus

//Save / Load
String[] lines;


OscP5 oscP5;
NetAddress remoteLoc;

void setup()
{
  String portName = Serial.list()[0];
  serial = new Serial(this, "COM22", 9600);
  size(800, 600);
  background(0);

  buffer = new int[32];

  touchT= new int[24];

  touchR = new int[24];


  /* for(int i =0;i<24;i++)
   {
   touchT[i] = (int)random(254);
   touchR[i] = (int)random(254);
   }
   */

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, "BenPortable"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.


  isTouched = new boolean[24];

  oscP5 = new OscP5(this, 5001);
  remoteLoc = new NetAddress("127.0.0.1", 5500);

  loadConfig();
}

void loadConfig()
{
  lines = loadStrings("config.txt");
  println("Num lines :"+lines.length);
  for (int i=0; i< lines.length; i++) {
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
/*
  for (int i=0; i<24; i++)
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
*/


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
      //sendValue('r',pin,val-1);
      //sendValue('r', 0, ((val*254)-1)/254f);
    } else
    {
      // sendValue('r', pin, val);
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

    //test
  case '1':
    sendNoteOn(48);
    sendOSC(2, 1, true);
    break;

  case '0':
    sendNoteOff(48);
    sendOSC(2, 1, false);
    break;
  }
}

void sendValue(char type, int pin, float val)
{
  if (serial == null) return;
  int v = (int)map(constrain(val, 0, 1), 0f, 1f, 0, 254);
  serial.write(type);
  serial.write(pin);
  serial.write(v);
  serial.write(255);
}


void processSerial()
{
  if (serial == null) return;

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
      println(command,buffer[1],buffer[2]);
      /*
      if (buffer[1] < 24)
      {
        int index = buffer[1];
        boolean val = buffer[2] > 0;
        isTouched[index] = val;

        println("set touched "+isTouched[index]);
        if (isTouched[index])
        {
          sendNoteOn(pitchLookup[index]);
        }

        //sendOSC(index,val);
      }
      */
    }
    break;

  case 't':
    if (buffer[1] < 24)
    {
      touchT[buffer[1]] = buffer[2];
      sendValue('r', buffer[1], (buffer[2] -1)/254f);
    }
    break;

  case 'r':
    if (buffer[1] < 24)
    {
      touchR[buffer[1]] = buffer[2];
    }
    break;
  }
}


void sendNoteOn(int note)
{
  println("Send note"+note);
  myBus.sendNoteOn(0, note, 127);
}

void sendOSC(int channel, int index, boolean val)
{
  OscMessage myMessage = new OscMessage("/mprDispatch");
  myMessage.add(channel);
  myMessage.add(index); 
  myMessage.add(val);
  oscP5.send(myMessage, remoteLoc);
}

void sendNoteOff(int note)
{
  println("Send off"+note);
  myBus.sendNoteOff(0, note, 127);
}


void noteOn(Note note) {

  int mapped = getMappedPitch(note.pitch());
  println("Note on", note.channel(), mapped);
  sendOSC(note.channel(), mapped, true);
}

void noteOff(Note note) {
  int mapped = getMappedPitch(note.pitch());
  println("Note off", note.channel(), mapped);
  sendOSC(note.channel(), mapped, false);
}

int getMappedPitch(int pitch)
{
  int decalPitch = pitch-36;
  for (int i=0; i<pitchLookup.length; i++)
  {
    if (decalPitch == i) return i;
  }

  return 0;
}

