public class LiveManager
{
  OscP5 osc;
  NetAddress remote;
  NetAddress visualRemote;

  final int numTracks = 36;

  boolean[] actives;
  float[] volumes;
  float[] dims;
  
  float dimFactor = 0.01f;
  
  
  boolean connected[];

  //control only
  int selectedTrack;
  
  //for debugging visual without live
  boolean forceVisual = true;
  
  public LiveManager()
  {
    osc = new OscP5(this, 9001);
    osc.plug(this,"volumeChanged","/live/volume");
    osc.plug(this,"muteChanged","/live/mute");
    
    remote = new NetAddress("200.200.1.21", 9000);
    visualRemote = new NetAddress("127.0.0.1", 9010);
    
    actives = new boolean[numTracks];
    volumes = new float[numTracks];
    dims = new float[numTracks];
    connected = new boolean[numTracks];

    for (int i=0;i<numTracks;i++)
    {
      actives[i] = true;
      setVolume(i, 0f);
      setMute(i,true);
    }

    selectedTrack = 0;
  }

  public void update()
  {
    for (int i=0;i<numTracks;i++)
    {
      if (dims[i] != 0)
      {
        setVolume(i, volumes[i]+dims[i]*dimFactor);
      }


      float pos = 10 + (width-20)*i/numTracks;
      color c = color(255);
      if (i == selectedTrack) c = color(255, 255, 0);
      
      if(connected[i]) fill(255,50);
      else fill(255,0,0,50);
      
      rect(pos, height-70,10,-(height-90));
      
      fill(c, actives[i]?255:100);

      text((i+1)+"", pos-5, height-45, 20, 20);
      
      rect(pos, height-60, 10, 10);

      rect(pos, height-70, 10, -volumes[i]*(height-90));
    }
  }

  //commands
  
   public void toggleMute()
  {
    
    toggleMute(selectedTrack);
  }
  
  public void toggleMute(int track)
  {
    println("Toggle mute"+track);
    toggleMute(track,true);
  }
  
  public void toggleMute(int track, boolean sendToLive)
  {
    actives[track] = !actives[track];
    sendActive(track, actives[track]?1:0,sendToLive);
  }

  public void setMute(int track, boolean mute)
  {
    setMute(track,mute, true);
  }
  
  public void setMute(int track, boolean mute, boolean sendToLive)
  {
    actives[track] = !mute;
    sendActive(track, actives[track]?1:0,sendToLive);
  }

 

  public void setVolume(int track, float volume)
  {
    setVolume(track,volume,true);
  }
  
  public void setVolume(int track, float volume, boolean sendToLive)
  {
    volumes[track] = min(max(volume, 0), 1);
    sendVolume(track, volumes[track],sendToLive);
  }

  public void dimVolume(int track, float dim)
  {
    dims[track] = dim;
  }

  public void dimVolume(float dim)
  {
    dims[selectedTrack] = dim;
  }

  public void prevTrack()
  {
    if (selectedTrack > 0) 
    {
      dims[selectedTrack] = 0;
      selectedTrack--;
    }
  }

  public void nextTrack()
  {
    if (selectedTrack < numTracks-1) 
    {
      dims[selectedTrack] = 0;
      selectedTrack++;
    }
  }

  //OSC


  public void sendActive(int track, int active, boolean sendToLive)
  {
    OscMessage msg = new OscMessage("/live/mute");
    msg.add(track+1);
    msg.add(1-active); //mute = inverse of active
    if(sendToLive) osc.send(msg, remote);
    if(!sendToLive || forceVisual) osc.send(msg, visualRemote);
  }

  public void sendVolume(int track, float volume, boolean sendToLive)
  {
    OscMessage msg = new OscMessage("/live/volume");
    msg.add(track+1);
    msg.add(volume); //mute = inverse of active
    if(sendToLive) osc.send(msg, remote);
    if(!sendToLive || forceVisual) osc.send(msg, visualRemote);
  }


  //events
  public void keyPressed(KeyEvent e)
  {
    switch(key)
    {
    case '*':
      dimVolume(1f);
      break;

    case '/':
      dimVolume(-1f);
      break;

    case 'm':
      toggleMute(selectedTrack);
      break;

    case '0':
      toggleMute(0);
      break;

    case '1':
      toggleMute(1);
      break;

    case '2':
      toggleMute(2);
      break;

    case '+':
      nextTrack();
      break;

    case '-':
      prevTrack();
      break;
    }
  }
  
   public void keyReleased(KeyEvent e)
  {
     switch(key)
    {
    case '*':
      dimVolume(0f);
      break;

    case '/':
      dimVolume(0f);
      break;
    }
  }
  
  //From live
  void volumeChanged(int track,float volume)
  {
    println("vol changed :"+track+"/"+volume);
    setVolume(track,volume,false); 
  }
  
  void muteChanged(int track, int mute)
  {
    println("mute changed :"+track+"/"+mute);
    setMute(track,mute == 1,false); 
  }
}

