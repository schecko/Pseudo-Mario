//simple signpost to display messages for tutorials and hints
class SignPost extends GameObject
{
  PImage signPost; //image for the signpost
  String message; //text message for the signpost
  SignPost(float xPos, float yPos, float dimX, float dimY, String message)
  {
    super(xPos, yPos, dimX, dimY);
    signPost = loadImage("SignPost.png");
    signPost.resize((int) dim.x, (int) dim.y);
    this.message = message;
  }
  //renders the image with the message
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(signPost, 0, -dim.y/2);
    textAlign(CENTER);
    textSize(20);
    fill(255);
    text(message, 0,- dim.y*3/4);
    popMatrix();
  }

}

