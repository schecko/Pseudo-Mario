//coin for currency in the game
class Coin extends InteractibleObject
{
  PImage coin[] = new PImage[7]; //array of images used for the coin "animation"
  Coin(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    animRate = 5;
    for (int i = 0; i < coin.length; i++)
    {
      PImage frame = loadImage("Coins/Coin" + i + ".png");
      frame.resize((int)dim.x, (int)dim.y);
      coin[i] = frame;
    }
  }
  //updates the currently used frame of the array of coins
  void updateFrames()
  {
    if (frameCount % animRate == 0)
    {
      if (currFrame < coin.length -1)
      {
        currFrame++;
      } else
      {
        currFrame = 0;
      }
    }
  }
  //renders the current image of coin
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(coin[currFrame], 0, -dim.y/2);
    popMatrix();
  }
  //checks to see if mario hit any coins
  boolean hit(InteractibleObject iO)
  {
    if (abs(pos.x - iO.pos.x) <= dim.x/2 + iO.dim.x/2 && abs(pos.y - iO.pos.y) <= dim.y/2 + iO.dim.y/2)
      return true;
    else
      return false;
  }
  //updates the coin object
  void update()
  {
    super.update();
    updateFrames();
    if (hit(mario))
    {
      effect = minim.loadFile("Music/CoinSound.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      ALinteractible.remove(this);
      mario.coins++;
    }
  }
}

