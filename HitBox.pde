public class HitBox {
  int x1, y1, x2, y2, xoffset, yoffset;
  boolean clickable;


  HitBox(int x1, int y1, int x2, int y2) {
    this.x1 = x1;
    this.x2 = x2;
    this.y1 =y1;
    this.y2 = y2;
    this.xoffset = x2 - x1;
    this.yoffset = y2 - y1;
    this.clickable = true;
  }

  public boolean in() {
    /*
     print(mouseX, mouseY, "\n");
     print(this.x1, this.y1, this.x2, this.x2);
     */
    if (this.x1 <= mouseX && mouseX <= this.x2 && this.y1 <= mouseY && mouseY <= this.y2 && clickable) {
      return true;
    }
    return false;
  }

  public void set(int x1, int y1, int x2, int y2) {
    this.x1 = x1;
    this.x2 = x2;
    this.y1 =y1;
    this.y2 = y2;
    this.xoffset = x2 - x1;
    this.yoffset = y2 - y1;
  }

  public void draw(int radius) {
    rect(this.x1, this.y1, this.xoffset, this.yoffset, radius);
  }
}
