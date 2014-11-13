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
    
Keystone ks;

boolean calibrating;
PImage sourceImage; //will be syphon or spout
PImage calibImage;

void setup()
{
  
  //WINDOW INIT NOT WORKING WITH OPENGL
 //frame.removeNotify();
 /*
 frame.setUndecorated(true);
  */
  //frame.addNotify();
  
 frame.setAlwaysOnTop(true);

 frame.setResizable(true);
 
 size(800,800,OPENGL);
  
  
  //INIT LIBS
  ks = new Keystone(this);
   
  //COLORS
  colors = new color[4];
  colors[0] = color(255,0,0);
  colors[1] = color(0,150,255);
  colors[2] = color(0,255,0);
  colors[3] = color(255,0,255);
  
  surfaceHandleOffsets = new PVector[5];
  
  //FOR TESTING AND CALIB
  calibrating = true;
  sourceImage = loadImage("calib_uv.jpg");
  calibImage = loadImage("calib.jpg"); 
  
  
 
  
  //SCREENS
   screens = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
   
  //INIT
  windowLoc = new PVector();
  targetLoc = new PVector(20,20);
  
  curScreen = 0;
  targetScreen = 0;
  
  surfaces = new MapSurface[numSurfaces];
  
  for(int i=0;i<numSurfaces;i++)
  {
    surfaces[i] = new MapSurface(i);
  }
}


void draw()
{
  background(0);
  
  for(int i=0;i<numSurfaces;i++)
  {
    surfaces[i].render();
  }
  
  
  for(int i=0;i<numSurfaces;i++)
  {
    surfaces[i].draw();
  }
  
  
  if(selectedHandle != null)
  {
    if(shiftKey)
    {
      for(int i=0;i<selectedHandle.surface.handles.length;i++)
      {
        Handle sh = selectedHandle.surface.handles[i];
        sh.x = mouseX - surfaceHandleOffsets[i].x;
        sh.y = mouseY - surfaceHandleOffsets[i].y;
      }
      selectedHandle.surface.center.x = mouseX - surfaceHandleOffsets[4].x;
      selectedHandle.surface.center.y = mouseY - surfaceHandleOffsets[4].y;
      
    }else
    {
      selectedHandle.setPosition(mouseX - mouseOffset.x,mouseY - mouseOffset.y);
    }
    
    
  }else
  {
    closestHandle = getClosestHandle(mouseX,mouseY);
  }
  
  float radius = 30;
  if(closestHandle != null)
  {
    pushStyle();
    stroke(255,255,0);
    strokeWeight(2);
    fill(255,255,0,150);
    ellipse(mouseX,mouseY,radius,radius);
    
    noStroke();
    float angle = PVector.angleBetween(new PVector(1,0),new PVector(mouseX-closestHandle.x,mouseY-closestHandle.y));
    PVector p1 = new PVector(mouseX+cos(angle+PI/2)*radius/2,mouseY+sin(angle+PI/2)*radius/2);
    PVector p2 = new PVector(mouseX+cos(angle-PI/2)*radius/2,mouseY+sin(angle-PI/2)*radius/2);
    ellipse(p1.x,p1.y,5,5);
    ellipse(p2.x,p2.y,5,5);
    beginShape();
    vertex(p1.x,p1.y);//,h.x,h.y);
    vertex(closestHandle.x,closestHandle.y);//,p2.x,p2.y);
    vertex(p2.x,p2.y);//,p1.x,p1.y);
    endShape();
    popStyle();
  }
  
  
  
  
  
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
  case 'g':
    calibrating = !calibrating;
    break;

  case '+':
   targetScreen++;
   break;
  
  case '-':
    targetScreen--;
    break;
    
    case '*':
    for(int i=0;i<surfaces.length;i++) surfaces[i].extendFactor += .05;
    break;
    
    case '/':
    for(int i=0;i<surfaces.length;i++) surfaces[i].extendFactor = max(surfaces[i].extendFactor-.05,1);
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


//MOUSE

void mousePressed()
{
  setSelectedHandle(closestHandle);
}

void mouseReleased()
{
  setSelectedHandle(null);
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
   println("set window loc");
  GraphicsDevice screen = screens[index%screens.length];
  Rectangle bounds= screen.getConfigurations()[0].getBounds();

  frame.setLocation(bounds.x,bounds.y-40);
  frame.setSize(bounds.width,bounds.height+60);
  
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
    mouseOffset = new PVector(mouseX-selectedHandle.x,mouseY-selectedHandle.y);
    
    for(int i=0;i<selectedHandle.surface.handles.length;i++)
    {
      Handle sh = selectedHandle.surface.handles[i];
      surfaceHandleOffsets[i] = new PVector(mouseX-sh.x,mouseY-sh.y);
    }
    Handle ch = selectedHandle.surface.center;
    surfaceHandleOffsets[4] = new PVector(mouseX-ch.x,mouseY-ch.y);
    
    selectedHandle.selected = true;
  }
  
}

Handle getClosestHandle(int tx, int ty)
{
  float dist = -1;
  Handle closestHandle = null;
  
  for(Handle h:handles)
  {
    float nextDist = dist(h.x,h.y,tx,ty);
    if(dist == -1 || dist > nextDist)
    {
      closestHandle = h;
      dist = nextDist;
    }
  }
  
  return closestHandle;
}
