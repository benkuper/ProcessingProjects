

class MapSurface
{
  int index;
  public Handle[] handles; //ORDER : LEFT, UP, RIGHT, DOWN
  public Handle center;
  public PVector[] corners;
  public PVector[] extendCorners;
  
  public color col;
  
  public Keystone ks;
  public CornerPinSurface kSurface;
  
  public float extendFactor = 1; //factor is multiplicator to extend surface from diagonals length
  
  public MapApplet parent;
  
  public MapSurface(MapApplet parent, int index)
  {
    this.parent = parent;
    this.index = index; 
    handles = new Handle[4];
    center = new Handle(parent,this, -1, color(255,255,255));
    corners = new PVector[4];
    extendCorners = new PVector[4];
    col = colors[index];
    
    for (int i=0;i<handles.length;i++) 
    {
      handles[i] = new Handle(parent,this,i,colors[i]);
      corners[i] = new PVector();
      extendCorners[i] = new PVector();
    }
    
    center.setPosition(random(width/2)+width/4,random(height/2)+height/4);
    
    ks = new Keystone(parent);
    kSurface = ks.createCornerPinSurface(sourceImage.width,sourceImage.height, 20);
    
  }
  
  public void render()
  {
    kSurface.render(sourceImage);
  }

  public void draw()
  {

    //COMPUTE
    
    PVector h1 = getHorizon(handles[0], handles[2]);
    PVector h2 = getHorizon(handles[1], handles[3]);
    
    if (h1 == null || h2 == null)
      return;
      
    computeSquarePoints(h1,h2);
    extendSurface(h1,h2);
    updateKeystoneExtended();
    
    
    //DRAW
    
    
    
    if(parent.calibrating)
    {
      for (int i=0;i<handles.length;i++) handles[i].draw();
      center.draw();
      
      parent.pushStyle();
      parent.stroke(255);
      parent.strokeWeight(2);
      parent.noFill();
      
      parent.stroke(255,100);
      parent.strokeWeight(1);
      parent.line(handles[0].x,handles[0].y,handles[2].x,handles[2].y);
      parent.line(handles[1].x,handles[1].y,handles[3].x,handles[3].y);
      
      parent.stroke(255,50);
      parent.strokeWeight(2);
      parent.beginShape();
      parent.vertex(corners[0].x,corners[0].y);
      parent.vertex(corners[1].x,corners[1].y);
      parent.vertex(corners[3].x,corners[3].y);
      parent.vertex(corners[2].x,corners[2].y);
      parent.vertex(corners[0].x,corners[0].y);
      parent.endShape();
      
      parent.popStyle();
    }
     
  }
  
  public void updateKeystone()
  {
    
    kSurface.setHandlePos(CornerPinSurface.TL, corners[0].x,corners[0].y);
    kSurface.setHandlePos(CornerPinSurface.TR, corners[2].x,corners[2].y);
    kSurface.setHandlePos(CornerPinSurface.BL, corners[1].x,corners[1].y);
    kSurface.setHandlePos(CornerPinSurface.BR, corners[3].x,corners[3].y);
    
  }
  
  public void updateKeystoneExtended()
  {
    
    kSurface.setHandlePos(CornerPinSurface.TL, extendCorners[0].x,extendCorners[0].y);
    kSurface.setHandlePos(CornerPinSurface.TR, extendCorners[2].x,extendCorners[2].y);
    kSurface.setHandlePos(CornerPinSurface.BL, extendCorners[1].x,extendCorners[1].y);
    kSurface.setHandlePos(CornerPinSurface.BR, extendCorners[3].x,extendCorners[3].y);
    
  }
  
  PVector getHorizon(Handle p1, Handle p2)
  {
    PVector p1p = new PVector(p1.x, p1.y);
    PVector p2p = new PVector(p2.x, p2.y);
    PVector cp = new PVector(center.x, center.y);
    
    PVector up1 = new PVector(p1.x, p1.y - elevation);
    

    PVector centerUp = new PVector(center.x, center.y - elevation);
    PVector centerMid = findIntersection(up1, p2p, cp, centerUp);

    
    PVector up1Mid = new PVector(p1.x, p1.y - elevation / 2);
    PVector horizon = findIntersection(up1Mid, centerMid, p1p, p2p);
    
    if (horizon == null)
      return null;
    
   
    return horizon;
  }
  
  
  public void adjustHandleFromSource(Handle source)
  {
    if (source == center)
    {
      this.adjustHandleFromSource(handles[0]);
      this.adjustHandleFromSource(handles[1]);
      return;
    }
    
    
    Handle target = getTargetHandleFromSource(source);
    
    if(target == null) return;
    float sAngle = atan2(source.y - center.y, source.x - center.x);
    float invAngle = sAngle + PI;
    float dDist = PVector.dist(new PVector(target.x, target.y), new PVector(center.x, center.y));
    
    target.x = center.x + cos(invAngle) * dDist;
    target.y = center.y + sin(invAngle) * dDist;
  
  }

  void computeSquarePoints(PVector h1, PVector h2)
  {
    PVector p1p = new PVector(handles[0].x, handles[0].y);
    PVector p2p = new PVector(handles[1].x, handles[1].y);
    PVector p3p = new PVector(handles[2].x, handles[2].y);
    PVector p4p = new PVector(handles[3].x, handles[3].y);
    
    PVector i1 = findIntersection(h1, p2p, h2, p1p);
    PVector i2 = findIntersection(h1, p2p, h2, p3p);
    PVector i3 = findIntersection(h1, p4p, h2, p1p);
    PVector i4 = findIntersection(h1, p4p, h2, p3p);
    
    pushStyle();
    

    
    popStyle();
    
    corners[0] = i1;
    corners[1] = i2;
    corners[2] = i3;
    corners[3] = i4;
  }
  
  
  void extendSurface(PVector h1, PVector h2)  
  {
  
    PVector s1p = new PVector(corners[0].x, corners[0].y);
    PVector s2p = new PVector(corners[1].x, corners[1].y);
    PVector s3p = new PVector(corners[2].x, corners[2].y);
    PVector s4p = new PVector(corners[3].x, corners[3].y);
    
    
    PVector up2 = new PVector(s2p.x, s2p.y - elevation);
    PVector up3 = new PVector(s3p.x, s3p.y - elevation);
    PVector up4 = new PVector(s4p.x, s4p.y - elevation);
    
    
    PVector diagH14 = findIntersection(h1, h2, s1p, s4p);
    PVector diagH23 = findIntersection(h1, h2, s2p, s3p);
    
    PVector ext1 = getExtPoint(s1p, s4p, diagH14,extendFactor);
    PVector ext4 = getExtPoint(s4p, s1p, diagH14,extendFactor);
    PVector ext2 = getExtPoint(s2p, s3p, diagH23,extendFactor);
    PVector ext3 = getExtPoint(s3p, s2p, diagH23,extendFactor);
    
    
    extendCorners[0].set(ext4);
    extendCorners[1].set(ext3);
    extendCorners[2].set(ext2);
    extendCorners[3].set(ext1);
  }


  
  //util
  Handle getTargetHandleFromSource(Handle sourceHandle)
  {
    return handles[(Arrays.asList(handles).indexOf(sourceHandle) + 2) % handles.length];
  }
  
  
  //
  public String getData()
  {
    String s = center.x+" "+center.y+"\t";
    
    for(int i=0;i<handles.length;i++)
    {
      s += handles[i].x+" "+handles[i].y;
      if(i < handles.length -1) s += '\t';
    }
    
    return s;
  }
  
  public void loadData(String data)
  {
    String[] dSplit = split(data,'\t');
    for(int i=0;i<dSplit.length;i++)
    {
      String[] dS = split(dSplit[i],' ');
      if(i == 0)
      {
        center.x = float(dS[0]);
        center.y = float(dS[1]);
      }else
      {
        handles[i-1].x = float(dS[0]);
        handles[i-1].y = float(dS[1]); 
      }
    }
  }
}

