public class Conduite
{
  XML xml;
  State[] states;
  int stateIndex;
  State currentState;
  
  public Conduite()
  {
     xml = loadXML("conduite.xml");
    XML[] children = xml.getChildren("state");
   states = new State[children.length];
    for (int i = 0; i < children.length; i++) {
       states[i] = new State(children[i]);
    }
    
    setState(0);
  }
  
  public void draw()
  {
    if(currentState == null) return;
    currentState.draw();
  }
  
  public void processPad(int pad)
  {
    println("Conduite process pad "+pad);
    if(currentState == null) return;
    currentState.processPad(pad);
  }
  
  public void nextState()
  {
    setState(stateIndex+1);
  }
  
  public void prevState()
  {
    setState(stateIndex-1);
  }
  
  public void setState(int state)
  {
    clearLeds();
    
    if(state < 0 || state >= states.length) 
    {
      currentState = null;
      return;
    }
    
    stateIndex = state;
    
    currentState = states[stateIndex];
    currentState.load();
    
  }
  
}


public class State
{
  public String text;
  
  public PadMap[] padMaps;
  
  public State(XML data)
  {
   
    this.text = data.getString("text");
    
    XML[] children = data.getChildren("pad");
   padMaps = new PadMap[children.length];
    for (int i = 0; i < children.length; i++) {
       padMaps[i] = new PadMap(children[i]);
    }
  }
  
  public void draw()
  {
    pushStyle();
    fill(255);
    textSize(30);
    text(text,20,220,650,150);
    popStyle();
  }
  
  public void load()
  {
    for(int i=0;i<padMaps.length;i++)
    {
      padMaps[i].load();
    }
    
    println("State load :"+text);
  }
  
  public void processPad(int pad)
  {
    for(int i=0;i<padMaps.length;i++)
    {
     if(padMaps[i].pad == pad) padMaps[i].process();
    }
  }
}



public class PadMap
{
  public OSCTrigger[] oscs;
  public int pad;
  public int col;
  
  public boolean triggerNext;
  
  public PadMap(XML data)
  {
    pad = data.getInt("id");
    println("New PadMap : "+pad);
    col = getColorForString(data.getString("color"));
    
     XML[] children = data.getChildren("osc");
     oscs = new OSCTrigger[children.length];
      for (int i = 0; i < children.length; i++) {
         oscs[i] = new OSCTrigger(children[i]);
      }
      
      if(data.getString("next") != null) triggerNext = true;
  }
  
  public void load()
  {
    setLed(pad,col);
  
  }
  
  public void process()
  {
    for(int i=0;i<oscs.length;i++) oscs[i].process();
    if(triggerNext) conduite.nextState();
  }
}

public class OSCTrigger
{
  OscMessage msg;
  
  public OSCTrigger(XML data)
  {
    msg = new OscMessage(data.getString("message"));
    char type='i';
    if(data.getString("type") != null)
    {
      type = data.getString("type").charAt(0);
    }
    switch(type)
    {
      case 'i':
        msg.add(data.getInt("arg"));
        break;
        
      case 'f':
        msg.add(data.getFloat("arg"));
        break;
    }
  }
  
  public void process()
  {
    sendOSC(msg);
  }
}
