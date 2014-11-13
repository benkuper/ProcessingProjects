import javax.swing.JFrame;
import java.awt.BorderLayout;
import java.awt.Insets;

class ScreenFrame extends JFrame {
  public PApplet sketch;
  
  ScreenFrame(PApplet p) {
    int w = 400;
    int h = 400;
    sketch = p;
    
    setVisible(true);
    removeNotify();
    setUndecorated(true);
    addNotify();
    setAlwaysOnTop(true);
    setLayout(new BorderLayout());
    add(p, BorderLayout.CENTER);
    p.frame = this;
    p.init();
    
    Insets insets = getInsets();
    setSize(insets.left + w, insets.top + h);
    p.setBounds(insets.left, insets.top, w, h);
    
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }
}

class MapApplet extends PApplet {
  
  public MapSurface surface;
  public boolean calibrating;
  
  void setup() {
    frame.setResizable(true);
    size(200,200, OPENGL);
    smooth();
    
    calibrating = true;
  }
  
  void draw() {
    background(0);
    if(surface != null) 
    {
      surface.render();
      surface.draw();
    }
    
    draw2();
  }
  
  void draw2()
  {
    if(!isMouseInFrame()) return;
    
    if(selectedHandle != null)
    {
      if(shiftKey)
      {
        for(int i=0;i<selectedHandle.surface.handles.length;i++)
        {
          Handle sh = selectedHandle.surface.handles[i];
          sh.x = mouseX - surfaceHandleOffsets[i].x;
          sh.y = mouseY - surfaceHandleOffsets[i].y;
        }
        selectedHandle.surface.center.x = mouseX - surfaceHandleOffsets[4].x;
        selectedHandle.surface.center.y = mouseY - surfaceHandleOffsets[4].y;
        
      }else
      {
        selectedHandle.setPosition(mouseX - mouseOffset.x,mouseY - mouseOffset.y);
      }
      
      
    }else
    {
      closestHandle = getClosestHandle(this);
    }
    
    if(calibrating)
    {
      float radius = 30;
      if(closestHandle != null)
      {
        pushStyle();
        stroke(255,255,0);
        strokeWeight(2);
        fill(255,255,0,150);
        ellipse(mouseX,mouseY,radius,radius);
        
        noStroke();
        float angle = PVector.angleBetween(new PVector(1,0),new PVector(mouseX-closestHandle.x,mouseY-closestHandle.y));
        PVector p1 = new PVector(mouseX+cos(angle+PI/2)*radius/2,mouseY+sin(angle+PI/2)*radius/2);
        PVector p2 = new PVector(mouseX+cos(angle-PI/2)*radius/2,mouseY+sin(angle-PI/2)*radius/2);
        ellipse(p1.x,p1.y,5,5);
        ellipse(p2.x,p2.y,5,5);
        beginShape();
        vertex(p1.x,p1.y);//,h.x,h.y);
        vertex(closestHandle.x,closestHandle.y);//,p2.x,p2.y);
        vertex(p2.x,p2.y);//,p1.x,p1.y);
        endShape();
        popStyle();
      }
    }
  }
  
  boolean isMouseInFrame()
  {
    return mouseX > 5 && mouseX < width-5;
  }
  
  //MOUSE

  void mousePressed()
  {
    setSelectedHandle(closestHandle);
  }
  
  void mouseReleased()
  {
    setSelectedHandle(null);
  }

  void keyPressed(KeyEvent e)
  {
    if(keyCode == SHIFT) shiftKey = true;
    
    switch(key)
    {
      case 'g':
      calibrating = !calibrating;
      break;
      
      case '*':
      surface.extendFactor += .02;
      break;
      
      case '/':
      surface.extendFactor = max(surface.extendFactor-.02,1);
      break;
    }
  }
  
  void keyReleased()
  {
    shiftKey = false;
  }

}
