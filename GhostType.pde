//more difficult enemy to kill than the walking type, which floats and has more random movements
class GhostType extends AIObject
{
  GhostType(float xPos, float yPos, float dim, int health, String path, float sightDistance)
  {
    super(xPos, yPos, dim, dim, health, path, sightDistance);
  }
  //updates the current object
  void update()
  {
    aI();
    pos.add(gSpeed);
    pos.add(speed);
    if (health <= 0)
    {
      effect = minim.loadFile("Music/CoinSound.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      mario.coins +=(int) random(3, 7);
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
    walls();
  }
  //checks to see if mario is in the range of this objects vision
  boolean playerSpotted()
  {
    if (dist(mario.pos.x, pos.x, mario.pos.y, pos.y) < sightDistance)
    {
      sightDistance*=3; //once they notice mario, he wont be able to run away
      return true;
    } else
    {
      return false;
    }
  }
  //keeps the object from running too far off screen
  void walls()
  {
    if (pos.y < 30)
    {
      speed = new PVector(0, defaultSpeed);
    }
    if (pos.y > height * 8/7)
    {
      speed = new PVector(0, -defaultSpeed);
    }
  }
  //renders the current object
  void render()
  {
    if (!invincible || ( invincible && iFrames % 2 == 0))
    {
      pushMatrix();
      translate(pos.x, pos.y);
      imageMode(CENTER);
      if (speed.x < 0)
      {
        scale(1, 1);
      } else
      {
        scale(-1, 1);
      }
      image(cImage, 0, -dim.y/2);
      popMatrix();
      healthbar();
    }
  }
  //causes the object to move toward mario
  void aI()
  {
    if (playerSpotted())
    {
      float angle = atan2(mario.pos.y - pos.y, mario.pos.x - pos.x);
      speed.add(PVector.fromAngle(angle));
      speed.mult(.5);
    } else if (frameCount % randomTime == 0)
    {
      speed = new PVector(random(-defaultSpeed, defaultSpeed), random(-defaultSpeed, defaultSpeed));
    }
  }
} //class

