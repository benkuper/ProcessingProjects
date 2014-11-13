import themidibus.*; //Import the library
import processing.serial.*;

Serial serial;  // Create object from Serial class

void setup()
{
  String portName = Serial.list()[0];
}

void draw()
{
  while(serial.available() > 0)
  {
    int c = (char)serial.read();
    println(c);
  }gggggggggggg   
}
