import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

Bloc[] blocs;

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,"BenPortable","BenPortable"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  blocs = new Bloc[16];
  
  for(int i=0;i<blocs.length;i++)
  {
    int tx = (int)((i%4)*width/4);
    int ty = (int)(floor(i/4)*height/4);
    int tw = width/4;
    int th = height/4;
    blocs[i] = new Bloc(tx,ty,tw,th,48+i);
    
  }
}

void draw() {
  background(0);
   for(int i=0;i<blocs.length;i++) blocs[i].draw();
  
}

//int pitch= 36;

void mousePressed()
{
  
  //int channel = 0;
  //pitch++;;
  //int velocity = 127;
  //println("send"+pitch);
 // myBus.sendNoteOn(channel,pitch,velocity);
 // myBus.sendNoteOff(channel,pitch,velocity);
 for(int i=0;i<blocs.length;i++) blocs[i].mousePressed();
  
 
}

void mouseReleased()
{
for(int i=0;i<blocs.length;i++) blocs[i].mouseReleased();
  
}
/*
void keyPressed()
{
  switch(key)
  {
    case '1':
      sendNote(36);
      break;
      
    case '2':
      sendNote(37);
      break;
      
     case '3':
        sendNote(38);
        break;
        
    case '4':
        sendNote(39);
        break;
  }
}
*/
void sendNoteOn(int note)
{
  println("Send note"+note);
  myBus.sendNoteOn(0,note,127);
}

void sendNoteOff(int note)
{
  println("Send off"+note);
  myBus.sendNoteOff(0,note,127);
}

public class Bloc
{
  int pitch;
  int x;
  int y;
  int w;
  int h;
  
  boolean pressed = false;
  public Bloc(int tx,int ty,int w, int h, int pitch)
  {
    this.pitch = pitch;
    this.x = tx;
    this.y = ty;
    this.w = w;
    this.h = h;
  }
  
  
  public void draw()
  {
    if(pressed) fill(255,255,0);
    else fill(20);
    
    rect(this.x+2,this.y+2,w-4,h-4);
    /*
    if(pressed)
    {
      pressed = false;
    }
    */
  }
  
  public void mousePressed()
  {
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h)
    {
      pressed = true;
      sendNoteOn(pitch);
    }
  }
  
  public void mouseReleased()
  {
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h)
    {
      pressed = false;
      sendNoteOff(pitch);
    }
  }
}

void noteOn(Note note) {
    println("Note on",note.channel(),note.pitch());
}

 
