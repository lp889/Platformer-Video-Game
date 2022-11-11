// RETRO MARIO
// (AP Computer Science A Final, Ms. Chang)
// by Luke Ponssen

// NOTE: don't press caps lock

// LIBRARIES
import java.lang.Math.*;

// VARIABLES --------------------------------------------------------
final static float SPRITE_SCALE = 50.0/244;
final static float SPRITE_SIZE = 50;
final static float MOVE_SPEED = 5;
final static float CROUCH_SPEED = 2;
final static float GRAVITY = .4;
final static float JUMP_SPEED = 8; 
final static float SUPER_JUMP_SPEED = 12;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

final static float RIGHT_MARGIN = 950;
final static float LEFT_MARGIN = 950;
final static float TOP_MARGIN = 300;
final static float BOTTOM_MARGIN = 300;

static int lives;
static int score;
final static float THRESHOLD = 1500;

float left_bd, right_bd;
float top_bd, bottom_bd;
float view_x;
float view_y;

Player player;
PImage playerImage, floor, block, mystery, coin, tallEnemy, skullEnemy;
ArrayList<Sprite> coins; // add coin animation
ArrayList<Enemy> enemies;
ArrayList<Sprite> platforms;
ArrayList<Sprite> floors;

boolean isGameOver;

// SETUP --------------------------------------------------------
void setup() {
  view_x = 0;
  view_y = 0;
  frameRate(240);
  size(1900, 1000);
  imageMode(CENTER);
  
  lives = 3;
  score = 0;
  isGameOver = false;
  
  floor = loadImage("data/dirt.png");
  block = loadImage("data/block.png");
  mystery = loadImage("data/mystery_block.png");
  coin = loadImage("data/coins/gold1.png");
  tallEnemy = loadImage("data/enemies/tall_enemy1.png");
  skullEnemy = loadImage("data/enemies/skull_enemy1.png");
  playerImage = loadImage("data/player/player_stand_right.png");
  player = new Player(playerImage, 50.0/387);
  player.center_x = 100;
  player.center_y = 950;
  
  coins = new ArrayList<Sprite>();
  enemies = new ArrayList<Enemy>();
  platforms = new ArrayList<Sprite>();
  floors = new ArrayList<Sprite>();
  createPlatforms("data/map.csv");
}


// DRAW --------------------------------------------------------
void draw() {
  
  if (lives <= 0) {
    isGameOver = true;
  } else if (score >= THRESHOLD) {
    isGameOver = true;
  }
  
  if (!isGameOver) {
  background(255);
  
  scroll();
  
  player.display();
  player.update();
  player.updateAnimation();
  
  resolveCollisions(player, platforms, enemies, coins);
  
  for(Sprite s: platforms){
    s.display();
  }
  
  for(Sprite s: floors){
    s.display();
  }
  
  for (Sprite c: coins) {
    c.display();
    c.updateAnimation();
  }
  
  for (Enemy e: enemies) {
    e.display();
    e.update();
    e.updateAnimation();
  }
  
  textSize(32);
  fill(255, 0, 0);
  text("Score: " + score + "\nLives: " + lives, view_x + 50, view_y + 50);
  
  if (player.center_y >= 1800) {
    lives -= 1;
    background(255, 0, 0);
    player.center_x = 100;
      player.center_y = 950;
      view_x = 0;
      view_y = 0;
  }
  }
  
  else if (isGameOver) {
    background(255);
    if (lives <= 0) {
      view_x = 0;
      view_y = 0;
      background(255, 0, 0);
      textSize(128);
      fill(255);
      text("GAME OVER", view_x + width/2 - 300, view_y + height/2 - 50);
      textSize(50);
      text("(Press y to restart)", view_x + width/2 - 160, view_y + height/2 + 50);
    } else if (score >= THRESHOLD) {
      view_x = 0;
      view_y = 0;
      background(0, 0, 255);
      textSize(128);
      fill(255);
      text("YOU WIN", view_x + width/2 - 250, view_y + height/2 - 200);
      textSize(50);
      text("(Press y to restart)", view_x + width/2 - 210, view_y + height/2 + 50);
    }
    
  }
}


// KEYBOARD CONTROLS --------------------------------------------------------
void keyPressed(){
  if(key == 'd'){
    if (player.isCrouching) {
      player.change_x = CROUCH_SPEED;
    } else {
      player.change_x = MOVE_SPEED;
    }
  }
  else if(key == 'a'){
    if (player.isCrouching) {
      player.change_x = -CROUCH_SPEED;
    } else {
      player.change_x = -MOVE_SPEED;
    }
  }
  else if (key == 's') {
    player.isCrouching = true;
  }
  else if(key == ' ' && isOnPlatforms(player, platforms)) {
    if (player.isCrouching) {
      player.change_y = -SUPER_JUMP_SPEED;
    } else {
      player.change_y = -JUMP_SPEED;
    }
  }
  else if (key == 'y' && isGameOver) {
    setup();
  }
}

void keyReleased(){
  if(key == 'd'){
    player.change_x = 0;
  }
  else if(key == 'a'){
    player.change_x = 0;
  }
  else if (key == 's') {
    player.isCrouching = false;
  }
}


// CREATING MAP --------------------------------------------------------
void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("f")){
        Sprite s = new Sprite(floor, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("c")){
        Coin s = new Coin(coin, 50.0/128, false);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(s);
      }
      else if (values[col].equals("b")) {
        Sprite s = new Sprite(block, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].indexOf("SKULL") >= 0) {
        int len = int(values[col].substring(5));
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + len * SPRITE_SIZE;
        Enemy s = new Enemy(skullEnemy, 50.0/700, bLeft, bRight);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        enemies.add(s);
      }
      else if (values[col].equals("M")) {
        Coin s = new Coin(mystery, 50.0/214, true);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(s);
      }
      else if (values[col].equals("0")) {
        continue;
      }
    }
  }
}


// RESOLVING PLATFORM AND ENEMY COLLISIONS --------------------------------------------------------
public void resolveCollisions(Sprite s, ArrayList<Sprite> walls, ArrayList<Enemy> enemyList, ArrayList<Sprite> coinList){
  
  ArrayList<Sprite> col_list;
  ArrayList<Sprite> enm_col_list = new ArrayList<Sprite>();
  for (Enemy e: enemyList) {
    enm_col_list.add(e);
  }
  enm_col_list = checkCollisionList(s, enm_col_list);
  ArrayList<Sprite> coin_list = checkCollisionList(s, coinList);
  
  // Y DIRECTION
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_y > 0) {
      s.setBottom(collided.getTop());
    } else if (s.change_y < 0) {
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  
  // X DIRECTION
  s.center_x += s.change_x;
  
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_x > 0) {
      s.setRight(collided.getLeft());
    } else if (s.change_x < 0) {
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
  
  // ENEMY COLLISION
  if (enm_col_list.size() > 0) {
    for (Sprite e: enm_col_list) {
      enemyList.remove((Enemy) e);
      lives -= 1;
      background(255, 0, 0);
      player.center_x = 100;
      player.center_y = 950;
      view_x = 0;
      view_y = 0;
    }
  }
  
  // COIN COLLISION
  if (coin_list.size() > 0) {
    for (Sprite c: coin_list) {
      coins.remove(c);
      if (((Coin)c).isMystery == true) {
        score += 500;
      } else {
        score += 1;
      }
    }
  }
  
}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  // move down say 5 pixels
  s.center_y += 5;

  // check to see if sprite collide with any walls by calling checkCollisionList
  // move back up 5 pixels to restore sprite to original position.
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;

  // if sprite did collide with walls, it must have been on a platform: return true
  // otherwise return false.
  if (col_list.size() > 0) {
    return true;
  }
  return false;
}


// MAP SCROLLER --------------------------------------------------------
void scroll(){
  // compute x-coordinate of right boundary
  // if player's right passed this boundary, update view_x
  right_bd = view_x + width - RIGHT_MARGIN;
  if(player.getRight() > right_bd){
    view_x += (player.getRight() - right_bd);
  }
  
  // compute x-coordinate of left boundary
  // if player's left passed this boundary, update view_x
  if (player.getLeft() > 950) {
  left_bd = view_x + LEFT_MARGIN;
  if(player.getLeft() < left_bd){
    view_x -= (left_bd - player.getLeft());
  }}
  
  // compute y-coordinate of bottom boundary
  // if player's bottom passed this boundary, update view_y
  if (player.center_x > 0) {
  bottom_bd = view_y + height - BOTTOM_MARGIN;
  if (player.getBottom() > bottom_bd) {
    view_y += (player.getBottom() - bottom_bd);
  }}
  
  // compute y-coordinate of top boundary
  // if player's top passed this boundary, update view_y
  top_bd = view_y + TOP_MARGIN;
  if (player.getTop() < top_bd) {
    view_y -= (top_bd - player.getTop());
  }
  
  // translate the game world coordinate in the opposite direction
  // of (view_x, view_y).
  translate(-view_x, -view_y);
  
}
