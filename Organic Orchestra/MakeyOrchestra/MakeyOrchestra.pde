import oscP5.*;
import netP5.*;
import processing.serial.*;


LiveManager live;
SerialManager serialManager;


void setup()
{
  size(800,200);
  background(0);
  frame.setResizable(true);
  
  live = new LiveManager();
  serialManager = new SerialManager(this);
  
  textAlign(CENTER);
}

void draw()
{
  background(0);
  serialManager.update();
  live.update();
}


void keyPressed(KeyEvent e)
{
  live.keyPressed(e);
}

void keyReleased(KeyEvent e)
{
  live.keyReleased(e);
}


