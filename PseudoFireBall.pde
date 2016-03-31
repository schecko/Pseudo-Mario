//fireball for pseudomario, can hit only mario
class PseudoFireBall extends InteractibleObject
{
  PImage fire; //image for the pseudo fireball
  int timer; //timer for the life of this object
  PseudoFireBall(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    fire = loadImage("PseudoFireBall.png");
    fire.resize((int)dim.x, (int) dim.y);
    timer = (int)frameRate * 4;
    if (mario.pos.x > pos.x)
    {
      speed = new PVector(random(3, 5), 0);
    } else
    {
      speed = new PVector(random(-5, -3), 0);
    }
  }
  //renders the current object
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    rot+=.4;
    rotate(rot);
    image(fire, 0, 0);
    popMatrix();
  }
  //updates the current object
  void update()
  {
    timer--;
    if (timer <= 0)
    {
      ALinteractible.remove(this);
    }
    super.update();
    pos.add(speed);

    if (hit(mario) && !mario.invincible)
    {
      mario.hitSuccess(1);
    }
  }
}