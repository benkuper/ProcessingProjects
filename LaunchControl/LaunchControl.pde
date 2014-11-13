import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

import oscP5.*;
import netP5.*;




MidiBus myBus; // The MidiBus

LCFeedback feedback;
Conduite conduite;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(630, 350);
  frameRate(60);
  smooth();
  
  background(0);
  

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, "Launch Control", "Launch Control"); // Create a new MidiBus object
  feedback = new LCFeedback();
  conduite = new Conduite();
  
   oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",7000);
}

void draw() {
  background(0);
  feedback.draw();
  conduite.draw();
}

// Launchpad

void controllerChange(int channel, int number, int value) {  
  if(number >= 114 && number <= 117)
  {
    if(value == 127) processSpecial(number);
  }else
  {
    processControl(getPotForNumber(number),value);
  }
}

void processControl(int number, int value)
{
  feedback.setPot(number,value);
}

void processSpecial(int number)
{
  switch(number)
  {
    case PAD_UP:
    break;
    
    case PAD_DOWN:
    break;
    
    case PAD_LEFT:
    conduite.prevState();
    break;
    
    case PAD_RIGHT:
    conduite.nextState();
    break;
  }
}

void keyPressed()
{
  switch(key)
  {
    case 'a':
      conduite.nextState();
      break;
   
   case 'b':
     conduite.prevState();
     break;
  }
}

void noteOn(int channel, int pitch, int velocity) {
  int pad = getPadForPitch(pitch);
  feedback.setPad(pad,true);  
  conduite.processPad(pad);
}

void noteOff(int channel, int pitch, int velocity) {
  int pad = getPadForPitch(pitch);
  feedback.setPad(getPadForPitch(pitch),false);
}

void setLed(int pad, int ledColor)
{
  setLed(pad,ledColor,true);
}

void setLed(int pad, int ledColor, boolean useFeedback)
{
  myBus.sendMessage(0x98,getPitchForPad(pad),ledColor); //0x9n -> 0x98 = channel 8 
  if(useFeedback) feedback.colorPad(pad,ledColor);
}

void clearLeds()
{
  for(int i=1;i<=8;i++) setLed(i,C_OFF); //0x9n -> 0x98 = channel 8 
}


void sendMessage(int status, int data1, int data2) {
    //raise NoOutputAllowedError if @output.nil?
    myBus.sendMessage(new byte[]{ (byte) status, (byte) data1, (byte) data2});
}

//OSC
void sendOSC(OscMessage msg)
{
 /* send the message */
  oscP5.send(msg, myRemoteLocation);
}
