//background cloud object for style
class Cloud extends GameObject
{
  PVector relSpeed; //relative speed to mario, gives a feel of game depth
  Cloud(float xPos, float yPos)
  {
    super(xPos, yPos, 0, 0);
    speed = new PVector(random(-1, -.3), 0);
  }
  Cloud()
  {
    super(random(height/3), random(-width/2, width), 0, 0);
  }
  //renders clouds
  void render()
  {
    rectMode(CORNER);
    pushMatrix();
    translate(pos.x, pos.y);
    fill(#FFFFFF);
    noStroke();

    arc(height/5 - 1, width/40, height/9, width/20, -PI/2, PI/2);
    arc(1, width/40, height/9, width/20, PI/2, PI*3/2);
    rect(0, 0, height/5, width/20);
    //shadows
    fill(0, 0, 0, 30);
    arc(height/5, width/40, height/9, width/20, 0, PI/2);
    arc(0, width/40, height/9, width/20, PI/2, PI);
    rect(0, width/40, height/5, width/40);
    popMatrix();
  }
  //updates the clouds
  void update()
  {
    relSpeed = new PVector(gSpeed.x, gSpeed.y);
    relSpeed.mult(.5);
    pos.add(relSpeed);
    pos.add(speed);
    if(pos.x < -width * 2)
    {
      pos.x = width *2;
    }
  }
}

