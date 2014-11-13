import com.apple.dnssd.*;
import oscP5.*;

ServiceAnnouncer sa;
Discover d;
OscP5 osc;
void setup()
{
  sa = new ServiceAnnouncer();
  sa.registerService();
  
  d = new Discover();
  
  osc = new OscP5(this,1234);
  
}

void oscEvent(OscMessage msg)
{
  println("msg : "+msg.addrPattern());
}

void draw()
{
  
}

void exit()
{
  sa.unregisterService();
}


public interface IServiceAnnouncer {
  public void registerService();
  public void unregisterService();
  public boolean isRegistered();
}


public class ServiceAnnouncer implements IServiceAnnouncer, RegisterListener {
  private DNSSDRegistration serviceRecord;
  private boolean registered;

  public boolean isRegistered(){
    return registered;
  }

  public void registerService()  {
    try {
      serviceRecord = DNSSD.register(0,0,"Processing Test","_osc._udp", null,null,1234,null,this);
    } catch (DNSSDException e) {
      // error handling here
    }
  }

  public void unregisterService(){
    serviceRecord.stop();
    registered = false;
  }

  public void serviceRegistered(DNSSDRegistration registration, int flags,String serviceName, String regType, String domain){
    registered = true;
    println("service registered : "+serviceName);
  }

  public void operationFailed(DNSSDService registration, int error){
    // do error handling here if you want to.
    println("operation failed "+error);
  }
}
