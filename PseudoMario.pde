//boss, can only be killed via traps or firemario
class PseudoMario extends AIObject
{
  PImage sImage; //image for the side of mario
  int randomFire; //random time counter for pseudo mario to shoot
  PseudoMario(float xPos, float yPos, float dimX, float dimY, int health, float sightDistance)
  {
    super(xPos, yPos, dimX, dimY, health, "Mario/PseudoMarioFront.png", sightDistance);
    sImage = loadImage("/Mario/PseudoMarioSide.png");
    sImage.resize((int) dim.x, (int) dim.y);
    randomFire = (int) random(30, 80);
  }
  //moves pseudomario opposite to marios movements in the x axis
  void update()
  {
    pos.x = width - mario.pos.x;
    pos.y = mario.pos.y;
    speed.x = -mario.speed.x;
    if (health <= 0)
    {
      ALcharacters.remove(this);
      ALbackground.add(new Smoke(pos.x, pos.y + 10, dim.x * 7, dim.y * 8));
      ALinteractible.add(new CoinPile(pos.x, pos.y, 100, 100, 50));
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
    if (frameCount % randomFire == 0)
    {
      ALinteractible.add(new PseudoFireBall(pos.x, pos.y - dim.y/2, 50, 50));
    }
  }
  //renders pseudomario
  void render()
  {
    if (!invincible || ( invincible && iFrames % 2 == 0))
    {
      pushMatrix();
      translate(pos.x, pos.y);
      imageMode(CENTER);
      if ((int) round(speed.x) == 0)
      {
        image(cImage, 0, -dim.y/2);
      } else
      {
        if (speed.x > 0)
        {
          scale(1, 1);
        } else
        {
          scale(-1, 1);
        }
        image(sImage, 0, -dim.y/2);
      }

      popMatrix();
    }
    healthbar();
  }
  //draws the healthbar for pseudo mario
  void healthbar()
  {
    pushMatrix();
    rectMode(CENTER);
    translate(width/2, 100);
    noStroke();
    fill(#17FF4F);
    rect(0, 0, HEALTH * 150, 35);
    fill(#FF5050);
    rect(0, 0, (float) health * 150, 45);
    textAlign(CENTER);
    fill(0);
    textSize(30);
    text("Pseudo Mario", 0, 10);
    popMatrix();
  }
}