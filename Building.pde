public class Building extends Station {
  int x, y, width, height, iter;
  PImage img;

  Building(char id, Cabine c, PImage img, int x, int y) {
    super( id, c);
    this.x = x;
    this.y = y;
    this.height = img.height;
    this.width = img.width;
    this.img = img;
    this.iter = 0;
  }
  Building(char id, Cabine c) {
    super(id, c);
    this.x = 0;
    this.y = 0;
    this.height = 0;
    this.width = 0;
    this.img = null;
    this.iter = 0;
  }

  void draw() {
    image(this.img, this.x, this.y, this.width, this.height);
  }

  void set(PImage img, int x, int y) {
    this.x = x;
    this.y = y;
    this.height = img.height;
    this.width = img.width;
    this.img = img;
  }
}
