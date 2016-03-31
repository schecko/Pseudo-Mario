//currency for the game, was created because the chest object that created multiple instances of coins causes a small lag, this object is much less cpu intensive
class CoinPile extends InteractibleObject
{
  PImage coinPile = new PImage(); //image for the coinpile
  int coins; //variable passed in, if mario hits the coinpile he will gain coins equal to this value
  CoinPile(float xPos, float yPos, float dimX, float dimY, int coins)
  {
    super(xPos, yPos, dimX, dimY);
    animRate = 5;
    this.coins = coins;
    coinPile = loadImage("CoinPile.png");
    coinPile.resize((int)dim.x, (int)dim.y);
  }
  //renders current object
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(coinPile, 0, -dim.y/2);
    popMatrix();
  }
  //checks to see if the coinpile was hit
  boolean hit(InteractibleObject iO)
  {
    if (abs(pos.x - iO.pos.x) <= dim.x/2 + iO.dim.x/2 && abs(pos.y - iO.pos.y) <= dim.y/2 + iO.dim.y/2)
      return true;
    else
      return false;
  }
  //updates the coinpile
  void update()
  {
    super.update();
    if (hit(mario))
    {
      if (levelState == LEVEL_BOSS && ALcharacters.size() == 0)
      {
        menu.ALmenuButton.remove(menu.ALmenuButton.size() - 1);
        gameState = MENU;
        mario.pos.x = width/2;
        menu.ALmenuButton.add(new MenuButton(width*5/6, height*6/7, 300, 125, "NG+"));
        menu.background = loadImage("GameWon.png");
        menu.background.resize(width, height);
        levelComplete = true;
        bossMusic.pause();
        sound.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
        sound.play();
      }
      effect = minim.loadFile("Music/CoinSound.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      ALinteractible.remove(this);
      mario.coins+=coins;
    }
  }
}