public  class Random {

  private  Station getStation() {
    int index = (int) (Math.random()*StationsSet.size());
    return StationsSet.get(index);
  }

  private  Cabine getCabine() {
    int index = (int) (Math.random()*CabineSet.size());
    return CabineSet.get(index);
  }

  private  Personne getPersonne() {
    Station station = getStation();
    if (station.persons.size() < 1)
      return null;
    int index = (int) (Math.random()*station.persons.size());
    return station.persons.get(index);
  }
  void summon() {
    Station s = getStation();
    s.persons.add(new Personne(sprites.get(0), sprite_size, null, s));
    s.persons.get(s.persons.size()-1).idle = new Sprite(sprites.get(1), sprite_size);
    s.persons.get(s.persons.size()-1).set(-sprite_size, s.y2-s.persons.get((s.persons.size()-1)).img.height);
    s.persons.get(s.persons.size()-1).initPopUp();
    s.persons.get(s.persons.size()-1).step_size =  (int) (s.persons.get(s.persons.size()-1).step_size/resize_factor) +2;
  }
  void getPersonAction() {

    Personne personne = getPersonne();
    if (personne == null)
      return ;

    int index = (int) (Math.random()*personne.bubble.pop_up_elements.size());

    switch(index) {
      case(0):
      if (personne.titre == Titre_de_transport.None) {
        personne.buy(Titre_de_transport.Ticket);
      }
      break;
      case(1):
      if (personne.titre == Titre_de_transport.None) {
        personne.buy(Titre_de_transport.Subscription);
      }
      break;
      case(2):
      if (personne.titre != Titre_de_transport.None) {
        personne.shred();
      }
      break;
      case(3):
      if (Guard.mount(personne, personne.station)) {
        println("mount");
        println(personne);
        println(personne.station);

        personne.x -= personne.anim_size/3*personne.station.enterers.size();
        personne.station.enterers.add(personne);
        personne.station.persons.remove(personne);
      }
      break;
      case(4):
      //personne.station.persons.remove(personne);
      break;
    }
  }
  void getCabineAction() {
    Cabine cabine = getCabine();
    int index = (int) (Math.random()*40);
    print(index);

    if (index >10 && cabine.count()>3) {
      if (!cabine.animation && cabine.persons.size() >0) {
        println(cabine.persons.size()-1);
        println(cabine);
        to_remove = cabine.persons.get(cabine.persons.size()-1);
      }
    } else if (index == 8) {

      if (!C1.animation && !C2.animation) {

        C1.move(C1.nextStation());
        C2.move(C2.nextStation());
        C1.animation = true;
        C2.animation = true;
      }
    } else {

      if (!C1.animation && !C2.animation) {

        C2.move(C2.previousStation());
        C1.move(C1.previousStation());

        C1.animation = true;
        C2.animation = true;
      }
    }
  }
}
