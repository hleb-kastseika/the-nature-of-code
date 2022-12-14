class Spaceship { 
    PVector location;
    PVector velocity;
    PVector acceleration;

    float damping = 0.995;
    float topspeed = 6;

    float heading = 0;

    float r = 16;

    boolean thrusting = false;

    Spaceship() {
        location = new PVector(width / 2, height / 2);
        velocity = new PVector();
        acceleration = new PVector();
    } 

    void update() { 
        velocity.add(acceleration);
        velocity.mult(damping);
        velocity.limit(topspeed);
        location.add(velocity);
        acceleration.mult(0);
    }

    void applyForce(PVector force) {
        PVector f = force.copy();
        acceleration.add(f);
    }

    void turn(float a) {
        heading += a;
    }
  
    void thrust() {
        float angle = heading - PI / 2;
        PVector force = new PVector(cos(angle), sin(angle));
        force.mult(0.1);
        applyForce(force); 
        thrusting = true;
    }

    void wrapEdges() {
        float buffer = r * 2;
        if (location.x > width + buffer) location.x = -buffer;
        else if (location.x < -buffer) location.x = width + buffer;
        if (location.y > height + buffer) location.y = -buffer;
        else if (location.y < -buffer) location.y = height + buffer;
    }

    void display() { 
        stroke(0);
        strokeWeight(2);
        pushMatrix();
        translate(location.x, location.y + r);
        rotate(heading);
        fill(175);
        if (thrusting) fill(255, 0, 0);

        rect(-r / 2, r, r / 3, r / 2);
        rect(r / 2, r, r / 3, r / 2);
        fill(175);

        beginShape();
        vertex(-r, r);
        vertex(0, -r);
        vertex(r, r);
        endShape(CLOSE);
        rectMode(CENTER);
        popMatrix();
        
        thrusting = false;
    }
}

Spaceship ship;

void setup() {
    size(750, 200);
    smooth();
    ship = new Spaceship();
}

void draw() {
    background(255); 
  
    ship.update();
    ship.wrapEdges();
    ship.display();

    fill(0);
    text("left right arrows to turn, z to thrust", 10, height - 5);

    if (keyPressed) {
        if (key == CODED && keyCode == LEFT) {
            ship.turn(-0.03);
        } else if (key == CODED && keyCode == RIGHT) {
            ship.turn(0.03);
        } else if (key == 'z' || key == 'Z') {
            ship.thrust(); 
        }
    }
}
