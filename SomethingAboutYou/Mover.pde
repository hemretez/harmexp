class Mover {

  PVector location; 
  float mousedist;
  PVector velocity;
  float time;
  PVector acceleration;
  float mass;
  float mez;
  int playtype;
  int progtype;
  float distance;
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?
  PVector drag;  // holds the offset for when object is clicked on
  boolean played = false;
  int[] isPlayeda;
  float radius;
  int identification;
  int nOfCloseChords;
  int measure;
  int bar;
  int manybeats;
      
  OscMessage myMessage3 = new OscMessage("/");

  Mover(float m, int t, int tt, float x, float y, int meas, int br, int movernum, int howmanybts) {
    playtype = t;
    progtype = tt;
    mass = m;
    mez = 0.8; // this defines the color
    isPlayeda = new int[3];
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    drag = new PVector(0.0, 0.0);
    measure = meas;
    bar = br;
    identification = movernum;
    radius = radii;
    manybeats = howmanybts;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update(PVector dir) {
    
    distance = dist(a.location.x, a.location.y,location.x, location.y);  
    mousedist =  ( dist(mouseX, mouseY, location.x, location.y) - (radius/2) );   
    //time = ( dist(a.location.x, a.location.y,location.x, location.y) - ((radius+radius)/2) ) / mag(dir.x, dir.y);
    if (dragging == false) {

      if ( ( dist(a.location.x, a.location.y,location.x, location.y) - ((radius+radius)/2)) <= 1.0) {
        dir.mult(0);time=0;
      }
        else {
          dir.mult(velocityFactor);
          location.add(dir);
        }
      if (played==true){time=0;}
    }
  }

  void display(PVector dir) {

    distance = dist(a.location.x, a.location.y,location.x, location.y); 
    time = ( dist(a.location.x, a.location.y,location.x, location.y) - ((radius+radius)/2) ) / mag(dir.x, dir.y); 
    noStroke();
    colorMode(HSB, 12);
    
    if (dragging) fill(playtype%12,  5+7*mass, 11, 10);
    else if (rollover) fill(playtype%12,  5+7*mass, 11, 7);
    else fill(playtype%12, 5+7*mass, 11, 5);
    ellipse(location.x, location.y, radius, radius);
  }

  int[] playit() {

    isPlayeda[0] = 0;
    isPlayeda[1] = playtype;
    isPlayeda[2] = progtype;
    
    distance = dist(a.location.x, a.location.y,location.x, location.y);
    if ( (distance) - (radius+radius)/2 <= 1.0)  {
      //println(identification," frameC: ", frameCount, " %fC: ", (frameCount%30)  );
      velocity = new PVector(0, 0); }
    if (((distance) - (radius+radius)/2 <= 1.0) && (frameCount%tick == 0)) {
      //mass = 0.1;
      time = 0.1;
      played = true;
      
      nChordsPlayed++;
      //println(identification+ "  is played? "+ played +"  " + frameCount);
      //sthUserOnlyChords.println(float(frameCount)+ " " + playtype+ " " + progtype+ " " + mass+ " " +a.posX + " " +a.posY + " " + whichArea );
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      isPlayeda[0] = 1;
      isPlayeda[1] = playtype;
      myMessage3.clearArguments(); 
      myMessage3.add(new float[] {playtype});
      oscP5.send(myMessage3, myRemoteLocation);
    }
    return isPlayeda;
  }

  void checkEdges() {
    if ((location.x > width) || (location.x < 0)) {
      velocity.x = velocity.x * -1;
    }
    if ((location.y > height) || (location.y < 0)) {
      velocity.y = velocity.y * -1;
    }
  }

  // The methods below are for mouse interaction
  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < radius/2 ) {
      locked = identification;
      dragging = true;
      drag.x = location.x-mx;
      drag.y = location.y-my;
    }
  }

  void hover(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < radius/2) {
      rollover = true;
    } 
    else {
      rollover = false;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag() {
    if (dragging) {
      location.x = mouseX + drag.x;
      location.y = mouseY + drag.y;
    }
  }
}

