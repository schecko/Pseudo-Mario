//basic foreground class, which has the ability to ensure the characters on this object stay on it
class Foreground extends InteractibleObject
{
  boolean deathSpot; //if mario dies on this platform , or this was the last platform mario was on before death, true
  PVector origSpot; //the original spot of this object
  Foreground(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    deathSpot = false;
    origSpot = new PVector(xPos, yPos);
    
  }
  //checks to see if mario hit this object
  boolean check(CharacterObject cO)
  {
    if (abs(cO.pos.x - pos.x) < cO.dim.x / 2 + dim.x / 2 && abs(cO.pos.y - pos.y) < 40) 
    {
      return true;
    } else
    {
      return false;
    }
  }
}