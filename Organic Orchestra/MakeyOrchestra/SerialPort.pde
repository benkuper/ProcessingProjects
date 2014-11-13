public class SerialPort
{
  
  PApplet parent;
  
  Serial serial;
  int[] buffer;
  final int maxBuffer = 32;
  int bufferIndex;
  
  int index;
  String portName;
  
  int startTrack;
  
  boolean connected;
  long connectTryTime = 3000;
  long lastConnectTime;
  
  final int numPinPerUser = 3; //mute, volume up, volume down
  final int numUsersPerPort = 6;
  
  public SerialPort(PApplet parent, int index, String portName)
  {
    this.parent = parent;
    this.index = index;
    startTrack = (index * numUsersPerPort);
    //println("Start track :"+startTrack+" ["+portName+"]");
    this.portName = portName;
   
    // setConnected(true); //DEBUG
     
     connect();
     
    buffer = new int[maxBuffer];
    bufferIndex = 0;
  }
  
  public void connect()
  {
    if(connected == true) return;
    
    setConnected(false);
    lastConnectTime = millis();
    
    try
    {
      serial = new Serial(parent, portName, 9600);
     setConnected(true);
     println(portName+" is connected !");
    }catch(Exception e)
    {
      println("# Error connecting to "+portName);
    }
  }
  
  public void update()
  {
    if(!connected)
    {
      if(millis() - lastConnectTime > connectTryTime) connect();
      return;
    }
    
    if(serial == null) return;
    
    while (serial.available () > 0)
    {
      int c = serial.read();
      switch(c)
      {
        case 255:
        processBuffer();
        bufferIndex = 0;
        break;
        
        case 112: //p
        bufferIndex = 0;
        break;
        
        default:
        if(bufferIndex < maxBuffer-1)
        {
          buffer[bufferIndex] = c;
          bufferIndex++;
        }
      }
    }
  }
  
  public void processBuffer()
  {
    int pin = buffer[0];
    int val = buffer[1];
    
    int track = startTrack+floor(pin/3);
    int command = pin%3;
    
    println("Process buffer :"+pin+"/"+val +"::"+track+"/"+command);
    
    switch(command)
    {
      case 0: //Mute
      if(val == 1)live.toggleMute(track);
      break;
      
      case 1: //Volume up
      live.dimVolume(track,(val == 1)?1f:0f);
      break;
      
      case 2: //Volume down
      live.dimVolume(track,(val == 1)?-1f:0f);
      break;
      
      
       /* for one makey control (game-like)
      case 0:
        live.dimVolume((val == 1)?.01f:0f);
        break;
        
      case 1:
       live.dimVolume((val == 1)?-.01f:0f);
       break;
       
       case 2:
        if(val == 1) live.toggleMute();
        break;  
      
      
      case 2:
       if(val == 1) live.prevTrack();
       break;
       
      case 3:
      if(val == 1) live.nextTrack();
      break;   
    */        
    }
  }
  
  
   public void setConnected(boolean value)
  {
    connected = value;
    for(int i=startTrack;i<startTrack+numUsersPerPort;i++)
    {
      live.connected[i] = true;
    }
  }
}
