
import java.nio.ByteBuffer;
import processing.serial.*;

ArduinoBufferedSerial serialMan;

float speed = 1;

void setup(){
  
  size(300,300);
  
  // Create a serial manager using the first serial port name listed
  serialMan = new ArduinoBufferedSerial(
  new PSerialDevice(this, Serial.list()[1], 9600),
    new Handler());
  
}

void draw()
{
  
  // We always need to update the serial manager in our draw or update method
  serialMan.update();
  
}

void setMotorSpeed(float value)
{
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(8);
  sendBuffer.put((byte)'s');  
  sendBuffer.putFloat(value);  
  serialMan.sendBuffer(sendBuffer);
}

void setMotorHome()
{
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(8);
  sendBuffer.put((byte)'h');  
  serialMan.sendBuffer(sendBuffer);
}

void setMotorPosition(int pos)
{
  ByteBuffer sendBuffer = ByteBuffer.allocateDirect(12);
  sendBuffer.put((byte)'p'); 
  sendBuffer.putInt(pos); 
  serialMan.sendBuffer(sendBuffer);
}

void keyPressed()
{
  switch(key)
  {
    case 'h':
    setMotorHome();
    break;
    
    case 'p':
    setMotorPosition(0);
    break;
    
    case 'o':
    setMotorHome();
    setMotorPosition(-4800);
    break;
    
    case 'i':
    setMotorHome();
    setMotorPosition(4800);
    break;
    
    case 'u':
    setMotorHome();
    setMotorPosition(1000);
    break;
    
    case '+':
    speed += 100;
    setMotorSpeed(speed);
    println("Speed : "+speed);
    break;
    
     case '1':
    speed = -2000;
    setMotorSpeed(speed);
    println("Speed : "+speed);
    break;
    
      case '2':
    speed = 2000;
    setMotorSpeed(speed);
    println("Speed : "+speed);
    break;
    
    case '-':
    speed -= 100;
    setMotorSpeed(speed);
    println("Speed : "+speed);
    break;
    
    case '0':
    speed = 1;
    setMotorSpeed(speed);
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
