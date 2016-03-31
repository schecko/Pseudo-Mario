//object for the player and start menu which contains interactible buttons for the player also serves as a pause screen
class Menu
{
  PImage background, logo; //image for the menu's background, image for the menus logo "Pseudo Mario World"
  ArrayList ALmenuButton = new ArrayList(); //arraylist of buttons
  Coin coin; //ui visual for current coins
  boolean playerMenu; //false if the game just started, otherwise true
  Menu(boolean playerMenu)
  {
    this.playerMenu = playerMenu;
    if (playerMenu)
    {
      coin = new Coin(width/2, 105, 40, 40);
      ALmenuButton.add(new MenuButton(width/2, height*6/7, 300, 125, "SpeedUp"));
      ALmenuButton.add(new MenuButton(width/2, height*5/7, 300, 125, "JumpHeight"));
      ALmenuButton.add(new MenuButton(width/2, height*4/7, 300, 125, "Life"));
      ALmenuButton.add(new MenuButton(width/2, height*3/7, 300, 125, "FireBuff"));
      ALmenuButton.add(new MenuButton(width/2, height*2/7, 300, 125, "GroundPound"));
      ALmenuButton.add(new MenuButton(width/6, height*4/7, 300, 125, "ResetGame"));
      ALmenuButton.add(new MenuButton(width/6, height*6/7, 300, 125, "ResetLevel"));
      ALmenuButton.add(new MenuButton(width*5/6, height*6/7, 300, 125, "Continue"));
    } else
    {
      ALmenuButton.add(new MenuButton(width*5/6, height*6/7, 300, 125, "Start"));
      effect = minim.loadFile("Music/Hello.wav");
      effect.play();
    }

    background = loadImage("MenuBackground.png");
    background.resize(width, height);
    logo = loadImage("Logo.png");
    logo.resize(700, 250);
  }
  //checks to see if a button has been pressed, and is only called when the mouse is pressed
  void update()
  {
    for (int i = 0; i < ALmenuButton.size (); i++)
    {      
      if ((levelState == LEVEL_NULL && i == 0) || levelState != LEVEL_NULL)
      {
        MenuButton currButton = (MenuButton) ALmenuButton.get(i);
        currButton.hit();
      }
    }
  }
  //renders all the buttons and images 
  void render()
  {

    if (frameCount % 500 == 0 && !playerMenu)
    {
      effect = minim.loadFile("Music/PressStart.wav");
      effect.play();
    }
    image(background, width/2, height/2); 
    //background(0);
    textAlign(CENTER); 
    for (int i = 0; i < ALmenuButton.size (); i++)
    {
      if ((levelState == LEVEL_NULL && i == 0) || levelState != LEVEL_NULL)
      {
        MenuButton currButton = (MenuButton) ALmenuButton.get(i);
        currButton.render();
      }
    }
    if (levelState == LEVEL_NULL)
    {
      pushMatrix();
      textAlign(CENTER);
      textSize(50);
      fill(0);
      translate(width/2, 130);
      image(logo, 0, 0);
      textSize(20);
      text("By Scott Checko\n\nGame Info:\nWASD keys to move, Space to jump, Ctrl will pause the game.\n\nDisclaimer: I do not own any pictures used in this game,\nall rights go to the original artists,\nsome pictures may have been modified to suite the needs of the game.\nMario is a registered trademark of Nintendo\nand is being used for education purposes only.", 0, 220);
      popMatrix();
    } else
    {
      textAlign(LEFT);
      fill(0);
      textSize(30);
      coin.render();
      coin.updateFrames();
      text(mario.coins, width/2 + 30, 95);
      textSize(20);

      text("tip: Spend coins wisely, the\nshop at the end of each level is\n3x better than the pause screen.", width-300, 50);
      if (mario.groundPound)
      {
        text("tip: If mario performs a successful\ngroundPound on an enemy, he can\npotentially jump 4x higher than\nnormal if the down button isn't held.", 50, 50);
      }
      if (mario.fireBuff)
      {
        text("tip: use F to\nshoot a ball of\nflame at your\nopponents.", 50, 200);
      }
    }
  }
} //class