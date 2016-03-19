//background element for style
class Pillar extends GameObject
{
  float dotx[] = new float[4], doty[] = new float[4]; //arrays containing the textures for this pillar
  Pillar()
  {
    super(random(width), 0, random(100, 300), random(height*4/5));
    for (byte i = 0; i < 4; i++)
    {
      dotx[i] = random(-50, 30);
      doty[i] = random(-150, 150);
    }
  }
  Pillar(float xPos, float dimX, float dimY)
  {
    super(xPos, 0, dimX, dimY);
    for (byte i = 0; i < 4; i++)
    {
      dotx[i] = random(-40, 25);
      doty[i] = random(-150, 150);
    }
  }
  //updates the pillars position
  void update()
  {
    speed = new PVector(gSpeed.x, gSpeed.y);
    speed.mult(.5);
    pos.add(speed);
  }
  //renders the pillar
  void render()
  {
    pushMatrix();
    fill(#3CC4DE);
    noStroke();
    rectMode(CENTER);
    //main
    rect(pos.x, height - dim.y/2, dim.x, dim.y);
    stroke(#3CC4DE);
    strokeWeight(1);
    line(pos.x + dim.x/2, height - dim.y, pos.x + dim.x/2, height);
    line(pos.x - dim.x/2, height - dim.y, pos.x - dim.x/2, height);
    //top
    arc(pos.x, height - dim.y +1, dim.x, dim.x, radians(-180), 0);
    //shadows
    noStroke();
    fill(0, 0, 0, 30);
    rect(pos.x + dim.x*3/8, height - dim.y/2, dim.x/4, dim.y);
    rect(pos.x + dim.x*7/16, height - dim.y/2, dim.x/8, dim.y);
    beginShape();
    vertex(pos.x + dim.x/2, height -dim.y); //main bottom left corner of arc
    //outer dim.yining
    curveVertex(pos.x + dim.x/2, height -dim.y);  
    curveVertex(pos.x + dim.x/2*cos(radians(-10)), height -dim.y -dim.x/2*sin(radians(10)));
    curveVertex(pos.x + dim.x/2*cos(-PI/8), height -dim.y -dim.x/2*sin(PI/8));
    curveVertex(pos.x + dim.x/2*cos(-PI/6), height -dim.y -dim.x/2*sin(PI/6));
    curveVertex(pos.x + dim.x/2*cos(-PI/4), height -dim.y -dim.x/2*sin(PI/4));
    curveVertex(pos.x + dim.x/2*cos(-PI/3), height -dim.y -dim.x/2*sin(PI/3));
    curveVertex(pos.x + dim.x/2*cos(-PI*3/8), height -dim.y -dim.x/2*sin(PI*3/8));
    curveVertex(pos.x + dim.x/2*cos(radians(-80)), height -dim.y -dim.x/2*sin(radians(80)));
    curveVertex(pos.x, height -dim.y -dim.x/2);
    vertex(pos.x, height -dim.y -dim.x/2); //main top center vertex
    //inner dim.yining
    curveVertex(pos.x, height -dim.y -dim.x/2);
    curveVertex(pos.x + dim.x/4 - dim.x/8*cos(-PI/16), height - dim.y - dim.x/2.5*cos(PI/16));
    curveVertex(pos.x + dim.x/4, height - dim.y - dim.x/3*cos(PI/3));
    curveVertex(pos.x + dim.x/4, height -dim.y);
    vertex(pos.x + dim.x/4, height -dim.y); //main bottom centerish vertex
    endShape();
    //dark shadodim.xcurve
    beginShape();
    vertex(pos.x + dim.x/2, height -dim.y); //main bottom right corner of arc
    //outer dim.yining
    curveVertex(pos.x + dim.x/2, height -dim.y);
    curveVertex(pos.x + dim.x/2*cos(radians(-10)), height -dim.y -dim.x/2*sin(radians(10)));
    curveVertex(pos.x + dim.x/2*cos(-PI/8), height -dim.y -dim.x/2*sin(PI/8));
    curveVertex(pos.x + dim.x/2*cos(-PI/6), height -dim.y -dim.x/2*sin(PI/6));
    curveVertex(pos.x + dim.x/2*cos(-PI/4), height -dim.y -dim.x/2*sin(PI/4));
    curveVertex(pos.x + dim.x/2*cos(-PI/3), height -dim.y -dim.x/2*sin(PI/3));
    curveVertex(pos.x + dim.x/2*cos(-PI*3/8), height -dim.y -dim.x/2*sin(PI*3/8));
    curveVertex(pos.x + dim.x/2*cos(radians(-80)), height -dim.y -dim.x/2*sin(radians(80)));
    curveVertex(pos.x, height -dim.y -dim.x/2);
    vertex(pos.x, height -dim.y -dim.x/2); //main top center vertex
    //inner dim.yining
    curveVertex(pos.x, height -dim.y -dim.x/2);
    curveVertex(pos.x + dim.x*3/8 - dim.x/8*cos(-PI/16), height - dim.y - dim.x/2.5*cos(PI/16));
    curveVertex(pos.x + dim.x*3/8, height - dim.y - dim.x/3*cos(PI/3));
    curveVertex(pos.x + dim.x*3/8, height -dim.y);
    vertex(pos.x + dim.x*3/8, height -dim.y); //main bottom centerish vertex
    endShape();
    //dots
    fill(#ADFFFD);
    for (byte i = 0; i < 4; i++)
      ellipse(pos.x + dotx[i], height - dim.y*2/3 + doty[i], 30 + width/200, 35 + height/200);
    //reset
    stroke(0);
    strokeWeight(1);
    rectMode(CORNER);
    popMatrix();
  }

}

