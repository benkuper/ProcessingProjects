
import java.nio.ByteBuffer;
import processing.serial.*;

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;


ArduinoBufferedSerial serialMan;

float speed = 1;
int currentMotor = 0;

void setup(){
  
  size(300,300);
  
  if(Serial.list().length == 0)
  {
    println("#### No serial, exiting ####");
   // exit();
  }else
  {
  
  // Create a serial manager using the first serial port name listed
  serialMan = new ArduinoBufferedSerial(
  new PSerialDevice(this, Serial.list()[1], 9600),
    new Handler());
  }
  
  oscP5 = new OscP5(this,10500);  
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
}

void draw()
{
  // We always need to update the serial manager in our draw or update method
  //serialMan.update();
}

void setMotorSpeed(int motorIndex, float value)
{
  println("set motor speed "+motorIndex+", "+value);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(16);
  sendBuffer.put((byte)'s');  
  sendBuffer.putInt(motorIndex);
  sendBuffer.putFloat(value);  
  serialMan.sendBuffer(sendBuffer);
}

void setMotorHome(int motorIndex)
{
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'h'); 
 sendBuffer.putInt(motorIndex); 
  serialMan.sendBuffer(sendBuffer);
}

void setMotorPosition(int motorIndex, int pos)
{
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'p'); 
  sendBuffer.putInt(motorIndex);
  sendBuffer.putInt(pos); 
  serialMan.sendBuffer(sendBuffer);
}

void keyPressed()
{
  switch(key)
  {
    case 'h':
    setMotorHome(currentMotor);
    break;
    
    case 'p':
    setMotorPosition(currentMotor,0);
    break;
    
    case 'o':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor,-4800);
    break;
    
    case 'i':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor,4800);
    break;
    
    case 'u':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor,1000);
    break;
    
    case 'a':
    for(int i=0;i<3;i++)
    {
      setMotorHome(i);
    }
    break;
    
    case 'z':
    for(int i=0;i<3;i++)
    {
      setMotorPosition(i,0);
    }
    break;
    
    case 'e':
    for(int i=0;i<3;i++)
    {
      setMotorPosition(i,4500);
    }
    break;
    
    case 'r':
    for(int i=0;i<3;i++)
    {
      setMotorPosition(i,-4500);
    }
    break;
    
    
    
     case '0':
    currentMotor = 0;
    break;
    
    case '1':
    currentMotor = 1;
    break;
    
    case '2':
    currentMotor = 2;
    break;
    
    case '+':
    speed += 100;
    setMotorSpeed(currentMotor,speed);
    println("Speed : "+speed);
    break;
    
    case '-':
    speed -= 100;
    setMotorSpeed(currentMotor,speed);
    println("Speed : "+speed);
    break;
    
    case '.':
    speed = 1;
    setMotorSpeed(currentMotor,speed);
    break;
  }
}


// This class implements SerialPacketHandler and is used to handle the data
class Handler implements SerialPacketHandler{
  
  public void handleSerialPacket(ByteBuffer bb, int length){
    println("Buffer received :"+length);
    byte command = bb.get();
    float value = 0;
    switch(command)
    {
      case 'd':
      println("target position "+bb.getInt());
      break;
      
      default:
      value = bb.getFloat();
      println("command :"+(char)command+", value ="+value);
      break;
    }
  }
  
}

//OSC

void oscEvent(OscMessage msg) {
  
  try
  {
    /* print the address pattern and the typetag of the received OscMessage */
    String add = msg.addrPattern();
    int id = 0;
    println("OSC Message : "+add);
    if(add.equals("/home"))
    {
      id = msg.get(0).intValue();
      setMotorHome(id);
    }else if(add.equals("/pos"))
    {
       id = msg.get(0).intValue();
        setMotorPosition(id,msg.get(1).intValue());
    }else if(add.equals("/speed"))
    {
       id = msg.get(0).intValue();
        setMotorSpeed(id,(float)msg.get(1).intValue());
    }else if(add.equals("/resetSpeed"))
    {
      for(int i=0;i<3;i++)
      {
         setMotorSpeed(i,0);
      }
    }else if(add.equals("/homeAll"))
    {
      for(int i=0;i<3;i++)
      {
        setMotorHome(i);
      }
    }
  }catch(Exception e)
  {
    println("Error in OSC Message : "+e+'\n');
    println(e.getStackTrace());
  }
}
