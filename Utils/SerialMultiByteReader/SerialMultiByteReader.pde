/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

Serial myPort;  // Create object from Serial class

int bufferIndex = 0;
static int bufferLength = 32;
int buffer[];

int threshold = 160;

boolean actives;

void setup() 
{
  size(255,200);
  
  buffer = new int[bufferLength];
  
  String portName = "COM5";
  myPort = new Serial(this, portName, 57600);
  
   oscP5 = new OscP5(this,12001);
   myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void draw()
{
  while ( myPort.available() > 0) {
    int b = myPort.read();
    switch(b)
    {
      case 255:
        processBuffer();
        bufferIndex = 0;
        break;
        
       default:
       if(bufferIndex < bufferLength) buffer[bufferIndex] = b;
       bufferIndex++;
       break;
    }
  }
}

void processBuffer()
{
  background(0);
  OscMessage myMessage = new OscMessage("/light");
  
  for(int i=0;i<bufferIndex;i++)
  {
    myMessage.add(buffer[i]);
    fill(buffer[i] > threshold?0:255,0,buffer[i] > threshold?255:0);
    rect(0,i*15,buffer[i],10);
  }
  
  oscP5.send(myMessage, myRemoteLocation); 
}
