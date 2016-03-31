//spring trap, when stepped on will fling mario upwards or sideways
class SpringTrap extends InteractibleObject
{
  PImage trap; //image of the trap
  float jumpMult; //jump multiplier 
  boolean side; //boolean set to true if the trap launches mario sideways
  SpringTrap(float xPos, float yPos, float dimX, float dimY, float jumpMult, boolean side)
  {
    super(xPos, yPos, dimX, dimY);
    trap = loadImage("SpringTrap.png");
    trap.resize((int)dim.x, (int)dim.y);
    this.jumpMult = jumpMult;
    this.side = side;
    if (side)
    {
      rot = PI/2;
    }
  }
  //renders the trap
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    rotate(rot);
    image(trap, 0, -dim.y/2);
    popMatrix();
  }
  //updates the trap
  void update()
  {
    super.update();
    if (hit(mario))
    {
      effect = minim.loadFile("Music/SpringJump.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      if (side)
      {
        mario.sideLaunch();
      } else
      {
        mario.jump(mario.jumpHeight*jumpMult);
      }
    }
  }
}