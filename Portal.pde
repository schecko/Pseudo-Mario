//portal that when reaches initiates the loading screen and changes the levelstate
class Portal extends Foreground
{
  PImage portal[] = new PImage[10]; //frames for the portals animation
  boolean endport; //true if this portal is able to alter the gamestate
  Portal(float xPos, float yPos, float dimX, float dimY, boolean endport)
  {
    super(xPos, yPos, dimX, dimY);
    this.endport = endport;
    for (int i = 0; i < portal.length; i++)
    {
      PImage frame = loadImage("Portal/Portal" + i + ".png");
      frame.resize((int)dim.x, (int)dim.y);
      portal[i] = frame;
    }
  }
  //checks if a character object is on this object
  boolean check(CharacterObject cO)
  {
    if (abs(cO.pos.x - pos.x) < cO.dim.x / 2 + dim.x / 2 && abs(cO.pos.y - pos.y) < 50) 
    {
      return true;
    } else
    {
      return false;
    }
  }
  //updates the object and initiates the loading screen in preparation for the next level
  void update()
  {
    super.update();
    if (levelState == LEVEL_BOSS && pos.y > width * 1.2)
    {
      ALforeground.remove(this);
    }
    if (mario.currFG == this && endport)
    {
      mario.health = mario.HEALTH;
      levelComplete = true;
      gameState = MENU;
      mario.displacement = 0; //temporary
      effect = minim.loadFile("Music/HereWeGo.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      switch(levelState)
      {
      case LEVEL_ONE:
        //levelState = LEVEL_BOSS; //temp
        levelState = LEVEL_TWO;
        break;
      case LEVEL_TWO:
        levelState = LEVEL_THREE;
        break;
      case LEVEL_THREE:
        levelState = LEVEL_BOSS;
        break;
      }
    }
    updateFrames();
  }
  //updates the current frame
  void updateFrames()
  {
    if (frameCount % animRate == 0)
    {
      if (currFrame < portal.length -1)
      {
        currFrame++;
      } else
      {
        currFrame = 0;
      }
    }
  }
  //renders the current object
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    if (!endport)
    {
      scale(1, 1);
    } else
    {
      scale(-1, 1);
    }
    image(portal[currFrame], 0, -dim.y/2);
    popMatrix();
  }
}

