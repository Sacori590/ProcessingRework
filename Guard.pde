import java.util.ArrayList;

public static class Guard {
  public static boolean mount(Personne person, Station station) {
    if (station.cabine.count() >3 ) {
      return false;
    }
    if (person.titre == Titre_de_transport.Ticket) {
      for (Personne p : station.persons) {
        if (p.titre == Titre_de_transport.Subscription) {
          return false ;
        }
      }
    }
    if (person.titre == Titre_de_transport.None)
      return false;
    return true;
  }

  public static boolean alreadyOwned(Personne p) {
    if (p.titre != Titre_de_transport.None)
      return true;
    return false;
  }
}
