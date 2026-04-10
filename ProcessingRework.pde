import java.util.List;
import java.util.Arrays;

ArrayList<PImage> sprites = new ArrayList<PImage>();


UI add_person_button, debug;
PImage bg, station, cabine, cabine_idle;

int sprite_size = 0;
float resize_factor = 1;
// logique métier
Cabine C1, C2;
Station A, B, C;
Personne to_remove ;

ArrayList<Cabine> CabineSet = new ArrayList<Cabine>();

ArrayList<Station> StationsSet = new ArrayList<Station>();
boolean debug_mode = false;

float[] a;
float[] b;



void setup() {
  // size and bg size must be equals
  pixelDensity(1);
  size(768, 576);
  frameRate(30);
  fullScreen();


  // initialisation des sprites
  sprites.add(loadImage("assets/P1/Walk.png"));
  sprites.add(loadImage("assets/P1/Idle.png"));
  sprites.add(loadImage("assets/P2/Walk.png"));
  sprites.add(loadImage("assets/P2/Idle.png"));
  sprites.add(loadImage("assets/P3/Walk.png"));
  sprites.add(loadImage("assets/P3/Idle.png"));


  bg = loadImage("assets/nature_3/origbig.png");
  station = loadImage("assets/nature_3/Stations.png");
  cabine = loadImage("assets/téléphérique/cabine1.png");
  cabine_idle = loadImage("assets/téléphérique/cabine1.png");

  //resizing
  if (resize_factor > 1) {
    for (PImage e : sprites) {

      e.resize((int) (e.width/resize_factor), (int) (e.height/resize_factor));
    }
    station.resize((int) (station.width/resize_factor), (int) (station.height/resize_factor));
    cabine.resize((int) (cabine.width/resize_factor), (int) (cabine.height/resize_factor));
    cabine_idle.resize((int) (cabine_idle.width/resize_factor), (int) (cabine_idle.height/resize_factor));
  }
  bg.resize(width, height);

  /* initialize work logic */
  //create cabines and stations
  C1 = new Cabine('1', cabine, cabine.height);
  C2 = new Cabine('2', cabine, cabine.height );
  A = new Station('A', C1, 480, station);
  B = new Station('B', null, 480, station);
  C = new Station('C', C2, 480, station);

  //cabine configuration
  C1.position = A;
  C2.position = C;
  C1.idle = new Sprite(cabine_idle, cabine.height);
  C2.idle = new Sprite(cabine_idle, cabine.height);

  C1.initPopUp();
  C2.initPopUp();


  A.set(width-station.width-200, height-station.height, width-200, height);
  B.set(0, height/2 - station.height/2, station.width, height/2 - station.height/2+station.height);
  C.set(width-station.width-200, 0-station.height*0.3, width-200, station.height-station.height*0.3);

  a = C1.position.cabinePos();
  C1.set(a[0], a[1]);
  a = C2.position.cabinePos();
  //a = B.cabinePos();
  C2.set(a[0], a[1]);

  StationsSet.add(A);
  StationsSet.add(B);
  StationsSet.add(C);

  CabineSet.add(C1);
  CabineSet.add(C2);

  // fix positions
  sprite_size = sprites.get(0).height;
  add_person_button = new UI(10, 130, 30, 150, "Ajouter une personne");
  debug = new UI(10, 160, 30, 180, "assign me anything");
}

int queue(float x, int iter, ArrayList<Personne> queue) {
  if (iter == queue.size()) {
    return 0;
  }

  Personne current = queue.get(iter);

  for (Station s : StationsSet) {
    for (Cabine c : CabineSet )
    {

      if (s.enterers.contains(current) && current.atStation(s) && c == s.cabine && c.atStation(s)) {

        s.persons.add(current);

        c.mount(current);
        s.enterers.remove(current);
        iter--;
        c.persons.get(c.persons.size()-1).set(c.personsPosition(current), c.y);
      }
    }
  }

  int dir = (int)((x - current.x) /Math.abs((x-current.x)));

  current.walk(x-current.anim_size/3, current.y, dir, sprite_size/3, sprite_size/3);

  for (Station s : StationsSet) {
    if (current.atStation(s)) {
      return queue(x-current.anim_size/3, ++iter, queue);
    }
  }
  return queue(x-current.anim_size/3, ++iter, queue);
}



void mousePressed() {

  //println(mouseX, mouseY);
  //C2.set(mouseX, mouseY);
  // set actioin to add_person_button
  if (add_person_button.in()) {
    for (Station s : StationsSet) {
      //add sprite
      //println(s);
      s.persons.add(new Personne(sprites.get(0), sprite_size, null, s));
      s.persons.get(s.persons.size()-1).idle = new Sprite(sprites.get(1), sprite_size);
      s.persons.get(s.persons.size()-1).set(-sprite_size, s.y2-s.persons.get((s.persons.size()-1)).img.height);
      s.persons.get(s.persons.size()-1).initPopUp();
      s.persons.get(s.persons.size()-1).step_size =  (int) (s.persons.get(s.persons.size()-1).step_size/resize_factor) +2;
    }
  }

  // réadapter la fonction et la donner aux stations et les appeler pour chaque station
  Iterator<Station> it0 = StationsSet.iterator();
  while (it0.hasNext()) {
    Station S = it0.next();
    Iterator<Personne> it1 = S.persons.iterator();
    while (it1.hasNext()) {
      Personne s = it1.next();
      //action to button
      if (!Guard.alreadyOwned(s)) {
        if (s.bubble.pop_up_elements.get(0).in()) {
          s.buy(Titre_de_transport.Ticket);
        }
        if (s.bubble.pop_up_elements.get(1).in()) {
          s.buy(Titre_de_transport.Subscription);
        }
      } else {
        if (s.bubble.pop_up_elements.get(2).in()) {
          s.shred();
          s.setSprite(sprites.get(0), sprites.get(1));
        }
      }

      if (s.bubble.pop_up_elements.get(3).in()) {
        if (Guard.mount(s, S)) {
          s.x -= s.anim_size/3*S.enterers.size();
          S.enterers.add(s);
          it1.remove();
        }
      }


      // mask on click
      if (!s.hitbox.in()) {
        s.bubble.text = "";
        s.bubble.show_pop_up = false;
        s.hitbox.clickable = true;
        for (UI e : s.bubble.pop_up_elements) {
          e.clickable = false;
        }
      }
      //show button on click
      if (s.hitbox.in()) {
        s.bubble.popUpMenu();
        s.bubble.text = s.toString();
        s.bubble.show_pop_up = true;
        s.hitbox.clickable = false;
        for (UI e : s.bubble.pop_up_elements) {
          e.clickable = true;
        }
      }
    }
  }

  Iterator<Cabine> it2 = CabineSet.iterator();
  while (it2.hasNext()) {
    Cabine c = it2.next();
    Iterator<Personne> it3 = c.persons.iterator();
    while (it3.hasNext()) {
      Personne s = it3.next();
      if (c.bubble.pop_up_elements.get(0).in() && !c.animation) {
        to_remove = s;
      }
    }
    // go next station
    if (c.bubble.pop_up_elements.get(1).in()) {
      //println(c);
      float[] a = C1.nextStation().cabinePos();

      //C1.set((int)a[0], (int) a[1]);
      a = C2.nextStation().cabinePos();
      //C2.set((int)a[0], (int) a[1]);
      C1.move(C1.nextStation());
      C2.move(C2.nextStation());

      C1.animation = true;
      C2.animation = true;

      //c.walk(100, 295, 1, c.step_size/3, c.step_size/3);
      //println(c);
      //println(c.previousStation());
    }
    //go previous station
    if (c.bubble.pop_up_elements.get(2).in()) {
      float[] a = C1.previousStation().cabinePos();

      //C1.set(a[0], a[1]);
      a = C2.previousStation().cabinePos();
      //C2.set(a[0], a[1]);
      //println(c);
      C2.move(C2.previousStation());
      C1.move(C1.previousStation());
      C1.animation = true;
      C2.animation = true;
      //c.walk(100, 295, 1, c.step_size/3, c.step_size/3);
      //println(c);
    }

    if (!c.hitbox.in()) {
      c.bubble.text = "";

      c.bubble.show_pop_up = false;
      for (UI e : c.bubble.pop_up_elements) {
        e.clickable = false;
      }
    }
    if (c.hitbox.in()) {
      c.bubble.text = c.toString();
      c.bubble.show_pop_up = true;
      for (UI e : c.bubble.pop_up_elements) {
        e.clickable = true;
      }
    }
  }

  if (debug.in()) {
    debug_mode = !debug_mode;

    println("debug mode : ");
    for (Station s : StationsSet) {
      println(s.toString());
    }
    for (Cabine s : CabineSet) {
      println(s.toString());
    }
  }
}

//draw function
void draw() {
  //Background
  image(bg, 0, 0);
  //rect(0, 0, width, height);
  A.draw();
  B.draw();
  C.draw();


  //ForeGround
  //faire la file
  for (Station s : StationsSet) {
    s.iter = queue(s.portePos()[0], s.iter, s.persons);
    s.jter = queue(s.portePos()[0], s.jter, s.enterers);
  }



  //UI
  add_person_button.draw(20);
  debug.draw(20);
  for (Station s : StationsSet) {
    for (Personne p : s.persons) {
      if (p.bubble.text != "")
        p.bubble.draw(15);
      if (p.bubble.show_pop_up) {
        p.bubble.popUpMenu();
      }
    }
  }

  for (Cabine c : CabineSet) {
    for (Personne p : c.persons) {
      p.set(c.personsPosition(p), c.y);
      p.idle.anime(1);
    }
    if (c.bubble.text != "")
      c.bubble.draw(15);

    if (c.bubble.show_pop_up) {
      c.bubble.popUpMenu();
    }
    if (c.animation) {
      c.walk(c.position);
    } else {
      c.idle.anime(1);
    }
  }

  if (debug_mode) {
    for (Station s : StationsSet) {
      if (s.clickable) {
        s.draw(10);
      }
      for (Personne p : s.persons) {
        for (UI e : p.bubble.pop_up_elements) {
          if (e.clickable) {
            e.draw();
          }
        }
        p.hitbox.draw(1);
      }
    }
    for (Cabine c : CabineSet) {
      c.hitbox.draw(10);

      for (UI e : c.bubble.pop_up_elements) {
        if (e.clickable) {
          e.draw();
        }
      }
    }
  }
  Iterator<Cabine> it0 = CabineSet.iterator();
  while (it0.hasNext()) {
    Cabine n = it0.next();
    if (to_remove != null && n.persons.contains(to_remove)) {
      n.dismount(to_remove);
      to_remove.y = to_remove.station.portePos()[1]-to_remove.img.height;
      to_remove.x = to_remove.station.portePos()[0]-to_remove.anim_size/3;
      if (to_remove.titre == Titre_de_transport.None)
        to_remove.setSprite(sprites.get(0), sprites.get(1));
      to_remove = null;
    }
  }
}
// selection de l'action en faisant des randoms sur si la précondition est vérifiée ou pas dans une liste précise et pas tous pour ne pas perdre des ressources inutillements
