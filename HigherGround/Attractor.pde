class Attractor {
  float mass;    // Mass, tied to size
  float mousedist;
  PVector location;   // Location
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?
  PVector drag;  // holds the offset for when object is clicked on
  float posX=0;
  float posY=0;
  float speed;
  int type;
  OscMessage myMessage2 = new OscMessage("/");

  Attractor( int t ) {
    location = new PVector(width/2, height/2);
    type = t;
    drag = new PVector(0.0, 0.0);
  }

  PVector attract(Mover m) {
    PVector dir = PVector.sub(location, m.location);   // Calculate direction of force
    float d = dir.mag();                              // Distance between objects
    //d = constrain(d, forceLow, forceHigh);          // Limiting the distance to eliminate "extreme" results for very close or very far objects
    dir.normalize();
    PVector copydir = dir.get();    
    float strength = ( m.mass );      // Assign strength of attraction
    dir.mult(strength);              // Get force vector --> magnitude * direction
    return dir;
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);

    mousedist =  ( dist(mouseX, mouseY, location.x, location.y) - (radii/2) );
    noStroke();

    if (dragging) fill(0,0,4,10);
    else if (rollover) fill(0,0,7,10);
    else fill(0,0,12,10);
    ellipse(location.x, location.y, attractorSize, attractorSize);
    
    if (posX>(0)){whichArea = 1;}
    else if (posX<(0)){whichArea = 2;}
    
//    if (posY > 0){
//      if (posY > posX*sin(radians(60))/cos(radians(60))) {whichArea = 2;}
//      else {whichArea = 1;}
//    }
//    else {
//      if (posY > -posX*sin(radians(60))/cos(radians(60))) {whichArea = 1;}
//      else {whichArea = 3;}
//    }
       
    noFill();
    stroke(3);  
    ellipse(location.x, location.y, pulseRadius, pulseRadius);
    pulseRadius = pulseRadius + 12;
    pulseStroke = pulseStroke + 0.1;
    if (frameCount % tick == 0){
    pulseRadius = 0;
    pulseStroke = 0;}
  }

  // The methods below are for mouse interaction
  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < radii/2) {
      dragging = true;
      drag.x = location.x-mx;
      drag.y = location.y-my;      
    }
  }

  void hover(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < radii/2) {
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
      
      //location.x = mouseX + drag.x;
      //location.y = mouseY + drag.y;
//      speed = constrain(( sqrt(sq(mouseX - pmouseX) + sq(mouseY - pmouseY)) ), 0, 50);
//      println(speed);
    }
  }
}

