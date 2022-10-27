class Mover {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float mass;

    Mover(float m, float x, float y) {
        mass = m;
        location = new PVector(x, y);
        velocity = new PVector(0, 0);
        acceleration = new PVector(0, 0);
    }

    void applyForce(PVector force) {
        PVector f = PVector.div(force, mass);
        acceleration.add(f);
    }

    void update() {
        velocity.add(acceleration);
        location.add(velocity);
        acceleration.mult(0);
    }

    void display() {
        stroke(0);
        strokeWeight(2);
        fill(0, 100);
        ellipse(location.x, location.y, mass * 24, mass * 24);
    }

    PVector attract(Mover m) {
        PVector force = PVector.sub(location, m.location);
        float distance = force.mag();
        distance = constrain(distance, 5.0, 25.0);
        force.normalize();
        float strength = (g * mass * m.mass) / (distance * distance); 
        force.mult(strength);
        return force;
    }
}


Mover[] movers = new Mover[20];
float g = 0.4;

void setup() {
    size(1500, 800);
    smooth();
    for (int i = 0; i < movers.length; i++) {
        movers[i] = new Mover(random(0.1, 2), random(width), random(height)); 
    }
}

void draw() {
    background(255);

    for (int i = 0; i < movers.length; i++) {
        for (int j = 0; j < movers.length; j++) {
            if (i != j) {
                PVector force = movers[j].attract(movers[i]);
                movers[i].applyForce(force);
            }
        }
        movers[i].update();
        movers[i].display();
    }
}
