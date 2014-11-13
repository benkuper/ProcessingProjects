
import java.util.List;
import java.util.Collections;
import java.util.Comparator;

public class DetectionTriangle
{
  private int x;
  private int y;
  public PVector point1;
  public PVector point2;
  public PVector point3;
  
  public PVector middlePoint;
  
  public color shapeColor;
  PVector cp1, cp2;
  
  private List<PVector> presencePoints;
  public PVector avgPoint;
  public PVector avgClosePoint;
  public int nbMaxClosePoints = 300;

  public boolean visible;
  
  public DetectionTriangle(int x, int y, PVector point1, PVector point2, PVector point3, boolean visible, color shapeColor)
  {
    this.x = x;
    this.y = y;
    this.point1 = point1;
    this.point2 = point2;
    this.point3 = point3;
    this.visible = visible;
    this.shapeColor = shapeColor;
    
    middlePoint = new PVector((point1.x+point2.x+point3.x)*.33, (point1.y+point2.y+point3.y)*.33);
    
    presencePoints = new ArrayList<PVector>();
    
    clearPoints();
  }
  
  public void update(boolean debug)
  {
    try
    {
    Collections.sort(presencePoints, new CompareMagntiudes());
    }
    catch (Exception e)
    {
      println("java sort error !");
      return;
    }
    
    int nbClosePoints = (nbMaxClosePoints < presencePoints.size())?nbMaxClosePoints:presencePoints.size();
       
    for (int i = 0 ; i < nbClosePoints ; i++)
    {
     avgClosePoint.x += presencePoints.get(i).x;
     avgClosePoint.y += presencePoints.get(i).y;
    }
    
    if (presencePoints.size() > 0)
    {
     avgPoint.x /= presencePoints.size();
     avgPoint.y /= presencePoints.size();
     
     avgClosePoint.x /= nbClosePoints;
     avgClosePoint.y /= nbClosePoints;
    }else 
    {
      avgPoint = new PVector(0, 0);
      avgClosePoint = new PVector(0, 0);
    }
    
   draw(debug);
  }
  
  public void draw(boolean debug)
  {
    pushMatrix();
    pushStyle();
    
    if (visible)
    {
      fill(shapeColor);
      strokeWeight(1);
      triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
    }  
    
    if (debug && presencePoints.size() > 0)
    {
      println("");
      fill(255);
      text(presencePoints.size(), x, y);
      
      strokeWeight(10);
      stroke(255, 0, 0);
      fill(255, 0, 0);
      point(avgPoint.x,avgPoint.y);
      text((int)avgPoint.x, middlePoint.x- 20, middlePoint.y + 20);
      text((int)avgPoint.y, middlePoint.x + 20, middlePoint.y + 20);
      
      stroke(255, 255, 0);
      fill(255, 255, 0);
      point(avgClosePoint.x,avgClosePoint.y);
      text((int)avgClosePoint.x, middlePoint.x - 20, middlePoint.y + 40);
      text((int)avgClosePoint.y, middlePoint.x + 20, middlePoint.y + 40);
      
      stroke(0, 0, 255);
      fill(0, 0, 255);
      point(presencePoints.get(0).x, presencePoints.get(0).y);
      text((int)presencePoints.get(0).x, middlePoint.x - 20, middlePoint.y + 60);
      text((int)presencePoints.get(0).y, middlePoint.x + 20, middlePoint.y + 60);
      
    }
    
    popMatrix();
    pushStyle();
  }
  
  public boolean checkPoint(PVector point)
  {
    if (SameSide(point, point1, point2, point3) && SameSide(point, point2, point1, point3) && SameSide(point, point3, point1, point2))
    {
      
       presencePoints.add(point); 
       avgPoint.x += point.x; 
       avgPoint.y += point.y;
      return true;
    }
    else
      return false;
  }
  
  public boolean SameSide(PVector p1, PVector p2, PVector a, PVector b)
  {
    b = PVector.sub(b,a);
    p1 = PVector.sub(p1,a);
    p2 = PVector.sub(p2,a);
    
    cp1 = b.cross(p1);
    cp2 = b.cross(p2);
   
    if ((cp1.dot(cp2)) >= 0) {
      return true;
    }
    else
      return false;
  }
  
  public void clearPoints()
  {
   presencePoints.clear(); 
   avgPoint = new PVector();
   avgClosePoint = new PVector();
  }
  
  public void setCorner(int cornerIndex, int newX, int newY)
  {
    switch (cornerIndex)
    {
      case 0:
      point1 = new PVector(newX, newY);
      break;
      
      case 1:
      point2 = new PVector(newX, newY);
      break;
      
      case 2:
      point3 = new PVector(newX, newY);
      break;
    }
    
    middlePoint = new PVector((point1.x+point2.x+point3.x)*.33, (point1.y+point2.y+point3.y)*.33);
  }
  
class CompareMagntiudes implements Comparator<PVector>
{
  //@Override
  int compare(PVector v1, PVector v2)
  {
    return int(v1.mag() - v2.mag());
  }
}
  
  public float getAvgX()
  {
    return (float) (avgPoint.x);
  }
  
  public float getAvgY()
  {
    return (float) (avgPoint.y);
  }
  
  public int getNbPoints()
  {
    return presencePoints.size();
  }
}

