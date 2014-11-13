import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.Rectangle;
import java.util.Arrays;
//import deadpixel.keystone.*;

//util & drawing
boolean shiftKey;

color[] colors;
  
  
PVector windowLoc;
PVector targetLoc;
int curScreen;
int targetScreen;

GraphicsDevice[] screens;

int numSurfaces = 3;
MapSurface[] surfaces;
Handle selectedHandle;
ArrayList<Handle> handles;
Handle closestHandle;
  
PVector mouseOffset;
PVector[] surfaceHandleOffsets;
  
//for compute and feedback, value is just for feedback
float elevation = 10; //just for feedback, used for persp calculation but the value doesn't matter

ScreenFrame[] screenFrames;
MapApplet[] mapApplets;


PImage sourceImage; //will be syphon or spout
PImage calibImage;

void setup()
{
  
  //WINDOW INIT NOT WORKING WITH OPENGL
  /*
 frame.setAlwaysOnTop(true);

 frame.setResizable(true);
 */
 
 size(400,400,OPENGL);
   
  //COLORS
  colors = new color[4];
  colors[0] = color(255,0,0);
  colors[1] = color(0,150,255);
  colors[2] = color(0,255,0);
  colors[3] = color(255,0,255);
  
  surfaceHandleOffsets = new PVector[5];
  
  //FOR TESTING AND CALIB
  sourceImage = loadImage("calib_uv.jpg");
  calibImage = loadImage("calib.jpg"); 
  
  
  //SCREENS
   screens = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
   
  //INIT
  windowLoc = new PVector();
  targetLoc = new PVector(20,20);
  
  curScreen = 0;
  targetScreen = 0;
  
  
  //INIT FRAMES AND MAPSURFACES
  mapApplets = new MapApplet[numSurfaces];
  screenFrames = new ScreenFrame[numSurfaces];
  surfaces = new MapSurface[numSurfaces];
  
  for(int i=0;i<numSurfaces;i++)
  {
    mapApplets[i] = new MapApplet();
    screenFrames[i] = new ScreenFrame(mapApplets[i]);
    surfaces[i] = new MapSurface(mapApplets[i],i);
    mapApplets[i].surface = surfaces[i];
  }
}


void draw()
{
  background(0);
  
  //SCREEN POS HANDLING
  
  if(targetLoc.x != windowLoc.x || targetLoc.y != windowLoc.y)
  {
    setWindowLoc(targetLoc);
  }
  
  if(curScreen != targetScreen) setScreen(targetScreen);
 
}


void keyPressed(KeyEvent e)
{
  if(keyCode == SHIFT) shiftKey = true;
  
  switch(key)
  {

  case '+':
   targetScreen++;
   break;
  
  case '-':
    targetScreen--;
    break;
    
    
    case 's':
    saveSettings();
    break;
    
    case 'l':
    loadSettings();
    break;
  }
  
}

void keyReleased()
{
  shiftKey = false;
}




//SAVING
void saveSettings()
{
  String[] lines = new String[surfaces.length];
  for (int i = 0; i < surfaces.length; i++) {
    lines[i] = surfaces[i].getData();
  }
  saveStrings("surfaces.txt", lines);
}

void loadSettings()
{
  String[]  lines = loadStrings("surfaces.txt");
  for (int i = 0; i < surfaces.length && i < lines.length; i++) {
    surfaces[i].loadData(lines[i]);
  }
}


//SCREEN

void setWindowLoc(PVector loc)
{
  println("set window loc");
  frame.setLocation((int)loc.x,(int)loc.y);
  windowLoc.set(targetLoc);
}

void setScreen(int index)
{
  println("set screen loc");
  GraphicsDevice screen = screens[index%screens.length];
  Rectangle bounds= screen.getConfigurations()[0].getBounds();
  
  for(int i=0;i<screenFrames.length;i++)
  {
    screenFrames[i].setLocation(bounds.x+i*(bounds.width/3),bounds.y);
    screenFrames[i].setSize(bounds.width/3,bounds.height);
  }
  
  curScreen = targetScreen;
}


//TO PUSH IN STATIC HANDLE CLASS
void setSelectedHandle(Handle h)
{
  
  if(selectedHandle != null)
  {
    selectedHandle.selected = false;
  }
  
  selectedHandle = h;
  
  if(selectedHandle != null)
  {
    PApplet p = selectedHandle.parent;
    mouseOffset = new PVector(p.mouseX-selectedHandle.x,p.mouseY-selectedHandle.y);
    
    for(int i=0;i<selectedHandle.surface.handles.length;i++)
    {
      Handle sh = selectedHandle.surface.handles[i];
      surfaceHandleOffsets[i] = new PVector(p.mouseX-sh.x,p.mouseY-sh.y);
    }
    Handle ch = selectedHandle.surface.center;
    surfaceHandleOffsets[4] = new PVector(p.mouseX-ch.x,p.mouseY-ch.y);
    
    selectedHandle.selected = true;
  }
}


Handle getClosestHandle(PApplet parent)
{
  float dist = -1;
  Handle closestHandle = null;
  
  for(Handle h:handles)
  {
    if(h.parent != parent) continue;
    
    int tx = h.parent.mouseX;
    int ty = h.parent.mouseY;
    float nextDist = dist(h.x,h.y,tx,ty);
    if(dist == -1 || dist > nextDist)
    {
      closestHandle = h;
      dist = nextDist;
    }
  }
  
  return closestHandle;
}
