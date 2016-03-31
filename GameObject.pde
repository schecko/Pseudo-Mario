 //most basic object of the game, contains the most primitive game elements such as the objects speed and dimensions
class GameObject
{
  PVector pos, speed, dim; // object position, speed, and dimension
  int currFrame, animRate;  //objects current frame for animation, and the rate of animation
  float sca, rot; //the objects sca and rotation 
  GameObject(float xPos, float yPos, float dimX, float dimY)
  {
    pos = new PVector(xPos, yPos);
    speed = null;
    dim = new PVector(dimX, dimY);
    currFrame = 0;
    animRate = 4;
  }

  //updates speed and accelleration
  void update()
  {
    pos.add(gSpeed);
  }
  void render()
  {
    //placeholder
  }
}