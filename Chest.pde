//chest containing coins which are placed around the chest after being hit by the player
class Chest extends InteractibleObject
{
  PImage chest; //image for the current object
  int coins; //integer containing the number of coins this chest contains
  Chest(float xPos, float yPos, float dimX, float dimY, int coins)
  {
    super(xPos, yPos, dimX, dimY);
    chest = loadImage("Chest.png");
    chest.resize((int)dim.x, (int) dim.y);
    this.coins = coins;
  }
  //updates the object and checks if mario has hit it, if he has then the chest releases coins
  void update()
  {
    super.update();
    if (hit(mario))
    {
      ALinteractible.add(new CoinPile(pos.x, pos.y, 100, 100, coins*3/4));
      for(int i = 0; i < (int) coins/4; i++)
      {
        ALinteractible.add(new Coin(pos.x + random(-dim.x *2, dim.x *2), pos.y - 30, 50, 50));
      }
      ALinteractible.remove(this);
    }
  }
  //draws the chest
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(chest, 0, -dim.y/2);
    popMatrix();
  }
}

