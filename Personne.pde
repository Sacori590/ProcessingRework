public class Personne extends Sprite {

  String name;
  Titre_de_transport titre;
  Cabine cabine;
  Station station;

  /*
     * ajoute une personne en lui donnant une position, un nom, un titre de
   * transport
   Personne(int n, Cabine c, Station s) throws InitialisationException {
   super( )
   this.titre = Titre_de_transport.None;
   this.name = "P" + Integer.valueOf(n).toString();
   this.cabine = c;
   this.station = s;
   }
   */

  /*
     * ajoute une personne en lui donnant une position, un nom, un titre de
   * transport
   */
  Personne(PImage img, int a_s, String n, Cabine c, Station s) throws InitialisationException {
    super(img, a_s);
    this.titre = Titre_de_transport.None;
    this.name = n;
    this.cabine = c;
    this.station = s;
  }

  Personne(PImage img, int a_s, Cabine c, Station s) throws InitialisationException {
    super(img, a_s);
    this.titre = Titre_de_transport.None;
    this.name = Name.getRandomName();
    this.cabine = c;
    this.station = s;
  }

  @Override
    public String toString() {
    char pos = '\0';
    if (this.station != null) {
      pos = this.station.Id;
    } else if (this.cabine != null) {
      pos = this.cabine.Id;
    }
    return String.format(
      "Personne {name : %s, position : %c, titre : %s}", this.name, pos, this.titre);
  }

  void buy(Titre_de_transport t) throws GuardException {
    if (this.titre == Titre_de_transport.None) {
      this.img = sprites.get(2);
      this.idle.img = sprites.get(3);
      if (Titre_de_transport.Ticket == t) {
        this.img = sprites.get(4);
        this.idle.img = sprites.get(5);
      }
      this.titre = t;
    } else {
      throw new GuardException("la personne possède déjà un titre de transport");
    }
  }

  void shred() throws GuardException {
    if (this.titre != Titre_de_transport.None) {
      this.titre = Titre_de_transport.None;
    } else {
      throw new GuardException("shred");
    }
  }

  boolean canEnter(Station station) {
    return (this.station == station
      && (this.titre == Titre_de_transport.Ticket || this.titre == Titre_de_transport.Subscription));
  }
  void initPopUp() {
    this.bubble.pop_up_elements = new ArrayList<UI>();
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Buy ticket"));
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Buy subscription"));
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Shred it !"));
    this.bubble.pop_up_elements.add(new UI(0, 0, 0, 0, "Enter current station"));
  }

  boolean atStation(Station station) {
    println(station.x1+station.img.width*0.26, this.x+this.anim_size/2, station.x1+station.img.width*0.34);
    return (station.x1+station.img.width*0.26 <= this.x+this.anim_size/2
      && this.x+this.anim_size/2 <= station.x1+station.img.width*0.34);
  }
}
