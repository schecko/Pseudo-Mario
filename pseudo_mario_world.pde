import ddf.minim.*;
import controlP5.*;
ControlP5 cp5;
Minim minim;

AudioPlayer sound; //music object for the background
AudioPlayer effect; //music object for game effects 
AudioPlayer bossMusic; //background music for the boss fight

final int WON = 1; //constant that will be used for the gamestate.
final int GAMEPLAY = 2; //constant that will be used for the gamestate
final int LOADINGSCREEN = 3; //constant that will be used for the gamestate
final int MENU = 4; //constant that will be used for the gamestate


final int LEVEL_NULL = 0; //constant that will be used for the levelstate
final int LEVEL_ONE = 1; //constant that will be used for the levelstate
final int LEVEL_TWO = 2; //constant that will be used for the levelstate
final int LEVEL_THREE = 3; //constant that will be used for the levelstate
final int LEVEL_BOSS = 4; //constant that will be used for the levelstate

int gameState = MENU; //integer holding the current state of the game
int levelState = LEVEL_NULL; //integer holding the current level the player is at
PVector gSpeed = new PVector(0, 0); //all objects move relative to this speed vector, except for the final boss level.
boolean left, right, down, space; //are true if the associated key is being pressed, resulting in character movement
PFont font; //for the global game text font
ArrayList ALbackground = new ArrayList(), ALforeground = new ArrayList(), ALcharacters = new ArrayList(), ALinteractible = new ArrayList(); //seperate arraylists hold the background, foreground, character and interactible  objects respectively
Mario mario; //player object mario
boolean died; //if mario dies, set to true (for the loading screen)
PImage loadingScreen; //an image for the loading screen.
int count = 0; //delay to allow the loading screen to render before the game resets
boolean marioReset; //if mario dies and has no lives left, the game is reset completely based on this boolean
boolean levelComplete = false; //boolean for the gamemenu, which is set to true if a menu resulted from a level completion
PVector deathSpot = new PVector(); //contains the original spawn location of the foreground that mario last died at
int deathCount; //counts the number of player deaths in lvl 2
Menu menu; //menu object


//initializes the game by instantiating objects required for level one
void setup()
{
  minim = new Minim(this);
  cp5 = new ControlP5(this);

  frameRate(30);
  font = loadFont("FootlightMTLight-30.vlw");
  textFont(font);
  size(1500, 900);
  menu = new Menu(false);
  setLevelOne();
  mario = new Mario(width/2, height/2, 50, 70, 3, 10);
  loadingScreen = loadImage("LoadingScreen.png");
  loadingScreen.resize(width, height);
  sound = minim.loadFile("Music/BackgroundMusic.mp3");
  bossMusic = minim.loadFile("Music/BossMusic.mp3");
  sound.play();

  cp5.addSlider("Volume")
    .setPosition(25, 650)
      .setSize(40, 200)
        .setRange(0, 100)
          .setValue(50)
            .setSliderMode(Slider.FLEXIBLE);
}
//resets the game by deleting all active objects of the game
//only resets mario if the boolean resetMario is true
void resetGame(boolean resetMario)
{
  if (resetMario)
  {
    mario = new Mario(width/2, height/2, 50, 70, 3, 10);
    marioReset = false;
  }
  for (int i = ALbackground.size () - 1; i >= 0; i--)
  {
    ALbackground.remove(i);
  }
  for (int i = ALforeground.size () - 1; i >= 0; i--)
  {
    ALforeground.remove(i);
  }
  for (int i = ALinteractible.size () - 1; i >= 0; i--)
  {
    ALinteractible.remove(i);
  }
  for (int i = ALcharacters.size () - 1; i >= 0; i--)
  {
    ALcharacters.remove(i);
  }
}
//adds gameplay elements for levelone, if mario previously died, his coins are placed at his point of death.
void setLevelOne()
{
  if (died)
  {
    ALinteractible.add(new CoinPile(deathSpot.x, deathSpot.y, 100, 100, mario.coins));
    mario.coins = 0;
  }
  deathSpot = new PVector();
  ALbackground.add(new Sun(width/2, height));
  for (int i = -5; i < 30; i++)
  {
    ALbackground.add(new Cloud(300*i+random(-400, 400), random(height/2)));
    ALbackground.add(new Pillar(300*i+random(-400, 400), random(100, 200), random(height/2, height*7/8)));
  }
  ALforeground.add(new Portal(width/2, height/3, width/5, height/5, false));
  ALforeground.add(new Portal(12700, height*5/6, width/5, height/5, true));

  //main ground
  ALforeground.add(new Dirt(width/2, height* 5/6, width*3, height/3));
  ALforeground.add(new Dirt(width * 3.7, height* 5/6, width*3, height/3));
  ALforeground.add(new Dirt(width * 6.9, height* 5/6, width*3, height/3));

  ALforeground.add(new Dirt(width, height*2/3, width/2, height/3));
  ALforeground.add(new Dirt(0, height*2/3, width/2, height/3));

  ALbackground.add(new SignPost(width*2/3, height*5/6, 200, 200, "Welcome to\nPseudo Mario World,\n use AD keys to move"));
  ALbackground.add(new SignPost(width/5, height*2/3, 200, 200, "Jump on a\nmonster to kill it."));
  ALbackground.add(new SignPost(width, height*2/3, 200, 200, "Use W or\nSpace to jump"));
  ALbackground.add(new SignPost(width*1.5, height*5/6, 200, 200, "If you die,\nyour coins are left\nbehind and the\nlevel is reset."));
  ALbackground.add(new SignPost(width*2.4, height*5/6, 200, 200, "Reach the other\nportal to\ncomplete the\n level."));
  ALbackground.add(new SignPost(-width + 30, height*5/6, 200, 200, "Treasure?"));
}
//adds gameplay elements for leveltwo, if mario previously died, his coins are placed at his point of death.
void setLevelTwo()
{
  if (died)
  {
    deathCount++;
    ALinteractible.add(new CoinPile(deathSpot.x, deathSpot.y, 100, 100, mario.coins));
    mario.coins = 0;
  }
  ALbackground.add(new Sun(width/2, height));
  for (int i = -10; i < 40; i++)
  {
    ALbackground.add(new Pillar(300*i+random(-400, 400), random(100, 200), random(height/2, height*7/8)));
  }
  for (float i = 9.5; i < 11; i+=.5)
  {
    ALcharacters.add(new GhostType(width*i, random(height), 70, 3, "Boo.png", 100));
  }
  ALforeground.add(new Portal(width/2, height/3, width/5, height/5, false));
  ALforeground.add(new Portal(17400, height/8, width/5, height/5, true));

  //above
  ALinteractible.add(new SpringTrap(width * 7 + width/11, -width*5/6 + 40, 100, 40, 2, true));
  ALforeground.add(new Dirt(width * 7, -width*5/6, width/5, height/6));
  ALforeground.add(new Dirt(width * 7, -width*2/3, width/5, height/6));
  ALforeground.add(new Dirt(width * 7, -width/2, width/5, height/6));
  ALforeground.add(new Dirt(width * 7, -width/3, width/5, height/6));
  ALforeground.add(new Dirt(width * 6.6, -width/3, width/11, height/6));
  ALforeground.add(new Dirt(width * 6.3, -width/3, width/11, height/6));
  ALforeground.add(new Dirt(width * 6.3, -width/3, width/11, height/6));
  ALforeground.add(new Dirt(width * 6, -width/3, width/11, height/6));
  ALforeground.add(new Dirt(width * 5.7, -width/3, width/11, height/6));
  ALforeground.add(new Dirt(width * 5.4, -width/3, width/11, height/6));
  if (deathCount >= 2)
  {
    ALbackground.add(new SignPost(width*4.7, -width/3, 200, 200, "Try using\nGroundPound to\ncontrol speed."));
  }

  ALforeground.add(new Dirt(width * 4.7, -width/3, width, height/6));
  ALforeground.add(new Dirt(width * 3.8, -width/6, width/2, height/6));
  ALforeground.add(new Dirt(width * 3.1, 0, width/2, height/6));
  ALforeground.add(new Dirt(width * 2.3, height/6, width/2, height/6));
  ALforeground.add(new Dirt(width* 1.7, height/3, width/2, height/6));
  ALforeground.add(new Dirt(width, height/2, width/2, height/6));


  //underneath treasure
  ALforeground.add(new Dirt(width * 2, height*1.5, width/2, height/6));
  ALforeground.add(new Dirt(width * 1.3, height*1.5, width/3.3, height/6));
  ALforeground.add(new Dirt(width * .75, height*1.5, width/3.6, height/6));
  ALinteractible.add(new Chest(width * .75, height*1.5, 100, 100, (int) random(20, 40)));

  ALforeground.add(new Dirt(width * .2, height*1.5, width/4.5, height/6));
  ALinteractible.add(new SpringTrap(width * .2, height*1.5, 100, 20, 2, false));
  //


  //main ground level
  ALforeground.add(new Dirt(width/2, height - height/6, width*3, height/3));
  ALbackground.add(new SignPost(width*2 - 40, height*5/6, 200, 200, "Try a small leap\nof faith."));
  //ALforeground.add(new Dirt(width * 6.9, height - height/6, width*3, height/3));
  // ALinteractible.add(new SpringTrap(12400, height - height/6, 100, 20, 2, false));

  //mainground level raised
  ALforeground.add(new Dirt(width * 10.1, height/8, width*3, height/3));
}
//adds gameplay elements for levelthree, if mario previously died, his coins are placed at his point of death.
void setLevelThree()
{
  if (died)
  {
    ALinteractible.add(new CoinPile(deathSpot.x, deathSpot.y, 100, 100, mario.coins));
    mario.coins = 0;
  }
  for (int i = -10; i < 40; i++)
  {

    ALbackground.add(new Pillar(300*i+random(-400, 400), random(100, 200), random(height/2, height*7/8)));
  }
  for (int i = 3; i > -9; i-=3)
  {
    ALcharacters.add(new GhostType(random(width), height * i, 70, 3, "Boo.png", 100));
  }

  ALforeground.add(new Portal(width/2, height/3, width/5, height/5, false));
  ALforeground.add(new Portal(width + 30, -height*10, width/5, height/5, true));

  //main
  ALforeground.add(new Dirt(width/2, height*5/6, width, height/3));

  for (float i = .75; i > -10; i-=.25)
  {
    ALforeground.add(new Dirt(width * sin(i) + random(-width/10, width/10), height*i, width/6, height/7));
  }
  ALforeground.add(new Dirt(width/2, -height*10, width, height/6));
}
//adds gameplay elements for the boss level, if mario previously died, his coins are placed at his point of death.
void setLevelBoss()
{
  if (died)
  {
    ALinteractible.add(new CoinPile(deathSpot.x, deathSpot.y, 100, 100, mario.coins));
    mario.coins = 0;
  }
  for (int i = -2; i < 2; i++)
  {
    ALbackground.add(new Pillar(300*i+random(-400, 400), random(100, 200), random(height/2, height*7/8)));
  }
  ALcharacters.add(new PseudoMario(width*2/3, height/2, 50, 70, 5, 100));
  mario.pos = new PVector(width/3, height/2);
  ALforeground.add(new Portal(width*2/3, height/3, width/5, height/5, false));
  ALforeground.add(new Portal(width/3, height/3, width/5, height/5, false));

  for (float z = 1; z > -1.5; z-=.5)
  {
    ALforeground.add(new Dirt(width/2, height*z, width/2, height/15));
    ALforeground.add(new Dirt(width, height*z - height/4, width/2, height/15));
    ALforeground.add(new Dirt(0, height*z - height/4, width/2, height/15));
  }

  ALinteractible.add(new SpikeTrap(100, height*3/4, 100, 100, 1));
  ALinteractible.add(new SpikeTrap(width - 100, height*3/4, 100, 100, 0));

  sound.pause();
  bossMusic.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
  bossMusic.play();
}
//infinite loop which switches through the gamestate, and draws the correct ui and level according to the gamestate and levelstate
void draw()
{

  sound.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
  effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
  switch(gameState)
  {
  case MENU:
    {
      menu.render();
      cp5.show();
    }
    break;
  case LOADINGSCREEN:
    {
      fill(255);
      count++;
      image(loadingScreen, width/2, height/2);
      textAlign(CENTER);
      textSize(40);
      text("Loading...", width*7/8, height*7/8);
      if (died)
      {
        text("You Died", width*7/8, height*7.5/8);
      }
      if (count > 10) //for some reason, without this delay the loading screen isnt rendered and the game freezes untill its finished initializing everything, with this it still freezes, but with a background
      {
        mario.currFG = null;
        resetGame(marioReset);
        switch(levelState)
        {
        case LEVEL_ONE:
          setLevelOne();
          break;
        case LEVEL_TWO:
          setLevelTwo();
          break;
        case LEVEL_THREE:
          setLevelThree();
          break;
        case LEVEL_BOSS:
          setLevelBoss();
          break;
        }
        gameState = GAMEPLAY;
        count = 0;
        died = false;
        loadingScreen = loadImage("LoadingScreen.png");
        loadingScreen.resize(width, height);
      }
      mario.speed = new PVector(0, 0);
      gSpeed = new PVector(0, 0);
      cp5.hide();
    }
    break;
  case WON:
    {
    }
    break;
  case GAMEPLAY:
    {
      cp5.hide();
      gameplay();
    }
  }
  if(frameRate % 2 == 0)
  saveFrame();
}
//handles all gameplay elements such as running through each arraylist to update and draw each object
void gameplay()
{
  background(#3C4BDE);
  for (int i = 0; i < ALbackground.size (); i++)
  {
    GameObject currBG = (GameObject) ALbackground.get(i);
    currBG.update();
    if (currBG.pos.x - currBG.dim.x/2 < width + 300 && currBG.pos.x + currBG.dim.x/2 > -300) //only renders objects that are in the window's view
    {
      currBG.render();
    }
  }

  for (int i = ALforeground.size () - 1; i >=0; i--)
  {
    Foreground currFG = (Foreground) ALforeground.get(i);
    currFG.update();
    if (currFG.pos.x - currFG.dim.x/2 < width && currFG.pos.x + currFG.dim.x/2 > 0) //only renders objects that are in the window's view
    {
      currFG.render();
    }

    for (int i2 = ALcharacters.size () -1; i2 >= 0; i2--)
    {
      CharacterObject currChar = (CharacterObject) ALcharacters.get(i2);
      if (currFG.check(currChar) && currChar.currFG == null && currChar.speed.y > 0) //ensures that mario is falling down and near the top of a block
      {
        currChar.land(currFG);
      }
    }
    if (currFG.check(mario) && mario.currFG == null && mario.speed.y > 0) //ensures that mario is falling down and near the top of a block
    {
      mario.land(currFG);
    }
    if (levelState == LEVEL_BOSS && currFG.pos.y > width * 1.2)
    {
      currFG.pos.y -= width *1.5;
    }
  }
  mario.render();
  mario.update();
  for (int i = ALinteractible.size () -1; i >= 0; i--)
  {
    InteractibleObject currInter = (InteractibleObject) ALinteractible.get(i);
    currInter.update();
    if (currInter.pos.x - currInter.dim.x/2 < width && currInter.pos.x + currInter.dim.x/2 > 0) //only renders objects that are in the window's view
    {
      currInter.render();
    }
    if (levelState == LEVEL_BOSS && currInter.pos.y > width * 1.2)
    {
      currInter.pos.y -= width *1.5;
    }
  }

  for (int i = ALcharacters.size () -1; i >= 0; i--)
  {
    CharacterObject currChar = (CharacterObject) ALcharacters.get(i);
    currChar.update();
    if (mario.hit(currChar) && !mario.invincible && !currChar.invincible)
    {
      if (mario.pos.y <= currChar.pos.y - currChar.dim.y/2)
      {
        if (down && mario.groundPound)
        {
          mario.hitCombo++;
          mario.jump(mario.jumpHeight * 2);
          mario.jumping = true;
          currChar.hitSuccess(2);
        } else
        {
          mario.hitCombo++;
          mario.jump(mario.jumpHeight);
          mario.jumping = true;
          currChar.hitSuccess(1);
        }
      } else
      {
        mario.hitSuccess(1);
      }
    }
    if (currChar.pos.x - currChar.dim.x/2 < width && currChar.pos.x + currChar.dim.x/2 > 0) //only renders objects that are in the window's view
    {
      currChar.render();
    }
  }
}
//////////////////////////
//if a certain key is pressed, the associated boolean becomes true, flagging mario to move
void keyPressed()
{
  if (key == 'a' || key == 'A')
  {
    left = true;
  }
  if (key == 'd' || key == 'D')
  {
    right = true;
  }
  if (key == 's' || key == 'S')
  {
    down = true;
  }
  if (key == ' ' || key == 'w' || key == 'W')
  {
    space = true;
  }
  if (key == 'f' && mario.fireBuff)
  {
    mario.shoot = true;
  }
  if (key == CODED)
  {
    if (keyCode == CONTROL)
    {
      gameState = MENU;
    }
        if (keyCode == ALT)
    {
      saveFrame();
    }
  }
}
//if a key is released, the associated boolean is set to false and mario slows down accordingly
void keyReleased()
{
  if (key == 'a')
  {
    left = false;
  }
  if (key == 'd')
  {
    right = false;
  }
  if (key == 's')
  {
    down = false;
  }
  if (key == ' '|| key == 'w' || key == 'W')
  {
    space = false;
  }
  if (key == 'f')
  {
    mario.shoot = false;
  }
}
//used only in the game menu for the player to select items and powerups to buy
void mousePressed()
{
  if (gameState == MENU)
  {
    menu.update();
  }
}
//only used for visuals, if a key is pressed its color changes and this simply resets that if the mouse is released
void mouseReleased()
{
  if (gameState == MENU)
  {
    for (int i = 0; i < menu.ALmenuButton.size (); i++)
    {
      MenuButton button = (MenuButton) menu.ALmenuButton.get(i);
      button.clicked = false;
    }
  }
}
//turns off the sound objects when the program quits
void stop()
{
  sound.close();
  effect.close();
  minim.stop();
  super.stop();
}