import java.util.ArrayList;

public class Cabine extends Sprite {
  // position appartient à {'A', 'B', 'C'}
  Station position;
  // Id appartient à {'1','2'}
  char Id;
  ArrayList<Personne> persons;
  ArrayList<Personne> outers;
  boolean animation;
  Cabine(char id, PImage img, int a_s) throws InitialisationException {
    super(img, a_s);
    char[] ids = { '1', '2' };
    Boolean idValid = false;
    int i = 0;
    while (idValid == false && i < ids.length) {
      idValid = (ids[i++] == id);
    }

    if (idValid) {

      this.Id = id;
      this.persons = new ArrayList<Personne>();
      this.animation = false;
    } else {
      throw new InitialisationException("\'id\' must be in {'1','2'}");
    }
  }

  Cabine(char id, Station pos, PImage img, int a_s) throws InitialisationException {
    super(img, a_s);
    char[] ids = { '1', '2' };
    Boolean idValid = false;
    int i = 0;
    while (idValid == false && i < ids.length) {
      idValid = (ids[i++] == id);
    }
    char[] poss = { 'A', 'B', 'C' };
    Boolean posValid = false;
    i = 0;
    while (posValid == false && i < poss.length) {
      posValid = (poss[i++] == pos.Id);
    }
    if (idValid && posValid) {
      this.position = pos;
      this.Id = id;
      this.persons = new ArrayList<Personne>();
      this.animation = false;
    } else {
      throw new InitialisationException("\'position\' must be in {'A', 'B', 'C'} and \'id\' in {'1','2'}");
    }
  }

  @Override
    public String toString() {
    if (this.position == null)
      return "this == null";
    return String.format("Cabine { Id: %c, Position: %c, Persons: %d }", this.Id, this.position.Id, this.count());
  }

  // déplace la cabine vers la prochaine station possible
  void move(Station destination) throws GuardException {
    if (destination != this.position) {
      this.position.remove(this);
      this.position = destination;
      destination.add(this);
    } else {
      throw new GuardException("Cabine.move(Station)");
    }
  }

  // compte le nombre de personne dans une cabine
  int count() {
    return persons.size();
  }

  void mount(Personne personne) throws GuardException {
    /*
         * guarde
     * la personne doit avoir un ticket ou un abonnement
     * la personne doit être à la même station que la cabine
     * les personnes avec un ticket rentre après celle avec un abonnement
     */
    Station station = personne.station;
    boolean priority = false;
    if (station == null) {

      return;
    }
    if (this.count() >= 4) {
      throw new GuardException("Cabine.mount(Personne), too much persons in cabine");
    }
    if (personne.titre == Titre_de_transport.Ticket) {
      for (Personne p : station.persons) {
        if (p.titre == Titre_de_transport.Subscription) {
          priority = false;
          break;
        }
        priority = true;
      }
    } else if (personne.titre == Titre_de_transport.Subscription) {
      priority = true;
    }
    if (personne.titre != Titre_de_transport.None && personne.station == this.position && priority) {
      station.remove(personne);
      this.persons.add(personne);
      personne.cabine = this;
      personne.station = null;
    } else {

      throw new GuardException("Cabine.mount(Personne)");
    }
  }

  void dismount(Personne personne) throws GuardException {
    /*
         * la personne doit être dans une cabine
     * cas particulier un ticket doit se déchirer à la sortie
     */
    Station station = this.position;
    if (this.persons.contains(personne)) {
      station.add(personne);
      this.persons.remove(personne);
      personne.station = station;
      personne.cabine = null;
      if (personne.titre == Titre_de_transport.Ticket) {
        personne.shred();
      }
    } else {
      throw new GuardException("Sprite.Personne.dismount(Personne)");
    }
  }

  void initPopUp() {
    this.bubble.pop_up_elements = new ArrayList<UI>();
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Dismount person"));
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Move to next station"));
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Move to previous station"));
  }

  Station nextStation() {
    Station ret = null;
    if (this.position.Id == 'A') {
      ret = B;
    } else if (this.position.Id == 'B') {
      ret = C;
    } else {
      ret = A;
    }
    return ret;
  }

  Station previousStation() {
    Station ret = null;
    if (this.position.Id == 'A') {
      ret = C;
    } else if (this.position.Id == 'B') {
      ret = A;
    } else {
      ret =  B;
    }
    return ret;
  }

  boolean atStation(Station station) {
    a = station.cabinePos();
    /*println(String.format(
     "[atStation debug]\n" +
     "  x: %.1f <= %.1f <= %.1f  →  %b\n" +
     "  y: %.1f <= %.1f <= %.1f  →  %b\n" +
     "  => atStation = %b",
     a[0], this.x + this.anim_size/2f, a[0] + this.getAnimationLength(),
     a[0] <= this.x + this.anim_size/2f && this.x + this.anim_size/2f <= a[0] + this.getAnimationLength(),
     a[1], this.y + this.img.height/2f, a[1] + this.img.height,
     a[1] <= this.y + this.img.height/2f && this.y + this.img.height/2f <= a[1] + this.img.height,
     (a[0] <= this.x + this.anim_size/2f && this.x + this.anim_size/2f <= a[0] + this.getAnimationLength())
     && (a[1] <= this.y + this.img.height/2f && this.y + this.img.height/2f <= a[1] + this.img.height)
     ));*/
    return (
      a[0] <= this.x+this.anim_size/4
      && this.x+this.anim_size/8 <= a[0] + this.anim_size/4
      && a[1] <= this.y+this.img.height/4
      && this.y+this.img.height/4 <= a[1] + this.anim_size/4
      );
  }
  void walk(Station end) {
    a = end.cabinePos();
    float d = dist(this.x, this.y, a[0], a[1]);
    if (this.atStation(end)) {
      // déjà arrivé, snap direct
      this.set(a[0], a[1]);
      this.idle.anime(1);
      this.animation = false;
    } else {
      this.anime(1);
      this.set(
        lerp(this.x, a[0], this.step_size / d),
        lerp(this.y, a[1], this.step_size / d)
        );
    }
  }
  float personsPosition(Personne p) {

    return this.x -p.anim_size/5+ this.anim_size/8*this.persons.indexOf(p);
  }
}
