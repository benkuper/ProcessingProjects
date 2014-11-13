import processing.serial.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;


Serial serial;  // Create object from Serial class
String portName = "COM16";
 
void setup()
{
  size(400,400);
  serial = new Serial(this, portName, 9600);
  
   oscP5 = new OscP5(this,6000);
}

void draw()
{
   while ( serial.available() > 0) {
    char b = (char)serial.read();
    print(b);
   }
  
   //sendPosition(mouseX*1f/width,mouseY*1f/height,.5f,.3f);
}

void sendPosition(float stretch,float armHeight,float rot, float handRot)
{
  int bStretch = (int)map(constrain(stretch,0f,1f),0f,1f,0,254);
  int bArmHeight = (int)map(constrain(armHeight,0f,1f),0f,1f,0,254);
  int bRot =(int) map(constrain(rot,0f,1f),0f,1f,0,254);
  int bHandRot = (int)map(constrain(handRot,0f,1f),0f,1f,0,254);
  
  //println("Send pos :"+bStretch+"/"+bArmHeight+"/"+bRot+"/"+bHandRot);
  serial.write('p');
  serial.write(bStretch);
  serial.write(bArmHeight);
  serial.write(bRot);
  serial.write(bHandRot);
  serial.write(255);
}

void sendSpeed(int target,int speed)
{
  serial.write('s');
  serial.write(target);
  serial.write(speed);
  serial.write(255);
}

void sendGrip(boolean value)
{
  serial.write('g');
  serial.write(value?0:1);
  serial.write(255);
}

void mousePressed()
{
  active = !active;
   println("Switch active : "+active);
}

boolean active = true;

void oscEvent(OscMessage msg) {
   String addr = msg.addrPattern();
   String myoID = msg.get(0).stringValue();
   
   if(addr.equals("/myo/orientation"))
   {
      float roll = map(msg.get(1).floatValue(),-1,-.5,0,1);
      float pitch =  map(msg.get(2).floatValue(),-1,1,0,1);
      float yaw =  map(msg.get(3).floatValue(),-3,3,0,1);
      //println(roll+"/"+pitch+"/"+yaw);
      if(active) sendPosition(pitch,0.5,-yaw,roll);
   }
   
   if(addr.equals("/myo/pose"))
   {
     String pose = msg.get(1).stringValue();
     if(pose.equals("thumbToPinky"))
     {
      
       active= true;
       // println("Switch active : "+active);
     }else if(pose.equals("waveIn"))
     {
       sendGrip(true);
     }else if(pose.equals("waveOut"))
     {
       sendGrip(false);
     }else if(pose.equals("fingersSpread"))
     {
       println("fingers spread"+random(5));
       active = false;
       sendPosition(1,0.2,0,0);
     }



   }
}  



