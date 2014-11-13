/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remote;

float[] values;
float[] targetValues;
float smoothFactor = .2f;
String ip;

void setup() {
  size(400,400);
  frameRate(30);
  
  values = new float[10];
  targetValues = new float[10];
  oscP5 = new OscP5(this,7001);
  remote = new NetAddress("127.0.0.1",7000);
  
   sendOsc("/layer6/opacityandvolume",1);
    
}


void draw() {
  background(0);  
  
  for(int i=0;i<3;i++)
  {
    values[i] += (targetValues[i]-values[i]) *smoothFactor;
    sendOsc("/layer"+(i+7)+"/opacityandvolume",values[i]);
    sendOsc("/layer"+(i+1)+"/opacityandvolume",min(values[i]*100f,1f));
    if(i == 2)
    {
      sendOsc("/layer"+(i+2)+"/opacityandvolume",min(values[i]*100f,1f));
    }
  }
  
  for(int i=0;i<10;i++)
  {
    rect(10+i*50,height,30,-values[i]*100f);
  }
  
  text("FrameRate : "+frameRate,10,10,200,20);
}

void sendOsc(String address, float value)
{
  OscMessage msg = new OscMessage(address);
  
  msg.add(value); 
  
  //println("Send osc : "+address+" : "+value);
  /* send the message */
  oscP5.send(msg, remote);
  
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  String addr = msg.addrPattern();
  
  String id = addr.split("/")[1];
  int i = 0;
  if(id.equals("layer1"))
  {
    i =0;
  }else if(id.equals("layer2"))
  {
    i =1;
  }else if(id.equals("layer3"))
  {
    i =2;
  }else if(id.equals("layer4"))
  {
    i =3;
  }else if(id.equals("layer5"))
  {
    i =4;
  }
  
  targetValues[i] = msg.get(0).floatValue(); 
  
}

void exit()
{
  sendOsc("/layer6/opacityandvolume",0);
}

void stop()
{
  sendOsc("/layer6/opacityandvolume",0);
}
