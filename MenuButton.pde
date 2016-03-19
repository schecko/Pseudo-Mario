//single button for menu, when constructed the type defines what actions the button does and what resources the button needs
class MenuButton extends GameObject
{
  PImage button[] = new PImage[2]; //images for a clicked and unclicked button
  int cost, iFrames; //the cost of a powerup, invincibility frames for the button
  float powerIncrement; //associated power increase which adds to marios stats
  String type; //type of button
  boolean clicked, invincible, powerUp; //if this button has been clicked then true, if the button cannot be clicked then true, if this button is associated with a powerup then true
  MenuButton(float xPos, float yPos, float dimX, float dimY, String type)
  {
    super(xPos, yPos, dimX, dimY);
    for (int i = 0; i < button.length; i++)
    {
      PImage frame = loadImage("button" + i + ".png");
      frame.resize((int)dim.x, (int)dim.y);
      button[i] = frame;
    }


    clicked = false;
    this.type = type;
    if (type == "SpeedUp")
    {
      cost = 40;
      powerUp = true;
      powerIncrement = .2;
    }
    if (type == "JumpHeight")
    {
      cost = 60;
      powerUp = true;
      powerIncrement = .5;
    } else
      if (type == "FireBuff")
    {
      cost = 150;
      powerUp = true;
    } else
      if (type == "Life")
    {
      cost = 40;
      powerUp = true;
      powerIncrement = 1;
    } else
      if (type == "GroundPound")
    {
      cost = 20;
      powerUp = true;
    }
  }
  //renders the button
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    if (!clicked)
    {
      image(button[0], 0, 0);
    } else
    {
      image(button[1], 0, 0);
    }
    textAlign(CENTER);
    if (mario.coins < cost)
    {
      fill(#3A4847);
    } else
    {
      fill(#141A15);
    }
    textSize(dim.x/10);
    text(type, 0, 0);
    if (type == "SpeedUp")
    {
      textSize(dim.x/15);
      text("Your Speed: " + mario.defaultSpeed + ", Cost: " + cost, 0, dim.x/9);
      if (levelComplete)
      {
        text("Speed Increment: " + powerIncrement * 3, 0, -dim.x/9);
      } else
      {
        text("Speed Increment: " + powerIncrement, 0, -dim.x/9);
      }
    } else if (type == "JumpHeight")
    {
      textSize(dim.x/15);
      text("Your jHeight: " + mario.jumpHeight + ", Cost: " + cost, 0, dim.x/9);
      if (levelComplete)
      {
        text("jump Increment: " + powerIncrement * 3, 0, -dim.x/9);
      } else
      {
        text("jump Increment: " + powerIncrement, 0, -dim.x/9);
      }
    } else if (type == "Life")
    {
      textSize(dim.x/15);
      text("Your lives: " + mario.lives + ", Cost: " + cost, 0, dim.x/9);
      if (levelComplete)
      {
        text("Life Addition: " + powerIncrement * 3, 0, -dim.x/9);
      } else
      {
        text("Life Addition: " + powerIncrement, 0, -dim.x/9);
      }
    } else if (type == "FireBuff")
    {
      textSize(dim.x/15);
      text("Cost: " + cost, 0, dim.x/9);
    } else if (type == "GroundPound")
    {
      textSize(dim.x/15);
      text("Cost: " + cost, 0, dim.x/9);
    }
    popMatrix();
  }
  //if the button has been clicked and mario has the resources to use the button, this is called to alter the gamestate, levelstate or marios stats
  void buttonAction()
  {
    clicked = true;
    if (type == "Start")
    {
      gameState = LOADINGSCREEN;
      levelState = LEVEL_ONE;
      menu = new Menu(true);
    } else if (type == "ResetGame")
    {
      gameState = LOADINGSCREEN;
      levelState = LEVEL_ONE;
      marioReset = true;
    } else if (type == "Continue")
    {
      if (levelComplete)
      {
        gameState = LOADINGSCREEN;
        levelComplete = false;
      } else
      {
        gameState = GAMEPLAY;
      }
    } else if (type == "ResetLevel")
    {
      gameState = LOADINGSCREEN;
    } else if (type == "NG+")
    {
      levelState = LEVEL_ONE;
      gameState = LOADINGSCREEN;
      menu.ALmenuButton.remove(this);
      menu.ALmenuButton.add(new MenuButton(width*5/6, height*6/7, 300, 125, "Continue"));
      menu.background = loadImage("MenuBackground.png");
      menu.background.resize(width, height);
    }
    if (powerUp)
    {
      if (type == "SpeedUp" && mario.coins >= cost)
      {
        if (levelComplete)
        {
          mario.defaultSpeed+=powerIncrement * 3;
          mario.coins-=cost;
        } else
        {
          mario.defaultSpeed+=powerIncrement;
          mario.coins-=cost;
        }
      } else if (type == "JumpHeight" && mario.coins >= cost)
      {
        if (levelComplete)
        {
          mario.jumpHeight+=powerIncrement* 3;
          mario.coins-=cost;
        } else
        {
          mario.jumpHeight+=powerIncrement;
          mario.coins-=cost;
        }
      } else if (type == "FireBuff" && mario.coins >= cost && !mario.fireBuff)
      {
        mario.fireBuff = true;
        mario.coins-=cost;
      } else if (type == "Life" && mario.coins >= cost)
      {
        if (levelComplete)
        {
          mario.lives+=powerIncrement* 3;
          mario.coins-=cost;
        } else
        {
          mario.lives+=powerIncrement;
          mario.coins-=cost;
        }
      } else if (type == "GroundPound" && mario.coins >= cost && !mario.groundPound)
      {
        mario.groundPound = true;
        mario.coins-=cost;
      }
    }
  }
  //checks if this button has been hit
  void hit()
  {
    if (abs(mouseX - pos.x) <= dim.x/2 && abs(mouseY - pos.y) <= dim.y/2)
    {
      buttonAction();
    }
  }
}

