OSCManager oscManager;
LedManager ledManager;

void setup()
{
    size(800,600);
    smooth();
    frameRate(60);
    
    oscManager = new OSCManager();
    ledManager = new LedManager();
}

void draw()
{
  background(0);
  ledManager.draw();
}

void mousePressed()
{
  ledManager.mousePressed();
}

void mouseReleased()
{
  ledManager.mouseReleased();
}

