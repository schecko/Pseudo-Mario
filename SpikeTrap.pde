//spike trap, which can hit any character
class SpikeTrap extends InteractibleObject
{
  PImage spikeTrap[] = new PImage[5]; //image for the spiketrap
  int trapTimer; //timer for the spikes to move up
  int increment; //increment for moving the spikes up or down
  SpikeTrap(float xPos, float yPos, float dimX, float dimY, int startFrame)
  {
    super(xPos, yPos, dimX, dimY);
    for (int i = 0; i < spikeTrap.length; i++)
    {
      PImage frame = loadImage("SpikeTrap/SpikeTrap" + i + ".png");
      frame.resize((int)dim.x, (int)dim.y);
      spikeTrap[i] = frame;
    }
    currFrame = startFrame;
    animRate = 5;
    trapTimer = (int) frameRate * 2;
    increment = 1;
  }
  //changes the current frame of the spikes
  void updateFrames()
  {
    if (currFrame > 0 && frameCount % animRate == 0)
    {
      currFrame+=increment;
    }
    if (currFrame == 0)
    {
      trapTimer--;
      if (trapTimer <= 0)
      {
        increment = 1;
        currFrame+=increment;
        trapTimer = (int) frameRate * 2;
        effect= minim.loadFile("Music/MetalClank.wav");
        effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
        effect.play();
      }
    }
    if (currFrame >= spikeTrap.length -1)
    {
      increment = -1;
    }
  }
  //renders the spikes
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(spikeTrap[currFrame], 0, -dim.y/2);
    popMatrix();
  }
  //updates the spikes
  void update()
  {
    super.update();
    updateFrames();
    if (hit(mario) && currFrame > 0 && !mario.invincible)
    {
      mario.hitSuccess(1);
    }
    for (int i = 0; i < ALcharacters.size (); i++)
    {
      CharacterObject currChar = (CharacterObject) ALcharacters.get(i);
      if (hit(currChar) && currFrame > 0 && !currChar.invincible)
      {
        currChar.hitSuccess(1);
      }
    }
  }
}

