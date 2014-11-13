


PVector getExtPoint(PVector p1,  PVector p2, PVector diagH, float factor)//2 points, opposites
{
  PVector up1 = new PVector(p1.x, p1.y - elevation);
  float fElevation = max(elevation * (1 - (1 / factor)), 0);
  PVector up1Mid = new PVector(p1.x, p1.y - fElevation);
  PVector up2 = new PVector(p2.x, p2.y - elevation);
  
  PVector p2PerspMid= findIntersection(up1Mid, diagH, p2, up2);
  PVector ext = findIntersection(up1, p2PerspMid, p1, p2);
  
  return ext;
}


//utils

PVector findIntersection(PVector A, PVector B, PVector E,  PVector F)
{
  return findIntersection(A, B, E, F, false);
}

PVector findIntersection(PVector A, PVector B, PVector E,  PVector F, boolean as_seg)
{
  if(A == null || B == null || E == null || F == null) return null ;
  
  PVector ip;
  float a1;
  float a2;
  float b1;
  float b2;
  float c1;
  float c2;
  
  a1 = B.y - A.y;
  b1 = A.x - B.x;
  c1 = B.x * A.y - A.x * B.y;
  a2 = F.y - E.y;
  b2 = E.x - F.x;
  c2 = F.x * E.y - E.x * F.y;
  
  float denom = a1 * b2 - a2 * b1;
  if (denom == 0)
  {
    return null;
  }
  
  ip = new PVector();
  ip.x = (b1 * c2 - b2 * c1) / denom;
  ip.y = (a2 * c1 - a1 * c2) / denom;
  
  //---------------------------------------------------
  //Do checks to see if intersection to endpoints
  //distance is longer than actual Segments.
  //Return null if it is with any.
  //---------------------------------------------------
  if (as_seg)
  {
    if (pow(ip.x - B.x, 2) + pow(ip.y - B.y, 2) > pow(A.x - B.x, 2) + pow(A.y - B.y, 2))
    {
      return null;
    }
    if (pow(ip.x - A.x, 2) + pow(ip.y - A.y, 2) > pow(A.x - B.x, 2) + pow(A.y - B.y, 2))
    {
      return null;
    }
    
    if (pow(ip.x - F.x, 2) + pow(ip.y - F.y, 2) > pow(E.x - F.x, 2) + pow(E.y - F.y, 2))
    {
      return null;
    }
    if (pow(ip.x - E.x, 2) + pow(ip.y - E.y, 2) > pow(E.x - F.x, 2) + pow(E.y - F.y, 2))
    {
      return null;
    }
  }
  return ip;
}
