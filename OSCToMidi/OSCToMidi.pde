import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

import oscP5.*;
import netP5.*;
import java.net.InetAddress;

OscP5 oscP5;
void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,0,"loopMIDI Port"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  oscP5 = new OscP5(this,15000);
  
}

void draw() {
    
}


void mousePressed()
{
  
}

void oscEvent(OscMessage msg) {
  println("received OSC");
  
  int id = Integer.parseInt(msg.addrPattern().split("/")[3]);
  int val = msg.get(0).intValue();
  
  id += 3;
  if(id > 40)
  {
    id += 5;
  }
  
  println("id after set "+id);
  if(val == 127)
  {
    myBus.sendNoteOn(1,id,127);
  }
  
  //println(d);
  //println();
  //myBus.sendNoteOn(channel,pitch,velocity);
 
}
  
