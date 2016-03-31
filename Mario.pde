//player mario class
class Mario extends CharacterObject
{
  int lives; //number of mario lives before game over
  int randomSounds; //timer for the random mario noises
  PImage sImage, ffImage, fcImage, fsImage, ftImage, gpImage; //side image, front face image, fire character "front" image, fire side image, fire throw image, groundpound image
  int hitCombo, coins; //counts the number of times mario has jumped on monsters, number of coins mario currently is carrying
  float jumpHeight; //called height but actually represents the speed of jumping
  float displacement = 0; //temporary, for debugging and item placement
  Coin coin; //a coin visual for the UI
  boolean fireBuff; //true if mario has the firebuff buff
  boolean groundPound; //true if mario is able to perform a groundpound
  boolean shoot; //true if mario has shot his fire
  boolean inputEnabled; //true if player is able to control mario
  int inputTimer; //times duration input is disabled
  int shootDelay; //times the cooldown of marios ability to shoot fire
  Foreground prevFG; //contains the previous foreground mario was on, used for death



  Mario(float xPos, float yPos, float dimX, float dimY, int health, int lives)
  {
    super(xPos, yPos, dimX, dimY, health, "Mario/MarioFront.png");
    sImage = loadImage("/Mario/MarioSide.png");
    ffImage = loadImage("/Mario/MarioHeadFront.png");
    gpImage = loadImage("/Mario/MarioPound.png");

    //fire mario pics
    fcImage = loadImage("/Mario/FireMarioFront.png");
    fsImage = loadImage("/Mario/FireMarioSide.png");
    ftImage = loadImage("/Mario/FireMarioToss.png");

    sImage.resize((int) dim.x, (int) dim.y);
    fcImage.resize((int) dim.x, (int) dim.y);
    fsImage.resize((int) dim.x, (int) dim.y);
    ftImage.resize((int) dim.x, (int) dim.y);
    gpImage.resize((int) (dim.x/1.3), (int) (dim.y/1.3));

    ffImage.resize((int)width/40, (int) height/40);
    coin = new Coin(50, 105, 30, 30);
    jumpHeight = 25;
    hitCombo = 0;
    coins = 0;
    fireBuff = false;
    shoot = false;
    groundPound = false;
    inputEnabled = true;
    inputTimer = 60;
    this.lives = lives;
    defaultSpeed = 10;
    prevFG = null;
    randomSounds = (int) random(1000, 5000);
  }
  //sets marios current foreground, and makes sure he doesnt fall off
  void land(Foreground fG)
  {
    currFG = fG;
    hitCombo = 0;
    pos.y = fG.pos.y;
    jumping = false;
    if (levelState != LEVEL_BOSS)
    {
      speed.y = gSpeed.y;
    }
  }
  //updates mario, handles the camera, invincibilty, death, updates the current foreground mario is on, and plays random sounds
  void update()
  {
    if (inputEnabled)
    {
      playerInput();
    } else
    {
      inputTimer--;
    }
    if (inputTimer <= 0)
    {
      inputEnabled = true;
      inputTimer = 60;
    }
    pos.add(speed);
    if (frameCount % 5 == 0) 
    {
      if (pos.y < height*2/5)
      {
        gSpeed.add(new PVector(0, defaultSpeed/2));
      } else if (pos.y > height*4/5)
      {
        gSpeed.add(new PVector(0, -defaultSpeed/2));
      }
    }
    //displacement += gSpeed.x;
    //println(displacement);
    gSpeed.y*=.9;
    if (levelState == LEVEL_BOSS)
    {
      speed.x*=.9;
      if (pos.x > width)
      {
        pos.x = 0;
      } else if (pos.x < 0)
      {
        pos.x = width;
      }
    }
    if (invincible)
    {
      iFrames--;
    }
    if (invincible && iFrames <= 0)
    {
      invincible = false;
    }
    if (currFG != null)
    {
      if (levelState != LEVEL_BOSS)
      {
        gSpeed.x*=.95;
      }
      if (!currFG.check(this))
      {
        prevFG = currFG;
        currFG = null;
      } else
      {
        pos.y = currFG.pos.y;
        speed.y = 0;
      }
    } else if (currFG == null)
    {
      if (speed.y < 20)
      {
        speed.add(new PVector(0, 1.5)); //gravity
      }
      if (pos.y > height * 5)
      {
        pos.y = height/2;
        speed.y = 0;
        gSpeed.y = 0;
        lives--;
        health = HEALTH;
        if (mario.lives <= 0)
        {
          loadingScreen = loadImage("GameOver.png");
          loadingScreen.resize(width, height);
          gameState = LOADINGSCREEN;
          levelState = LEVEL_ONE;
          marioReset = true;
          effect = minim.loadFile("Music/GameOver.wav");
          effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
          effect.play();
        } else
        {
          died = true;
          if (currFG != null)
          {
            deathSpot = currFG.origSpot;
          } else if (prevFG != null)
          {
            deathSpot = prevFG.origSpot;
          }
          gameState = LOADINGSCREEN;
        }
      }
    }
    if (shootDelay >= 0)
    {
      shootDelay--;
    } else if (shoot)
    {
      shoot = false;
    }
    if (frameCount % randomSounds == 0)
    {
      effect = minim.loadFile("Music/Shocked0.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
    } else if (frameCount % randomSounds == randomSounds/2)
    {
      effect = minim.loadFile("Music/Shocked1.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
    }
  }
  //renders mario, or firemario if firebuff is true
  void render()
  {
    if (!invincible || ( invincible && iFrames % 2 == 0))
    {
      pushMatrix();
      translate(pos.x, pos.y);
      imageMode(CENTER);
      if (levelState != LEVEL_BOSS)
      {
        if (groundPound && down)
        {        
          if (gSpeed.x > 0)
          {
            scale(-1, 1);
          } else if (gSpeed.x < 0)
          {
            scale(1, 1);
          }
          image(gpImage, 0, -dim.y/2);
        } else if ((int) round(gSpeed.x) == 0)
        {
          if (fireBuff)
          {
            image(fcImage, 0, -dim.y/2);
          } else
          {
            image(cImage, 0, -dim.y/2);
          }
        } else
        {
          if (gSpeed.x > 0)
          {
            scale(-1, 1);
          } else if (gSpeed.x < 0)
          {
            scale(1, 1);
          }
          if (fireBuff)
          {
            image(fsImage, 0, -dim.y/2);
          } else
          {
            image(sImage, 0, -dim.y/2);
          }
        }
        popMatrix();
      } else
      {
        if (groundPound && down)
        {        
          if (speed.x < 0)
          {
            scale(-1, 1);
          } else if (speed.x > 0)
          {
            scale(1, 1);
          }
          image(gpImage, 0, -dim.y/2);
        } else if ((int) round(speed.x) == 0)
        {
          if (fireBuff)
          {
            image(fcImage, 0, -dim.y/2);
          } else
          {
            image(cImage, 0, -dim.y/2);
          }
        } else
        {
          if (speed.x < 0)
          {
            scale(-1, 1);
          } else if (speed.x > 0)
          {
            scale(1, 1);
          }
          if (fireBuff)
          {
            image(fsImage, 0, -dim.y/2);
          } else
          {
            image(sImage, 0, -dim.y/2);
          }
        }
        popMatrix();
      }
    }

    uI();
  }
  //launches mario sideways
  void sideLaunch()
  {
    if (levelState != LEVEL_BOSS)
    {
      gSpeed = new PVector(-defaultSpeed * 5, 0);
      inputEnabled = false;
    } else
    {
      speed = new PVector(-defaultSpeed * 5, 0);
      inputEnabled = false;
    }
  }
  //moves the world relative to the window/mario, and moves mario only when moving up or down
  void playerInput()
  {
    if (levelState != LEVEL_BOSS)
    {
      if (groundPound && down && speed.y < defaultSpeed *2)
      {
        speed.add(new PVector(0, defaultSpeed));
        gSpeed.x = 0;
        if (currFG == null)
        {
          effect = minim.loadFile("Music/GroundPound.wav");
          effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
          effect.play();
        }
      }
      if (left && gSpeed.x < defaultSpeed && !down)
      {
        gSpeed.add(new PVector(defaultSpeed, 0));
      }
      if (right && gSpeed.x > -defaultSpeed && !down)
      {
        gSpeed.add(new PVector(-defaultSpeed, 0));
      }
    } else
    {
      if (groundPound && down && speed.y < defaultSpeed *2)
      {
        speed.add(new PVector(0, defaultSpeed));
        if (currFG == null)
        {
          effect = minim.loadFile("Music/GroundPound.wav");
          effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
          effect.play();
        }
      }
      if (left && speed.x > -defaultSpeed && !down)
      {
        speed.add(new PVector(-defaultSpeed, 0));
      }
      if (right && speed.x < defaultSpeed && !down)
      {
        speed.add(new PVector(defaultSpeed, 0));
      }
    }
    if (space && !jumping && !down)
    {
      effect = minim.loadFile("Music/Jump.wav");
      effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
      effect.play();
      jump(jumpHeight);
    }
    if (shoot && fireBuff && shootDelay <= 0)
    {
      ALinteractible.add(new FireBall(pos.x, pos.y - dim.y/2, 50, 50));
      shootDelay = (int) frameRate;
    }
  }
  //renders the coin counter at the top of the screen
  void coins()
  {
    textAlign(LEFT);
    fill(0);
    textSize(20);
    coin.render();
    coin.updateFrames();
    text(coins, 70, 100);
  }
  //calls all of the UI elements
  void uI()
  {
    healthbar();
    if (hitCombo >=2)
    {
      textAlign(CENTER);
      fill(255);
      textSize(40);
      text("COMBO " + hitCombo, width/2, height/3);
    }
    lives();
    coins();
  }
  //UI visuals for marios remaining lives
  void lives()
  {
    pushMatrix();
    translate(30, 40);
    textSize(20);
    fill(#14F52C);
    text("lives:", 0, 0);
    translate(20, 20);
    for (int i = lives -1; i >= 0; i--)
    {
      image(ffImage, i * ffImage.width, 0);
    }
    popMatrix();
  }
  //handles marios life and deaths, and plays sound when hes hit
  void hitSuccess(int h)
  {
    super.hitSuccess(h);
    effect = minim.loadFile("Music/MarioHit.wav");
    effect.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
    effect.play();
    ;
    if (health <= 0)
    {
      lives--;
      health = HEALTH;
      if (mario.lives <= 0)
      {
        if (levelState == LEVEL_BOSS)
        {
          bossMusic.pause();
          sound.setGain(map(cp5.getValue("Volume"), 0, 100, -83, 200));
          sound.play();
        }
        loadingScreen = loadImage("GameOver.png");
        loadingScreen.resize(width, height);
        gameState = LOADINGSCREEN;
        levelState = LEVEL_ONE;
        marioReset = true;
      } else
      {
        died = true;
        if (currFG != null)
        {
          deathSpot = currFG.origSpot;
        } else if (prevFG != null)
        {
          deathSpot = prevFG.origSpot;
        }
        gameState = LOADINGSCREEN;
      }
    }
  }
  //shoots mario up
  void jump(float jSpeed)
  {
    speed = new PVector(0, -jSpeed);
    jumping = true;
    prevFG = currFG;
    currFG = null;
  }
  //renders marios healthbar
  void healthbar()
  {
    pushMatrix();
    rectMode(CENTER);
    translate(width/2, height - 25);
    noStroke();
    fill(#FF5050);
    rect(0, 0, HEALTH * 150, 15);
    fill(#17FF4F);
    rect(0, 0, (float) health * 150, 20);
    popMatrix();
  }
}