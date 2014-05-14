/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

float yaw,pitch,roll;
String pose;

void setup() {
  size(400,400);
  frameRate(60);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",9000);
}


void draw() {
  background(0);  
  fill(255,0,0);
  rect(width/2,0,yaw*100,20);
  rect(width/2,30,pitch*100,20);
  rect(width/2,50,roll*100,20);
  
  text("Pose : "+pose,30,100,200,20);
}

void keyPressed() {
  /* in the following different ways of creating osc messages are shown by example */
  
  switch(key)
  {
    case 'r':
    register();
    break;
    
    case 'u':
    unregister();
    break;
  }
  
}

void register()
{
   OscMessage myMessage = new OscMessage("/myosc/register");
  
  myMessage.add("processing"); /* add an int to the osc message */
  myMessage.add("127.0.0.1");
  myMessage.add(12000);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void unregister()
{
   OscMessage myMessage = new OscMessage("/myosc/unregister");
  
  myMessage.add("processing"); /* add an int to the osc message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+msg.addrPattern());
  println(" typetag: "+msg.typetag());
  
  String command = msg.addrPattern().split("/")[2];
  if(command.equals("orientation"))
  {
    println("orientation update");
    roll = msg.get(1).floatValue();
    pitch = msg.get(2).floatValue();
    yaw = msg.get(3).floatValue();
  }else if(command.equals("pose"))
  {
    pose = msg.get(1).stringValue();
  }
}
