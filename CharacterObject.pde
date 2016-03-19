//basic character object with no artificial intelligence

class CharacterObject extends InteractibleObject
{
  int health, HEALTH, iFrames, IFRAMES; //current health of this object, max health of this object, current invincible frames of this object, max invincible frames of this object
  boolean jumping, invincible; //boolean which is true if the object is jumping, boolean that is true if the current object cannot be hit
  PImage cImage; //image of the current object
  float defaultSpeed; //speed of the current object
  Foreground currFG = null; //if the current object is standing on an object, this is that object

  CharacterObject(float xPos, float yPos, float dimX, float dimY, int health, String path)
  {
    super(xPos, yPos, dimX, dimY);
    cImage = loadImage(path);
    cImage.resize((int) dim.x, (int) dim.y);
    jumping = true;
    invincible = false;
    IFRAMES = 60;
    iFrames = IFRAMES;
    speed = new PVector(0, 0);
    this.HEALTH = health;
    this.health = HEALTH;
    defaultSpeed = 5;
  }
  //called if the object is in the same space as another object
  //and will lower the health of this object while setting it to be unattackable
  void hitSuccess(int h)
  {
    health-=h;
    invincible = true;
    iFrames = IFRAMES;
  }
  //renders the image from the data file, the "origin" is the bottom center of the image
  //also flips the image to face the correct orientation during movement
  void render()
  {
    if (!invincible || ( invincible && iFrames % 2 == 0))
    {
      pushMatrix();
      translate(pos.x, pos.y);
      imageMode(CENTER);
      if (speed.x < 0)
      {
        scale(1, (float)health/(float) HEALTH);
      } else
      {
        scale(-1, (float) health/ (float) HEALTH);
      }
      image(cImage, 0, -dim.y/2);
      popMatrix();
      healthbar();
    }
  }
  //sets the current object to land on dirt if they are close and the object is falling
  void land(Foreground fG)
  {
    currFG = fG;
    speed.y = 0;
    pos.y = fG.pos.y;
    jumping = false;
  }
  //handles the movement, death, life, and where the object is currently standing
  void update()
  {
    super.update();
    pos.add(speed);
    if (health <= 0)
    {
      for (int i = 0; i < random (5, 15); i++)
      {
        ALinteractible.add(new Coin(random(pos.x - 3*dim.x, pos.x + 3*dim.x), pos.y + random(-10, 10), 50, 50));
      }
      ALbackground.add(new Smoke(pos.x, pos.y + 10, dim.x * 2, dim.y * 3));
      ALcharacters.remove(this);
    }
    if (invincible)
    {
      iFrames--;
    }
    if (invincible && iFrames <= 0)
    {
      invincible = false;
    }
    if (currFG != null)
    {
      if (!currFG.check(this))
      {
        currFG = null;
      }
    } else if (currFG == null)
    {
      speed.add(new PVector(0, 1.5)); //gravity
    }
  }
  //moves the player up, and sets the boolean jumping to true
  void jump(float jSpeed)
  {
    speed = new PVector(0, -jSpeed);
    jumping = true;
    currFG = null;
  }
  //renders a healthbar for the current object
  void healthbar()
  {
    pushMatrix();
    translate(pos.x, pos.y - dim.y);
    rectMode(CENTER);
    float hRatio = (float)health/ (float)HEALTH;
    if (hRatio > .5)
    {
      fill(#34FF08);
    } else
    {
      fill(#FF0808);
    }
    rect(0, 0, (float) hRatio * 100, 3);
    popMatrix();
  }
}