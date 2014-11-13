import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress remote;

final String remoteHost = "127.0.0.1";
final int remotePort = 8001;
final int localPort = 8000;

class OSCManager
{
  public void OSCManager()
  {
    oscP5 = new OscP5(this,12000);
    remote = new NetAddress("127.0.0.1",12000);
  }
  
  public void processOSC()
  {
    
  }
}
