import java.util.ArrayList;

public class Station extends HitBox {
  char Id = '\0';
  ArrayList<Personne> persons;
  int iter;
  ArrayList<Personne> enterers;
  int jter;
  Cabine cabine;
  PImage img;

  Station(char id, Cabine c, float size, PImage img) {
    super(0, 0, size, size);
    iter = 0;
    jter = 0;
    boolean cabineValid = true;
    int i = 0;
    this.img = img;
    if (c != null) {
      char[] cabines = { '1', '2' };
      cabineValid = false;
      while (cabineValid == false && i < cabines.length) {
        cabineValid = (cabines[i++] == c.Id);
      }
    }
    char[] ids = { 'A', 'B', 'C' };
    Boolean idValid = false;
    i = 0;
    while (idValid == false && i < ids.length) {
      idValid = (ids[i++] == id);
    }
    if (idValid && cabineValid) {
      this.Id = id;
      this.cabine = c;
      this.persons = new ArrayList<Personne>();
      this.enterers = new ArrayList<Personne>();
    } else {
      println("Station(char id, Cabine c, float size) : \'id\' must be in {'A', 'B', 'C'} and \'Cabine\' must be null or in {'1','2'}");
    }
  }

  @Override
    public String toString() {
    char cab;
    if (this.cabine == null) {
      cab = '/';
    } else {
      cab = this.cabine.Id;
    }

    return String.format("Station { id: %c, Cabine n°%s, Persons : %d }", this.Id, cab, this.count());
  }


  void add(Personne p) throws GuardException {
    if (!this.persons.contains(p)) {
      this.persons.add(p);
    } else {
      throw new GuardException("add Personne");
    }
  }

  void add(Cabine c) throws GuardException {
    if (this.cabine != c) {
      this.cabine = c;
    } else {
      throw new GuardException("add Cabine");
    }
  }

  void remove(Personne p) throws GuardException {
    if (this.persons.contains(p)) {
      this.persons.remove(p);
    } else {
      throw new GuardException("remove Personne");
    }
  }

  void remove(Cabine c) throws GuardException {
    if (this.cabine != null) {
      this.cabine = null;
    } else {
      throw new GuardException("there is no cabine at the station");
    }
  }

  int count() {
    return this.persons.size();
  }

  public void draw() {
    image(this.img, this.x1, this.y1);
  }

  float[] cabinePos() {
    float pos[] = new float[2];
    pos[0] = this.x1+this.img.width*0.53;
    pos[1] = this.y1+this.img.height*0.52;
    return pos;
  }

  float[] portePos() {
    float pos[] = new float[2];
    pos[0] = this.x1+this.img.width*0.26;
    pos[1] = this.y2;
    return pos;
  }
}
