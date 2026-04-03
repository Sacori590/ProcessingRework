public class Sprite {
  float x;
  float y;
  int currentframe;
  PImage img;
  int anim_size;
  int step_size;
  Sprite idle;
  HitBox hitbox;
  UI bubble;


  Sprite(PImage img, int a_s) {


    this.x = 0;
    this.y = 0;
    this.currentframe = 0;
    this.img = img;
    this.anim_size = a_s;
    this.step_size = 4;
    this.hitbox = new HitBox(0, 0, a_s, a_s);
    this.bubble = new UI(0, 0, a_s, a_s, this.toString());
    //must setup idle by hand
  }

  void anime(int dir) {
    //permet de lire l'animation d'un sprite
    int a_s = this.anim_size;
    int l = this.img.width / a_s;

    if (dir == 1)
      this.currentframe = (this.currentframe+1) %l;
    else if (dir == -1)
      this.currentframe = Math.abs(this.currentframe-1+l)%l;

    copy(img, a_s*this.currentframe, 0, a_s, a_s, (int) this.x, (int) this.y, a_s, a_s);
    //hitbox.draw(0);
  }

  void walk(float gx, float gy, int dir, int xoffset, int yoffset) {

    if (gx-this.step_size-5 <= this.x  && this.x <= gx+this.step_size+5 && gy-this.step_size-5 <= this.y  && this.y <= gy+this.step_size+5) {
      this.idle.x = this.x;
      this.idle.y = this.y;
      this.idle.hitbox.set(this.x+48, this.y+60, this.x+this.anim_size-48, this.y+this.anim_size);
      this.bubble.set(this.x - (int) (textWidth(this.bubble.text)/2)+anim_size/2, this.y+20, this.x+this.anim_size, this.y+40);

      this.idle.anime(dir);
    } else {
      this.anime(dir);
      this.x = (int) lerp(this.x, gx, 0.11);

      this.y = (int) lerp(this.y, gy, 0.11);
      this.hitbox.set(this.x+xoffset, this.y+yoffset, this.x+this.anim_size-xoffset, this.y+this.anim_size);
      //this.bubble.text = this.toString();
      this.bubble.set(this.x- (int) (textWidth(this.bubble.text)/2)+anim_size/2, this.y+20, this.x+this.anim_size, this.y+40);
    }
  }
  /*
  void goTo(int end_x) throws InitialisationException {
   if (this.idle == null) {
   throw new InitialisationException("attention l'animation d'idle n'a pas été implémentée dans Sprite.idle");
   }
   int dir = 1;
   
   //this.idle.y = this.y;
   if (this.x+this.step_size <= end_x ) {
   walk(1, anim_size/3, anim_size/3);
   }
   if (this.x-this.step_size >= end_x ) {
   walk(-1, anim_size/3, anim_size/3);
   dir = -1;
   }
   if (end_x-this.step_size <= this.x  && this.x <= end_x+this.step_size) {
   this.idle.x = this.x;
   this.idle.y = this.y;
   this.idle.hitbox.set(this.x+48, this.y+60, this.x+this.anim_size-48, this.y+this.anim_size);
   this.bubble.set(this.x - (int) (textWidth(this.bubble.text)/2)+anim_size/2, this.y+20, this.x+this.anim_size, this.y+40);
   
   this.idle.anime(dir);
   }
   }
   */
  public int getAnimationLength() {
    return this.img.width / anim_size;
  }

  /*
  @Override
   String toString() {
   
   return super.toString() + " " + String.format("Sprite {x : %d, y : %d}", x, y );
   }
   */

  boolean atStation(Building station) {
    return (this.x <= width-station.width+station.width/6-10 && this.x >= width-station.width+station.width/6-30);
  }
}
