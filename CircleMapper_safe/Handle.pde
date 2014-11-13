class Handle extends PVector
{
  
  
  public color col;
  public boolean selected;
  public float radius;
  public int index;
  public MapSurface surface;
  
  public Handle(MapSurface surface, int index, color c)
  {
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
    
    pushStyle();
    if(selected)
    {
      fill(255,255,0);
    }else
    {
      fill(col);
    }
    
    ellipse(x,y,radius,radius);
    
    popStyle();
  }
  
  public void setPosition(float tx,float ty)
  {
    x = tx;
    y = ty;
    surface.adjustHandleFromSource(this);
    
    
  }

  
}
