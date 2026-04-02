import java.util.Iterator;
import java.util.NoSuchElementException;

public class SpriteSet implements Iterable<Sprite> {
  ArrayList<Sprite> list_sprite;

  SpriteSet() {
    list_sprite = new ArrayList<Sprite>();
  }

  public int size() {
    return this.list_sprite.size();
  }

  public void add(Sprite s) {
    this.list_sprite.add(s);
  }

  public void remove(Sprite x) {
    this.list_sprite.remove(x);
  }

  public boolean contains(Sprite s) {
    for (Sprite ls : list_sprite) {
      if (ls.equals(s))
        return true;
    }
    return false;
  }

  public Sprite get(int x) throws NoSuchElementException {
    if (this.list_sprite.size() > 0)
      return this.list_sprite.get(x);
    throw new NoSuchElementException("SpriteSet.get(int), this element do not Exist");
  }

  @Override
    public Iterator<Sprite> iterator() {
    return new IterOnSprite();
  }

  private class IterOnSprite implements Iterator<Sprite> {
    private int i;

    IterOnSprite() {
      this.i = 0;
    }

    @Override
      public boolean hasNext() {
      return i < size();
    }

    @Override
      public Sprite next() throws NoSuchElementException {
      Sprite ret;
      for (int e = i; e < size(); e++) {
        if (hasNext()) {
          ret = list_sprite.get(this.i);
          this.i += 1;
          return ret;
        }
      }
      throw new NoSuchElementException();
    }
  }
  @Override
    String toString() {
    String out = "{\n";
    for (Sprite e : list_sprite) {
      out += e.toString() + ",\n";
    }
    out += "}";
    return out;
  }
}
