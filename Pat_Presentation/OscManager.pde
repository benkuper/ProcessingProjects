import oscP5.*;
import netP5.*;
import java.net.InetAddress;

public class OscManager 
{

  PApplet parent;
  String myIP;
  String targetIP;
  int targetPort;
  OscP5 oscP5;
  boolean local = true;
  boolean debug = false;

  public OscManager(PApplet applet, int listeningPort, int targetPort, boolean forceLocal) {
    oscP5 = new OscP5(applet, listeningPort);
    this.targetPort = targetPort;
    this.local = forceLocal;
    
    if (!local)
    {
      try {
        InetAddress inet = InetAddress.getLocalHost();
        myIP = inet.getHostAddress();
      }
      catch (Exception e) {
        e.printStackTrace();
        myIP = "couldnt get IP"; 
      }
        //massivePing();
      }
  }


  void mousePressed()
  {
    if (!debug) return;
    
    if (mouseButton == LEFT)
      massivePing();
    else
      sendMessage(13001, "coucou/message", 1, 2, 3, "tamere");
  }

  void oscEvt(OscMessage theOscMessage) {

    println(" osc received : "+theOscMessage.addrPattern());
  
    String address = (String) theOscMessage.addrPattern();
    String[] addressSplit = split(address, '/');

    String command = addressSplit[addressSplit.length - 1];

    if (command.equals("pong"))
    {
      targetIP = (String) theOscMessage.arguments()[0];
      println("pong : "+targetIP);
    }
  }
  
  public void send(OscMessage msg)
  {
    String sendIP = local?"127.0.0.1":targetIP;
    if (debug) println("send message : "+msg.addrPattern()+" on port :"+targetPort+" at "+sendIP);
    oscP5.send(msg, new NetAddress(sendIP, targetPort));
  }
  
  public void sendMessage(String adress, Object... args)
  {
    sendMessage(targetPort, adress, args);
  }
  
// TO DO : il faut spécifier le type des arguments
// TO DO : il faut différencier les premiers arguments des autres !
  public void sendMessage(int port, String adress, Object... args)
  {
    String sendIP = local?"127.0.0.1":targetIP;
    println("send message : "+adress+" on port :"+port+" at "+sendIP);
    
    OscMessage myMessage = new OscMessage("/"+myIP+"/"+adress);

    for (Object arg:args)
      myMessage.add(1); // TO DO : il faut pouvoir spécifier le type des arguments

    oscP5.send(myMessage, new NetAddress(sendIP, port));
  }
  
  public void massivePing()
  {
    println("massive ping");
    
    OscMessage pingMessage;
    pingMessage = new OscMessage("/kinect/ping");
    pingMessage.add(myIP);
    oscP5.send(pingMessage, new NetAddress("127.0.0.1", targetPort)); 
    for (int i = 0 ; i < 255 ; i++)
    {
      try{
      oscP5.send(pingMessage, new NetAddress("192.168.0."+i, targetPort)); 
      oscP5.send(pingMessage, new NetAddress("192.168.1."+i, targetPort)); 
      oscP5.send(pingMessage, new NetAddress("192.168.43."+i, targetPort));
      }catch (Exception e)
      {
        e.printStackTrace();
      }
    }
  }
}

