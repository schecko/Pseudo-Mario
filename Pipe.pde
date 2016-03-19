//background element for style
class Pipe extends GameObject
{
  Pipe(float xPos, float yPos, float dimX, float dimY)
  {
    super(xPos, yPos, dimX, dimY);
    if ((int) random(2) == 1)
    {
      ALinteractible.add(new Coin(pos.x, pos.y - dim.y - 25, 50, 50));
    }
  }
  //renders the pipe
  void render()
  {
    rectMode(CENTER);
    //main
    strokeWeight(2);
    stroke(1);
    fill(#10C645);
    pushMatrix();
    translate(pos.x, pos.y);

    rect(0, -dim.y/2, dim.x, dim.y);

    //shine
    noStroke();
    fill(255, 230);
    rect(-dim.x/6, -dim.y/2, dim.x/6, dim.y);

    //shadowR
    noStroke();
    fill(0, 60);
    rect(dim.x/2.5, -dim.y/2, dim.x/5, dim.y);
    rect(dim.x/2.2, -dim.y/2, dim.x/10, dim.y);
    //shadowL
    rect(-dim.x/2.3, -dim.y/2, dim.x/10, dim.y);

    //lip
    strokeWeight(2);
    stroke(1);
    fill(#10C645);
    rect(0, -dim.y, dim.x*1.2, width/40);
    //lipshine
    noStroke();
    fill(255, 230);
    rect(-dim.x/5, -dim.y, dim.x/6, width/40);

    //lipshadowR
    noStroke();
    fill(0, 60);
    rect(dim.x/2, -dim.y, dim.x/5, width/40);
    rect(dim.x/1.8, -dim.y, dim.x/10, width/40);
    //lipshadowL
    rect(-dim.x/1.8, -dim.y, dim.x/10, width/40);
    popMatrix();
  }
}

