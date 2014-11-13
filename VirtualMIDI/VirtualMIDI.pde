import themidibus.*; //Import the library
import de.tobiaserichsen.tevm.*;
MidiBus myBus; // The MidiBus


TeVirtualMIDI vm;

void setup()
{
  size(200,200);
  vm = new TeVirtualMIDI("VMTest");
   MidiBus.list();
  myBus = new MidiBus(this,"VMTest","VMTest");
  
  println("setup ok");
  
  
}


void draw()
{
  //println("draw");
  
      try {

       byte[] command = vm.getCommand();

        vm.sendCommand( command );

        System.out.println( "command: ");
    } catch ( TeVirtualMIDIException e ) {

      System.out.println( "thread aborting: " + e );

      return;
    }
    
    delay(50);
    */
}

void exit()
{
  vm.shutdown();
}

void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
}

void mousePressed()
{
  
  int channel = 1;
  int velocity = 127;
  println("send midi");
  myBus.sendNoteOn(channel,36,velocity);
  myBus.sendNoteOff(channel,36,velocity);
}
