import processing.serial.*;
import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

String buffer;

void setup() 
{
  size(200, 200);

  String portName = "COM12";
  myPort = new Serial(this, portName, 9600);
  
  buffer = "";
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,0,"BenPortable"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    char c =  (char)myPort.read();         // read it and store it in val
   if(c == '\n')
  {
    processMessage();
    buffer = "";
  }else
   {
     buffer += c;
   }
    
  }
  
}

void processMessage()
{
  String[] split = buffer.split(" ");
  
  switch(buffer[0])
  {
    case 'f':
      boolean onOff = (Integer.parseString(split[2]) == 1);
      int pitch = int.parseString(split[1]);
      if(onOff) myBus.sendNoteOn(1,pitch,127);
      else myBus.sendNoteOn(1,pitch,0);
       break;   
  }
}
