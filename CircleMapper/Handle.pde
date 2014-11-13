class Handle extends PVector
{
  
  
  public color col;
  public boolean selected;
  public float radius;
  public int index;
  public MapSurface surface;
  public PApplet parent;
  
  public Handle(PApplet parent,MapSurface surface, int index, color c)
  {
    this.parent = parent;
    if(handles == null) handles = new ArrayList<Handle>();
    this.index = index;
    handles.add(this);
    col = c;
    radius = 10;
    this.surface = surface;
    
    this.x = random(width/2)+width/4;
    this.y = random(height)+height/4;
  }
  
  public void draw()
  {
    
    radius = selected?25:15;
    
    parent.pushStyle();
    if(selected)
    {
      parent.fill(255,255,0);
    }else
    {
      parent.fill(col);
    }
    
    parent.ellipse(x,y,radius,radius);
    
    parent.popStyle();
  }
  
  public void setPosition(float tx,float ty)
  {
    x = tx;
    y = ty;
    surface.adjustHandleFromSource(this);
    
    
  }

  
}
