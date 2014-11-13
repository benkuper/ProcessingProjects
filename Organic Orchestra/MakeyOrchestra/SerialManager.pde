public class SerialManager
{
   SerialPort[] serialPorts;
   final String[] ports = {"COM68","COM71","COM69","COM70","COM73"};//r,"COM72"}; // A, B, C , D, E, F
   final int numPorts = ports.length;
   
   public SerialManager(PApplet parent)
   {
     
     serialPorts = new SerialPort[numPorts];
     for(int i=0;i<numPorts;i++)
     {
       serialPorts[i] = new SerialPort(parent,i,ports[i]);
     }
   }
   
   public void update()
   {
     for(int i=0;i<numPorts;i++)
     {
       serialPorts[i].update();
     }
   }
}
