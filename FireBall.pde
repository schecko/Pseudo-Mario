//fireball which can be thrown by fire mario
class FireBall extends InteractibleObject
{
  PImage fire; //image for the fire
  int timer; //timer for the object, once zero the object is deleted from the arraylist
  FireBall(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    fire = loadImage("FireBall.png");
    fire.resize((int)dim.x, (int) dim.y);
    timer = (int)frameRate * 4;
    speed = new PVector(-gSpeed.x + 3, 0);
  }
  //renders the object
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    rot+=.2;
    rotate(rot);
    image(fire, 0, 0);
    popMatrix();
  }
  //updats the object
  void update()
  {
    timer--;
    if (timer <= 0)
    {
      ALinteractible.remove(this);
    }
    super.update();
    pos.add(speed);
    for (int i = ALcharacters.size () -1; i >= 0; i--)
    {
      CharacterObject c = (CharacterObject) ALcharacters.get(i);
      if (hit(c) && !c.invincible)
      {
        c.hitSuccess(2);
      }
    }
  }
}