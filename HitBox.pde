public class HitBox {
  float x1, y1, x2, y2, xoffset, yoffset;
  boolean clickable;


  HitBox(float x1, float y1, float x2, float y2) {
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

  public void set(float x1, float y1, float x2, float y2) {
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
  public void draw() {
    rect(this.x1, this.y1, this.xoffset, this.yoffset, 0);
  }
}
