public class UI extends HitBox {
  String text;
  boolean show_pop_up;
  ArrayList<UI> pop_up_elements = null;
  UI(int x1, int y1, int x2, int y2) {
    super(x1, y1, x2, y2);
    this.text = "";
    show_pop_up = false;
  }

  UI(int x1, int y1, int x2, int y2, String text) {
    super(x1, y1, x2, y2);
    this.text = text;
    show_pop_up = false;
  }

  void popUpMenu() {

    if (this.pop_up_elements == null) {
      return;
    }
    int i = 0;
    for (UI ele : this.pop_up_elements) {

      /*ele.x1 = this.x2 + 15;
       ele.y1 = this.y1 + 25 * i;
       ele.xoffset = (int) textWidth(ele.text) + 15;
       ele.yoffset = 20;
       ele.x2 = ele.x1 + ele.xoffset;
       ele.y2 = ele.y1 + ele.yoffset;*/
      ele.set(this.x2+15, this.y1+25*i, this.x2+15 + textWidth(ele.text) + 15, this.y1+25*i +20);

      ele.draw(30);
      i++;
    }
  }


  public void draw(int radius) {
    this.set(this.x1, this.y1, this.x1+textWidth(this.text), this.y2);
    fill(0, 0, 0);
    super.draw(30);
    fill(255, 155, 0);
    text(this.text, this.x1, this.y2-5);
  }
}
