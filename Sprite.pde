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
    this.bubble = new UI(0, 0, a_s, a_s, "");
    //must setup idle by hand
  }
  void set(float x, float y) {
    this.x = x;
    this.y = y;
    this.idle.x = x;
    this.idle.y = y;
    this.hitbox.set(x, y, x+this.anim_size, y+this.anim_size);
    this.bubble.set(x - (int) (textWidth(this.bubble.text)/2)+this.anim_size/2, y-40, x+this.anim_size, y-20);
  }
  void setSprite(PImage run, PImage idle) {
    this.idle.img = idle;
    this.img = run;
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
  }

  void walk(float gx, float gy, int dir, int xoffset, int yoffset) {

    if (gx-this.step_size-5 <= this.x  && this.x <= gx+this.step_size+5 && gy-this.step_size-5 <= this.y  && this.y <= gy+this.step_size+5) {
      this.set(gx, gy);
      this.hitbox.set(this.x+xoffset, this.y+yoffset, this.x+this.anim_size-xoffset, this.y+this.anim_size);

      this.idle.anime(dir);
    } else {
      this.anime(dir);
      this.set(lerp(this.x, gx, 0.1), lerp(this.y, gy, 0.1));
      this.hitbox.set(this.x+xoffset, this.y+yoffset, this.x+this.anim_size-xoffset, this.y+this.anim_size);
    }
  }

  public int getAnimationLength() {
    return this.img.width / anim_size;
  }
}




for (s : StationsSet) {
  for (p : s.persons) {

    if (p.bubble.text != "") {
      p.bubble.draw(15);
      p.bubble.show_pop_up = true;
      p.hitbox.clickable = false;
      for (UI e : p.bubble.pop_up_elements) {
        e.clickable = true;
      }
    }
    if (p.bubble.show_pop_up) {
      p.bubble.popUpMenu();
    }

    if (s.enterers.contains(p) && p.atStation(s) && s.cabine != null) {
      if (s.cabine.atStation(s)) {
        s.persons.add(p);

        c.mount(p);
        s.enterers.remove(p);
        iter--;
        c.persons.get(c.persons.size()-1).set(c.personsPosition(p), c.y);
      }
    }
    current.walk(x-current.anim_size/3*s.count+1, current.y, dir, sprite_size/3, sprite_size/3);
  }
}
