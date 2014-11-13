import oscP5.*;
import netP5.*;
import java.net.InetAddress;

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

OscP5 oscP5;
NetAddress remoteLoc;

import processing.serial.*;
Serial serial;  // Create object from Serial class


int buffer[];
int bufferIndex = 0;

int serialToNorm[] = {10,9,8,7,6,11,5,4,3,2,1,0};

int getNorm(int val)
{
  for(int i=0;i<serialToNorm.length;i++)
  {
    if(val == serialToNorm[i]) return i;
  }
  
  return -1;
} 

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,"BenPortable","BenPortable"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  
  serial = new Serial(this, "COM21", 9600);
  oscP5 = new OscP5(this, 5001);
  remoteLoc = new NetAddress("127.0.0.1", 5500);
  
  buffer = new int[32];
}

void draw() {
  processSerial();
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
      //println(command,buffer[1],buffer[2]);
      int normPitch = getNorm(buffer[1]-6);
      println("NORMPitch :"+normPitch);
      int vidiBoxPitch = normPitch+48;
      if(buffer[2] > 0)
      {
        sendNoteOn(vidiBoxPitch);
        sendOSC(5,normPitch,true);
      }else
      {
        sendNoteOff(vidiBoxPitch);
      }

    }
    break;
  }
  
}


void sendNoteOn(int note)
{
  println("Send note"+note);
  
  myBus.sendNoteOn(0, note, 127);
}

void sendNoteOff(int note)
{
  println("Send off"+note);
  myBus.sendNoteOff(0, note, 127);
}

void sendOSC(int channel, int index, boolean val)
{
  OscMessage myMessage = new OscMessage("/mprDispatch");
  myMessage.add(channel);
  myMessage.add(index); 
  myMessage.add(val);
  oscP5.send(myMessage, remoteLoc);
}



void noteOn(Note note) {
  int pitch = note.pitch()-48;
  
  println("Note on"+note.channel()+"/"+pitch);
  sendOSC(note.channel(),pitch, true);
}

void noteOff(Note note) {
  int pitch = note.pitch()-48;
  println("Note off"+note.channel()+"/"+pitch);
  sendOSC(note.channel(), pitch, false);
}

