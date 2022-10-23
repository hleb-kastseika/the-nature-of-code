class Vehicle {
    ArrayList<PVector> history = new ArrayList<PVector>();
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxspeed;
    float maxforce;
  
    Vehicle(float x, float y) {
        acceleration = new PVector(0, 0);
        velocity = new PVector(3, -2);
        velocity.mult(5);
        location = new PVector(x, y);
        r = 6;
        maxspeed = 3;
        maxforce = 0.15;
    }

    void run() {
        update();
        display();
    }

    void update() {
        velocity.add(acceleration);
        velocity.limit(maxspeed);
        location.add(velocity);
        acceleration.mult(0);
    
        history.add(location.copy());
        if (history.size() > 500) {
            history.remove(0);
        }
    }

    void boundaries() {
        PVector desired = null;

        if (location.x < d) {
            desired = new PVector(maxspeed, velocity.y);
        } else if (location.x > width - d) {
            desired = new PVector(-maxspeed, velocity.y);
        } 

        if (location.y < d) {
            desired = new PVector(velocity.x, maxspeed);
        }  else if (location.y > height - d) {
            desired = new PVector(velocity.x, -maxspeed);
        } 

        if (desired != null) {
            desired.normalize();
            desired.mult(maxspeed);
            PVector steer = PVector.sub(desired, velocity);
            steer.limit(maxforce);
            applyForce(steer);
        }
    }  

    void applyForce(PVector force) {
        acceleration.add(force);
    }

    void display() {
        beginShape();
        stroke(0);
        strokeWeight(1);
        noFill();
        for(PVector v: history) {
            vertex(v.x, v.y);
        }
        endShape();
    
        float theta = velocity.heading2D() + radians(90);
        fill(127);
        stroke(0);
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        beginShape(TRIANGLES);
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
        endShape();
        popMatrix();
    }
}

Vehicle v;
boolean debug = true;
float d = 25;

void setup() {
    size(800, 200);
    v = new Vehicle(width / 2, height / 2);
    smooth();
}

void draw() {
    background(255);

    if (debug) {
        stroke(175);
        noFill();
        rectMode(CENTER);
        rect(width / 2, height / 2, width - d * 2, height - d * 2);
    }
    v.boundaries();
    v.run();
}

void mousePressed() {
   debug = !debug;
}
