//basic object with artificial intelligence

class AIObject extends CharacterObject
{
  float sightDistance; //distance that the enemy will notice mario at
  int randomTime; //random value used mostly for randomness in movement
  AIObject(float xPos, float yPos, float dimX, float dimY, int health, String path, float sightDistance)
  {
    super(xPos, yPos, dimX, dimY, health, path);
    this.sightDistance = sightDistance;
    randomTime = (int) random(160, 400);
    speed = new PVector(random(-defaultSpeed, defaultSpeed), random(-defaultSpeed, defaultSpeed));
  }
  //checks to see if the current object can "see" mario
  boolean playerSpotted()
  {
    if (abs(mario.pos.x - pos.x) < sightDistance)
    {
      sightDistance*=3; //once they notice mario, he wont be able to run away easily
      return true;
    } else
    {
      return false;
    }
  }
  //placeholder which will contain the logic for this objects artificial intelligence
  void aI()
  {
    //plceholder
  }
  //updates the object
  void update()
  {
    super.update();
    aI();
  }
}