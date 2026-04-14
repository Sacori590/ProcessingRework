import java.util.List;
import java.util.Arrays;
import java.util.Iterator;
ArrayList<PImage> sprites = new ArrayList<PImage>();


UI add_person_button, debug, station_is_moving, move_a_station;
PImage bg, fg, station, station3, station4, cabine, cabine_idle;
Object rm_from = null;

int sprite_size = 0;
float resize_factor = 2;
// logique métier
Cabine C1, C2;
Station A, B, C, moving;
Personne to_remove ;

ArrayList<Cabine> CabineSet = new ArrayList<Cabine>();

ArrayList<Station> StationsSet = new ArrayList<Station>();
boolean debug_mode = false;
boolean move_station = false;

float[] a;

void setup() {
  // size and bg size must be equals
  pixelDensity(1);
  size(1024, 604);
  size(1920, 1080);
  frameRate(60);
  fullScreen();
  noSmooth();

  //windowResizable(true);


  // initialisation des sprites
  sprites.add(loadImage("assets/P1/Walk.png"));
  sprites.add(loadImage("assets/P1/Idle.png"));
  sprites.add(loadImage("assets/P2/Walk.png"));
  sprites.add(loadImage("assets/P2/Idle.png"));
  sprites.add(loadImage("assets/P3/Walk.png"));
  sprites.add(loadImage("assets/P3/Idle.png"));


  bg = loadImage("assets/nature_3/origbig.png");
  fg = loadImage("assets/nature_3/foreGround.png");
  station = loadImage("assets/téléphérique/stationLayer1.png");
  station3 = loadImage("assets/téléphérique/stationLayer3.png");
  station4 = loadImage("assets/téléphérique/stationLayer4.png");
  cabine_idle = loadImage("assets/téléphérique/cabine-Sheet.png");
  cabine = loadImage("assets/téléphérique/cabineIdle-Sheet.png");

  //resizing
  generalResize();
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

  /* 1470 956  meilleur positionnement des cabines*/

  /* 745 326     0.50 0.34       */
  /*1077 818     0.73 0.85         */
  /* 60 474      0.04 0.50         */

  A.set(width*0.73, height*0.85-station.height, width*0.73+station.width, height*0.85);
  B.set(width*0.04, height*0.50-station.height, width*0.04+station.width, height*0.50);
  C.set(width*0.50, height*0.32-station.height, width*0.50+station.width, height*0.32);

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
  add_person_button = new UI(10, 130, 30, 150, "Add a person to each station");
  debug = new UI(10, 160, 30, 180, "Show hitboxes");
  move_a_station = new UI(10, 190, 30, 210, "Move stations to another location :");
  station_is_moving = new UI(0, 0, 0, 0);
}

void drawCable() {
  stroke(10);
  strokeWeight(1/resize_factor*6);
  line(A.cabinePos()[0]+C1.anim_size/2, A.cabinePos()[1], B.cabinePos()[0]+C1.anim_size/2, B.cabinePos()[1]);
  line(C.cabinePos()[0]+C1.anim_size/2, C.cabinePos()[1], A.cabinePos()[0]+C1.anim_size/2, A.cabinePos()[1]);
  line(C.cabinePos()[0]+C1.anim_size/2, C.cabinePos()[1], B.cabinePos()[0]+C1.anim_size/2, B.cabinePos()[1]);
  noStroke();
}
void generalResize() {
  if (resize_factor != 0) {
    for (PImage e : sprites) {

      e.resize((int) (e.width/resize_factor), (int) (e.height/resize_factor));
    }
    station3.resize((int) (station.width/resize_factor), (int) (station.height/resize_factor));
    station4.resize((int) (station.width/resize_factor), (int) (station.height/resize_factor));
    station.resize((int) (station.width/resize_factor), (int) (station.height/resize_factor));
    cabine.resize((int) (cabine.width/resize_factor), (int) (cabine.height/resize_factor));
    cabine_idle.resize((int) (cabine_idle.width/resize_factor), (int) (cabine_idle.height/resize_factor));
  }
  bg.resize(width, height);
  fg.resize(width, height);
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
  try {
    current.walk(x-current.anim_size/3, current.station.y2-current.img.height, dir, sprite_size/3, sprite_size/3);
  }
  catch(Exception e) {
    current.walk(x-current.anim_size/3, current.cabine.position.y2-current.img.height, dir, sprite_size/3, sprite_size/3);
  }
  for (Station s : StationsSet) {
    if (current.atStation(s)) {
      return queue(x-current.anim_size/3, ++iter, queue);
    }
  }
  return queue(x-current.anim_size/3, ++iter, queue);
}



void mousePressed() {

  println(mouseX, mouseY);
  //C2.set(mouseX, mouseY);
  // set actioin to add_person_button
  if (move_a_station.in())
    move_station =!move_station;
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
      if (s.bubble.pop_up_elements.get(4).in()) {
        for (Station station : StationsSet) {
          if (station.persons.contains(s)) {
            rm_from = station;
            to_remove = s;
          }
        }
      }
      if (rm_from == null) {
        for (Cabine cabine : CabineSet) {
          if (cabine.persons.contains(s)) {
            rm_from = cabine;
            break;
          }
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
        s.bubble.text = s.toString();
      }
    }
  }
  if (move_station && !C1.animation && !C2.animation) {
    for (Station s : StationsSet) {
      if (moving != null) {
        moving.set(mouseX, mouseY-station.height, mouseX+station.width, mouseY);
        for (Personne p : moving.persons)
          p.set(moving.portePos()[0], moving.portePos()[1]-p.anim_size);
        if (moving.cabine != null)
          moving.cabine.set(moving.cabinePos()[0], moving.cabinePos()[1]);
        moving =null;
        break;
      }

      if ((s.cabine == null || !s.cabine.hitbox.in() ) && s.in()) {
        moving = s;
        break;
      }
    }
  } else {
    moving = null;
  }

  if (rm_from != null) {
    try {
      Station rm_s = (Station) rm_from;
      rm_s.persons.remove(to_remove);
    }
    catch(Exception e ) {
      Cabine rm_c = (Cabine) rm_from;
      rm_c.persons.remove(to_remove);
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
    if (c.bubble.pop_up_elements.get(1).in() && !C1.animation && !C2.animation) {
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
    if (c.bubble.pop_up_elements.get(2).in() && !c.animation) {
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
    if (c.hitbox.in())
      c.bubble.text = c.toString();
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
  //fill(100, 0, 0);

  //rect(0, A.y2 - A.img.height*0.06, width, A.img.height*0.07);
  //rect(0, B.y2 - B.img.height*0.06, width, B.img.height*0.07);
  //rect(0, C.y2 - C.img.height*0.06, width, C.img.height*0.07);
  //fill(255, 155, 0);

  A.draw();
  B.draw();
  C.draw();


  //ForeGround
  for (Station s : StationsSet) {
    //animation pour aller dans la file de la station
    s.iter = queue(s.portePos()[0], s.iter, s.persons);
    //animation pour se diriger à la station
    s.jter = queue(s.portePos()[0], s.jter, s.enterers);
  }

  //UI

  for (Cabine c : CabineSet) {
    for (Personne p : c.persons) {
      p.set(c.personsPosition(p), c.y-c.anim_size*0.03);
      p.idle.anime(1);
    }
    c.walk(c.position);
    if (!c.animation) {
      image(station3, c.position.x1, c.position.y1);
    }
  }
  drawCable();
  image(station4, A.x1, A.y1);
  image(station4, B.x1, B.y1);
  image(station4, C.x1, C.y1);
  for (Cabine c : CabineSet) {

    if (c.bubble.text != "") {
      c.bubble.draw(15);
      c.bubble.show_pop_up = true;
      for (UI e : c.bubble.pop_up_elements) {
        e.clickable = true;
      }
    }

    if (c.bubble.show_pop_up) {
      c.bubble.popUpMenu();
    }
  }


  for (Cabine n : CabineSet) {
    if (to_remove != null && n.persons.contains(to_remove)) {
      n.dismount(to_remove);
      to_remove.y = to_remove.station.portePos()[1]-to_remove.img.height;
      to_remove.x = to_remove.station.portePos()[0]-to_remove.anim_size/3;
      if (to_remove.titre == Titre_de_transport.None)
        to_remove.setSprite(sprites.get(0), sprites.get(1));
      to_remove = null;
    }
  }
  for (Station s : StationsSet) {
    for (Personne current : s.persons) {
      if (current.bubble.text != "") {
        current.bubble.draw(15);
        current.bubble.show_pop_up = true;
        current.hitbox.clickable = false;
        for (UI e : current.bubble.pop_up_elements) {
          e.clickable = true;
        }
      }
      if (current.bubble.show_pop_up) {
        current.bubble.popUpMenu();
      }
    }
  }

  if (moving !=null && move_station) {
    station_is_moving.text =String.format("you are moving the station %c", moving.Id);
    station_is_moving.set(mouseX+10, mouseY, 0, mouseY+20);
    station_is_moving.draw(10);
  }

  add_person_button.draw(20);
  debug.draw(20);
  move_a_station.text = String.format("Move stations to another location : %b", move_station);
  move_a_station.draw(20);
  image(fg, 0, 0);
  /* --------------------- DEBUG MODE --------------------- */

  if (debug_mode) {
    noFill();
    stroke(0, 200, 0);
    strokeWeight(10);

    for (Station s : StationsSet) {
      s.draw(1);
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
    noStroke();
    fill(255, 155, 0);
  }

  /* ------------------------------------------------------ */
}
// selection de l'action en faisant des randoms sur si la précondition est vérifiée ou pas dans une liste précise et pas tous pour ne pas perdre des ressources inutillements
