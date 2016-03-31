//simple enemy that can jump and will loosely follow mario
class WalkType extends AIObject
{
  WalkType(float xPos, float yPos, float dimX, float dimY, int health, String path, float sightDistance)
  {
    super(xPos, yPos, dimX, dimY, health, path, sightDistance);
  }
  //if this object sees mario, it goes toward him and randomly jumps
  void aI()
  {
    if (frameCount % randomTime == randomTime/2)
    {
      jump(25);
    }
    if (playerSpotted() && (frameCount % randomTime == 0 || frameCount % randomTime == randomTime/3))
    {
      if (pos.x < mario.pos.x )
      {
        speed.add(new PVector(defaultSpeed, 0));
      } else
      {
        speed.add(new PVector(-defaultSpeed, 0));
      }
      speed.mult(.9);
    } else if (frameCount % randomTime == 0)
    {
      speed = new PVector(random(-defaultSpeed, defaultSpeed), 0);
    }
  }
}