import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,"loopMIDI Port","BenPortable"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
}

void draw() {
  
  
  
  
  
}

int pitch= 36;

void mousePressed()
{
  
  int channel = 0;
  pitch++;;
  int velocity = 127;
  println("send"+pitch);
  myBus.sendNoteOn(channel,pitch,velocity);
 // myBus.sendNoteOff(channel,pitch,velocity);
}

void noteOn(Note note) {
  // Receive a noteOn
  /*
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
  */
  myBus.sendNoteOn(0,note.pitch()-66+48,127);
}

void noteOff(Note note) {
  // Receive a noteOff
  /*
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
  */
  myBus.sendNoteOff(0,note.pitch()-66+48,0);
}
