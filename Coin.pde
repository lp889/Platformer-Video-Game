// Implement this class. You just need to implement the constructor
// the three inherited methods from AnimatedSprite will work as is.

public class Coin extends AnimatedSprite{
  boolean isMystery = false;
  // call super appropriately
  // initialize standNeutral PImage array only since
  // we only have four coins and coins do not move.
  // set currentImages to point to standNeutral array(this class only cycles
  // through standNeutral for animation).
  public Coin(PImage img, float scale, boolean isMystery){
    super(img, scale);
    this.isMystery = isMystery;
    if (isMystery) {
      standNeutral = new PImage[1];
      standNeutral[0] = loadImage("data/mystery_block.png");
      currentImages = standNeutral;
    } else {
      standNeutral = new PImage[4];
      standNeutral[0] = loadImage("data/coins/gold1.png");
      standNeutral[1] = loadImage("data/coins/gold2.png");
      standNeutral[2] = loadImage("data/coins/gold3.png");
      standNeutral[3] = loadImage("data/coins/gold4.png");
      currentImages = standNeutral;
    }
    

  }
  
}
