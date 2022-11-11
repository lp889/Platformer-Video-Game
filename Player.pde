public class Player extends AnimatedSprite{
  boolean inPlace;
  boolean isCrouching;
  boolean wasPreviouslyCrouching;
  PImage[] standLeft;
  PImage[] standRight;
  public Player(PImage img, float scale){
    super(img, scale);
    direction = RIGHT_FACING;
    inPlace = true;
    isCrouching = false;
    wasPreviouslyCrouching = false;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("data/player/player_stand_left.png");
    crouchLeft = new PImage[1];
    crouchLeft[0] = loadImage("data/player/player_crouch_left.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("data/player/player_stand_right.png");
    crouchRight = new PImage[1];
    crouchRight[0] = loadImage("data/player/player_crouch_right.png");
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("data/player/player_stand_left.png");
    moveLeft[1] = loadImage("data/player/player_walk_left.png");
    crouchingLeft = new PImage[2];
    crouchingLeft[0] = loadImage("data/player/player_crouch_left.png");
    crouchingLeft[1] = loadImage("data/player/player_crouchmove_left.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("data/player/player_stand_right.png");
    moveRight[1] = loadImage("data/player/player_walk_right.png");
    crouchingRight = new PImage[2];
    crouchingRight[0] = loadImage("data/player/player_crouch_right.png");
    crouchingRight[1] = loadImage("data/player/player_crouchmove_right.png"); 
    currentImages = standRight;
  }
  @Override
  public void updateAnimation(){
    // TODO:
    // update inPlace variable: player is inPlace if it is not moving
    // in both direction.
    // call updateAnimation of parent class AnimatedSprite.
    inPlace = change_x == 0 && change_y == 0;
    if (isCrouching && !wasPreviouslyCrouching) {
      player.w = 50.0;
      player.h = 50.0;
      wasPreviouslyCrouching = !wasPreviouslyCrouching;
    } else if (!isCrouching && wasPreviouslyCrouching) {
      player.w = 50.0/387*337;
      player.h = 50.0/387*479;
      wasPreviouslyCrouching = !wasPreviouslyCrouching;
    }
    super.updateAnimation();
  }
  @Override
  public void selectDirection(){
    if(change_x > 0)
      direction = RIGHT_FACING;
    else if(change_x < 0)
      direction = LEFT_FACING;    
  }
  @Override
  public void selectCurrentImages(){
    // TODO: Some of the code is already given to you.
    // if direction is RIGHT_FACING
    //    if inPlace
    //       select standRight images
    //    else select moveRight images
    // else if direction is LEFT_FACING
    //    if inPlace
    //       select standLeft images
    //    else select moveLeft images
    if (!isCrouching) {
    if(direction == RIGHT_FACING){
      if(inPlace){
        currentImages = standRight;
      }
      else {
        currentImages = moveRight;
      }
    }
    else if (direction == LEFT_FACING) {
      if (inPlace) {
        currentImages = standLeft;
      } else {
        currentImages = moveLeft;
      }
    }
    else {
      currentImages = standRight;
    }
    
    } else {
    
    if(direction == RIGHT_FACING){
      if(inPlace){
        currentImages = crouchRight;
      }
      else {
        currentImages = crouchingRight;
      }
    }
    else if (direction == LEFT_FACING) {
      if (inPlace) {
        currentImages = crouchLeft;
      } else {
        currentImages = crouchingLeft;
      }
    }
    else {
      currentImages = crouchRight;
    }
    }

    
  }
}
