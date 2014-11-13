import SimpleOpenNI.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
SimpleOpenNI context;
Calibrator calibrator;
OscManager oscManager;

int minNbPoints = 700;
float minThreshold = 1300;
float maxThreshold = 1800;
DetectionTriangle triangle;
int cornerIndex = -1;

PImage img;
PImage irImage;
PVector[] realWorldMap;

boolean debug = true;

boolean activity;
boolean lastActivity;

void setup()
{

  size(640, 480);
  //frameRate(60);

  print("init Kinect... ");
  
  initKinect(true);
  
  calibrator = new Calibrator(context);
  initUserCoordSys();

  triangle = new DetectionTriangle(0, 0, new PVector(0,0), new PVector(width, 0), new PVector(320, 350), false, color(random(255), random(255), random(255)));
  
  
  img = new PImage(640, 480);
  irImage = new PImage(640, 480);
  
  oscManager = new OscManager(this, 13001, 13000, true);
  
  textSize(15);
} 

private void initKinect(boolean mirror)
{
  print("init Kinect... ");
  
  context = new SimpleOpenNI(this);
  
  if (context == null)
  {
     println("failed !");
    return; 
    
  }
  context.setMirror(mirror); 

  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }
  
  // enable ir generation
  if(context.enableIR() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  println("done !");

  //context.alternativeViewPointDepthToImage(); what is this for ?
                          
  context.update();
}

private void initUserCoordSys()
{
  context.resetUserCoordsys();
 //context.setUserCoordsys(3017.9033, -2605.4407, -723.94, 2262.378, -3075.977, -210.39166, 3369.0005, -2185.8303, 144.36572);
context.setUserCoordsys(-360.70413, 325.26178, 3842.0, 7.5500736, 514.4062, 4021.0, -391.21658, 799.6259, 4167.0);

}


void draw () {
  background(0);
  
  context.update();

  realWorldMap = context.depthMapRealWorld();
  PVector realPoint;
  //PVector planePoint = new PVector();
  int index;
  int nbPixels = 640*480;
  
  for (int i = 0; i < nbPixels ;i+= 12)
  { 
    int x = i%640;
    int y = (int)(i/640);
    
    img.set(x, y, 0x000000);
    
    realPoint = realWorldMap[i];
    
    if (realPoint.y > minThreshold && realPoint.y < maxThreshold)
    {
      img.set(x, y, 0xaaffffff);
      
      if ( triangle.checkPoint(new PVector(x, y)) )
         img.set(x, y, triangle.shapeColor);
    }
  }
        
  if (calibrator.active)
  {
    irImage = context.depthImage();
    image(irImage, 0, 0);
    //image(context.irImage(), 0, 0);
  }
  else
    image(img, 0, 0);
    
  if (debug)
  {
    fill(255);
    text("min Z = "+minThreshold, 10, 20);
    text("max Z = "+maxThreshold, 10, 40);
    text(((int)(100*frameRate)/100f)+" fps", width - 70, 20);
    
    stroke(5);
    fill(255, 0, 0);
    ellipse(triangle.getAvgX(), triangle.getAvgY(), 20, 20);
  }

  triangle.update(debug);
  
  if (triangle.getNbPoints() > minNbPoints)
  {
    activity = true;
    
    println("send points ! "+triangle.getNbPoints());
    OscMessage myMessage = new OscMessage("/kinect/detected");
    myMessage.add(triangle.getNbPoints());
    myMessage.add(triangle.getAvgX());
    myMessage.add(triangle.getAvgY());
    
    //oscManager.send(myMessage);
    
    if(lastActivity != activity)
    {
       OscMessage am = new OscMessage("/kinect/activity");
      am.add(1);
      
      oscManager.send(am);
    }
    lastActivity = activity;
  }else
  {
    activity = false;
     if(lastActivity != activity)
    {
       OscMessage am = new OscMessage("/kinect/activity");
      am.add(0);
      
      oscManager.send(am);
    }
    
    lastActivity = activity;
  }

  
  triangle.clearPoints();
  
  calibrator.update();
}



void keyPressed()
{
  calibrator.keyPressed();
  
  switch(key)
  {
  case 'd':
    debug = !debug;
    break;
    
  case 'o':
    oscManager.debug = !oscManager.debug;
    break;
    
  case 'p':
    oscManager.massivePing();
    break;

  case '0':
  triangle.visible = false;
    cornerIndex = -1;
    break;

  case '1':
  triangle.visible = true;
    cornerIndex = 0;
    break;

  case '2':
  triangle.visible = true;
    cornerIndex = 1;
    break;

  case '3':
  triangle.visible = true;
    cornerIndex = 2;
    break;
  }

}

void mousePressed()
{
  oscManager.mousePressed();
  calibrator.mousePressed();
}

void mouseDragged()
{
  calibrator.mouseDragged();

  if (cornerIndex >= 0)
    triangle.setCorner(cornerIndex, mouseX, mouseY);
  else
  {
    minThreshold = mouseX*3000/width;
    maxThreshold = minThreshold + mouseY*1000/height;
  }
}

void mouseReleased()
{
  if (cornerIndex >= 0)
  {
    println("");
    println("new corner coordinates :");
    switch(cornerIndex)
    {
      case 0:
      println("point1 : "+triangle.point1.x+", "+triangle.point1.y);
      break;
      
      case 1:
      println("point2 : "+triangle.point2.x+", "+triangle.point2.y);
      break;
      
      case 2:
      println("point3 : "+triangle.point3.x+", "+triangle.point3.y);
      break;
    }
    println("----");
    println("");
  }
}

  void oscEvent(OscMessage theOscMessage) {
    oscManager.oscEvt(theOscMessage);
  }
