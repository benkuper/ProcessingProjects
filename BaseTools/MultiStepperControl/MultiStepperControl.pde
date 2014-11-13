
import java.nio.ByteBuffer;
import processing.serial.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


ArduinoBufferedSerial serialMan;

float speed = 1;
int currentMotor = 0;

void setup() {

  size(300, 300);

  if (Serial.list().length == 0)
  {
    println("#### No serial, exiting ####");
    // exit();
  } else
  {

    // Create a serial manager using the first serial port name listed
    serialMan = new ArduinoBufferedSerial(
    new PSerialDevice(this, "COM16", 9600), 
    new Handler());
  }

  oscP5 = new OscP5(this, 10500);  
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw()
{
  // We always need to update the serial manager in our draw or update method
  //serialMan.update();
  background(0);
  textSize(20);
  text("motor : "+currentMotor, 10, 10, 200, 50);
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
  println("Set motor home :"+motorIndex);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'h'); 
  sendBuffer.putInt(motorIndex); 
  serialMan.sendBuffer(sendBuffer);
}

void stopMotor(int motorIndex)
{
  println("Stop motor :"+motorIndex);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'z'); 
  sendBuffer.putInt(motorIndex); 
  serialMan.sendBuffer(sendBuffer);
}

void setMotorMaxSpeed(int motorIndex, float value)
{
  println("set motor speed "+motorIndex+", "+value);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(16);
  sendBuffer.put((byte)'m');  
  sendBuffer.putInt(motorIndex);
  sendBuffer.putFloat(value);  
  serialMan.sendBuffer(sendBuffer);
}

void setMotorPosition(int motorIndex, int pos)
{
  println("Set motor pose :"+motorIndex+" : "+pos);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'p'); 
  sendBuffer.putInt(motorIndex);
  sendBuffer.putInt(pos); 
  serialMan.sendBuffer(sendBuffer);
}

void defineMotorPos(int motorIndex, int pos)
{
  println("Define pose :"+motorIndex+" : "+pos);
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'d'); 
  sendBuffer.putInt(motorIndex);
  sendBuffer.putInt(pos); 
  serialMan.sendBuffer(sendBuffer);
}

void keyPressed(KeyEvent e)
{
  switch(key)
  {
  case 'g':

    for (int i=0; i<5; i++)
    {
      setMotorHome(i);
    }
    speed = 1;
    break;

  case 'h':
    setMotorHome(currentMotor);
    speed = 1;
    break;

  case 'z':
    stopMotor(currentMotor);
    speed = 1;
    break;
    
  case 'a':
    setMotorPosition(currentMotor,0);
  break;
  
  case 'p':
    setMotorPosition(currentMotor, 0);
    break;

  case 'o':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor, -4500);
    break;

  case 'i':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor, 4500);
    break;

  case 'u':
    setMotorHome(currentMotor);
    setMotorPosition(currentMotor, 300);
    break;
    
  case 'q':
    for (int i=0; i<5; i++)
    {
      setMotorMaxSpeed(i,400f);
    }
    break;
    
  case 'd':
    for (int i=0; i<5; i++)
    {
      setMotorMaxSpeed(i,200f);
    }
    break;
    
  case 's':
    for (int i=0; i<5; i++)
    {
      setMotorMaxSpeed(i,1000f);
    }
    break;



  case 'e':
    for (int i=0; i<5; i++)
    {
      setMotorPosition(i, 4500);
    }
    break;

  case 'r':
    for (int i=0; i<5; i++)
    {
      setMotorPosition(i, -4500);
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

  case '3':
    currentMotor = 3;
    break;
  case '4':
    currentMotor = 4;
    break;

  case '+':
    speed += 100;
    if (key == SHIFT)
    {
      for (int i=0; i<5; i++)
      {
        setMotorSpeed(i, speed);
      }
    } else
    {
      setMotorSpeed(currentMotor, speed);
    }
    println("Speed : "+speed);
    break;

  case '-':
    speed -= 100;
    setMotorSpeed(currentMotor, speed);
    println("Speed : "+speed);
    break;

  case '/':
    speed -= 100;
    for (int i=0; i<5; i++)
    {
      setMotorSpeed(i, speed);
    }
    println("Speed : "+speed);
    break;
  case '*':
    speed += 100;
    for (int i=0; i<5; i++)
    {
      setMotorSpeed(i, speed);
    }
    println("Speed : "+speed);
    break; 

  case '.':
    speed = 1;
    setMotorSpeed(currentMotor, speed);
    break;
  }
}


// This class implements SerialPacketHandler and is used to handle the data
class Handler implements SerialPacketHandler {

  public void handleSerialPacket(ByteBuffer bb, int length) {
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

  println("Received message"+msg.addrPattern());

  try
  {
    /* print the address pattern and the typetag of the received OscMessage */
    String add = msg.addrPattern();
    int id = 0;
    println("OSC Message : "+add);
    if (add.equals("/defPos"))
    {
      id = msg.get(0).intValue();
      int pos = msg.get(1).intValue();
      defineMotorPos(id, pos);
    } else if (add.equals("/home"))
    {
      id = msg.get(0).intValue();
      setMotorHome(id);
    } else if (add.equals("/stopMotor"))
    {
      id = msg.get(0).intValue();
      stopMotor(id);
    }else if (add.equals("/pos"))
    {
      id = msg.get(0).intValue();
      setMotorPosition(id, msg.get(1).intValue());
    } else if (add.equals("/speed"))
    {
      id = msg.get(0).intValue();
      setMotorSpeed(id, (float)msg.get(1).intValue());
    } else if (add.equals("/resetSpeed"))
    {
      for (int i=0; i<3; i++)
      {
        setMotorSpeed(i, 0);
      }
    } else if (add.equals("/homeAll"))
    {
      for (int i=0; i<3; i++)
      {
        setMotorHome(i);
      }
    }
  }
  catch(Exception e)
  {
    println("Error in OSC Message : "+e+'\n');
    println(e.getStackTrace());
  }
}

