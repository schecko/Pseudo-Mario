//basic interactible object, superclass to coins for example
class InteractibleObject extends GameObject
{
  InteractibleObject(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
  
  }
  //default collision detection
  //uses the bounding box method, and returns true if the objects in question are hitting eachother, else false
  boolean hit(InteractibleObject iO)
  {
    if(abs(pos.x - iO.pos.x) <= dim.x/2 + iO.dim.x/2 && abs(pos.y - iO.pos.y) <= dim.y/2 + iO.dim.y/2)
    return true;
    else
    return false;
  }



}
