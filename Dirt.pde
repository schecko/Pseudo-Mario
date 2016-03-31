//dirt for the player and all objects to stand on
class Dirt extends Foreground
{
  int texX[] = new int[100]; //array of random ints for the texture
  int texY[] = new int[100]; //array of random ints for the texture
  int texSize[] = new int[100]; //array of random ints for the texture
  Dirt(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    for (byte i = 0; i < 100; i++)
    {
      texX[i] = (int)random(-5, 5);
      texY[i] = (int)random(-5, 5);
      texSize[i] = (int)random(-2, 2);
    }
    for (float i = pos.x - dim.x/2 + 50; i < pos.x + dim.x/2 - 50; i+=random (100, dim.x/4))
    {
      if ((int) random(2) == 1)
      {
        if (pos.x > width)
        {
          ALbackground.add(new Pipe(i, pos.y, random(30, 70), random(50, 200)));
        }
        if (dim.x > width/2 && pos.x > width)
        {
          ALcharacters.add(new WalkType(i, pos.y, 100, 70, 2, "ShroomEnemy.png", 100));
        }
      } else
      {
        ALinteractible.add(new Coin(i, pos.y - 30, 50, 50));
      }
    }
  }
  //draws the dirt object, the "origin" is the top middle of the main rectangle
  void render()
  {
    rectMode(CENTER);
    pushMatrix();
    strokeWeight(12);
    stroke(#27B749);
    fill(#B99D5E);
    translate(pos.x, pos.y + dim.y/2);
    rect(0, 0, dim.x, dim.y);
    fill(#E8C67C);
    noStroke();
    int z = 0;
    for (float x1 = -dim.x/2 + 15; x1 <= dim.x/2 - 15; x1 +=15, z++)
    {
      pushMatrix();
      translate(x1, 15);
      for (float y1 = -dim.y/2; y1 <= dim.y/2 - 30; y1 += 15, z++)
      {
        if (z >= 99)
          z = 0;
        rect(texX[z], y1 + texY[z], 4 + texSize[z], 4 + texSize[z + 1]);
      }
      popMatrix();
    }
    popMatrix();
  }
}