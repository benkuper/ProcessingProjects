public class Discover implements BrowseListener {
  // the constructor.
 public Discover(){
    try {
      DNSSDService browser = DNSSD.browse("_osc._udp", this);
    } catch (DNSSDException e) {
      // do something fancy here.
      println("Discover browser ERROR : ");
      e.printStackTrace();
    }
  }
  public void serviceLost(DNSSDService browser, int flags, int ifIndex,
        String serviceName, String regType, String domain) {
          println("service lost");
  }

  public void serviceFound(DNSSDService browser, int flags, int ifIndex,
        String serviceName, String regType, String domain) {
          println("service found : "+serviceName+"/"+regType);
  }

        public void operationFailed(DNSSDService arg0, int arg1) {
    // this one is required by BaseListener, which is the parent of all other Listener Interfaces.
    println("operation failed");
  }
}
