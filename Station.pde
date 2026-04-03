import java.util.ArrayList;

public class Station {
  char Id = '\0';
  ArrayList<Personne> persons;
  Cabine cabine;

  Station(char id, Cabine c) {
    Boolean cabineValid = true;
    int i = 0;
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
    }
  }

  @Override
    public String toString() {
    return String.format("Station %c >> Cabine n°%c | Persons : %d", this.Id, this.cabine.Id, this.count());
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
      throw new GuardException("Remove Cabine");
    }
  }

  int count() {
    return this.persons.size();
  }
}
