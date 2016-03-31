//simple sun that oscillates back and forth in the background
class Sun extends GameObject
{
  float angle;
  float radius;
  int timer;
  int increment;
  Sun(float xPos, float yPos)
  {
    super(xPos, yPos, 0, 0);
    angle = -PI/4;
    radius = height;
    timer = 0;
    increment = 1;
  }

  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(map(mouseX, 0, width, .4, .6));
    fill(#FCCF17);
    ellipse(radius * cos(angle), radius * sin(angle), width/3, width/3);
    popMatrix();
  }
  void update()
  {
     angle+=.002*increment;
     if(angle < -PI || angle > 0)
     {
       increment*=-1;
     }
    
  }
}