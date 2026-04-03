import java.util.List;
import java.util.Arrays;

ArrayList<PImage> sprites = new ArrayList<PImage>();
ArrayList<Personne> enterer = new ArrayList<Personne>();


UI add_person_button, debug;
PImage bg, station, cabine, cabine_idle;


int iter_on_enterer = 0;
int sprite_size = 0;
int resize_factor = 1;
// logique métier
Cabine C1, C2;
Building A, B, C;
Cabine cabine1;




void setup() {
  // size and bg size must be equals
  pixelDensity(1);
  size(1024, 768);
  frameRate(30);
  //fullScreen();


  // initialisation des sprites
  sprites.add(loadImage("assets/P1/Walk.png"));
  sprites.add(loadImage("assets/P1/Idle.png"));
  sprites.add(loadImage("assets/P2/Walk.png"));
  sprites.add(loadImage("assets/P2/Idle.png"));
  sprites.add(loadImage("assets/P3/Walk.png"));
  sprites.add(loadImage("assets/P3/Idle.png"));


  bg = loadImage("assets/nature_3/origbig.png");
  station = loadImage("assets/nature_3/Stations.png");
  cabine = loadImage("assets/téléphérique/cabine-Sheet.png");
  cabine_idle = loadImage("assets/téléphérique/cabine1.png");


  /* initialize work logic */
  //create cabines and stations
  C1 = new Cabine('1', cabine, 128);
  C2 = new Cabine('2', cabine, 128);
  C1.x = 132;
  C1.y = 312;
  A = new Building('A', C1);
  B = new Building('B', C2);
  C = new Building('C', null);

  //cabine configuration
  C1.position = A;
  C2.position = A;
  C1.idle = new Sprite(cabine_idle, 128);
  C2.idle = new Sprite(cabine_idle, 128);
  A.img = station;



  //resizing

  if (resize_factor > 1) {
    for (PImage e : sprites) {
      print(e);
      e.resize((e.width/resize_factor), (e.height/resize_factor));
    }
    A.img.resize((width/resize_factor), (height/resize_factor));
  }


  // fix positions
  A.set(station, width-station.width, height-station.height);

  bg.resize(width, height);


  sprite_size = sprites.get(0).height;
  add_person_button = new UI(10, 130, 30, 150, "Ajouter une personne");
  debug = new UI(10, 160, 30, 180, "assign me anything");
}

int queue(int x, int iter, ArrayList<Personne> queue) {
  if (iter == queue.size()) {
    return 0;
  }
  Personne current = queue.get(iter);
  current.walk(x, current.y, 1, sprite_size/3, 0);
  if (enterer.contains(current) && current.atStation(A)) {

    A.persons.add(current);
    C1.mount(current);
    enterer.remove(current  );
    iter--;
  }
  return queue(x-current.anim_size/3, ++iter, queue);
}



void mousePressed() {

  //println(mouseX, mouseY);
  // set actioin to add_person_button
  if (add_person_button.in()) {
    //add sprite
    A.persons.add(new Personne(sprites.get(0), sprite_size, "", null, A));
    A.persons.get(A.persons.size()-1).idle = new Sprite(sprites.get(1), sprite_size);
    A.persons.get(A.persons.size()-1).x = -sprite_size;
    A.persons.get(A.persons.size()-1).y = height-A.persons.get((A.persons.size()-1)).img.height;
    A.persons.get(A.persons.size()-1).bubble.initAction();
    A.persons.get(A.persons.size()-1).step_size =  (A.persons.get(A.persons.size()-1).step_size/resize_factor) +2;
  }
  Iterator<Personne> it = A.persons.iterator();
  while (it.hasNext()) {
    Personne s = it.next();
    //action to button
    if (s.bubble.pop_up_elements.get(0).in()) {
      s.buy(Titre_de_transport.Ticket);
    }
    if (s.bubble.pop_up_elements.get(1).in()) {
      s.buy(Titre_de_transport.Subscription);
    }
    if (s.bubble.pop_up_elements.get(2).in()) {
      s.shred();
    }
    if (s.bubble.pop_up_elements.get(3).in()) {
      enterer.add(s);
      it.remove();
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
  if (debug.in()) {
    println(A);
    println(C1);
  }
}

//draw function
void draw() {
  //Background
  image(bg, 0, 0);
  A.draw();


  //ForeGround
  //faire la file
  A.iter = queue(width-A.width+A.width/6, A.iter, A.persons);
  iter_on_enterer = queue(width-A.width+A.width/6, iter_on_enterer, enterer);


  //UI
  add_person_button.draw(20);
  debug.draw(20);
  for (Personne s : A.persons) {
    //show information bubble
    s.bubble.draw(15);
    // show action menu
    if (s.bubble.show_pop_up) {
      s.bubble.popUpMenu();
    }
  }
  C1.anime(1);
}
// selection de l'action en faisant des randoms sur si la précondition est vérifiée ou pas dans une liste précise et pas tous pour ne pas perdre des ressources inutillements
