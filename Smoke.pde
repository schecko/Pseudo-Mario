//simple smoke animation for character deaths
class Smoke extends GameObject
{
  PImage smoke[] = new PImage[7]; //animation frames for the smoke
  int timer; //timer for the smokes lifespan
  Smoke(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    for (int i = 0; i < smoke.length; i++)
    {
      PImage frame = loadImage("Smoke/Smoke" + i + ".png");
      frame.resize((int)dim.x, (int)dim.y);
      smoke[i] = frame;
      animRate = 6;
      timer = animRate * smoke.length;
    }
  }
  //updates the current frame of the smoke
  void updateFrames()
  {
    if (frameCount % animRate == 0)
    {
      if (currFrame < smoke.length -1)
      {
        currFrame++;
      } else
      {
        currFrame = 0;
      }
    }
  }
  //updates the spots position
  void update()
  {
    timer--;
    if (timer <= 0)
    {
      ALbackground.remove(this);
    }
    super.update();
    updateFrames();
  }
  //renders the smoke
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(smoke[currFrame], 0, -dim.y/2);
    popMatrix();
  }
}

