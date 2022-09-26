class Mover {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float mass;
    float G = 0.4;

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
        fill(175);
        ellipse(location.x,location.y,mass*16,mass*16);
    }

    void checkEdges() {
        if (location.x > width) {
            location.x = width;
            velocity.x *= -1;
        } else if (location.x < 0) {
            velocity.x *= -1;
            location.x = 0;
        }
        if (location.y > height) {
            velocity.y *= -1;
            location.y = height;
        }
    }
    
    PVector attract(Mover m) {
        PVector force = PVector.sub(location, m.location);
        float distance = force.mag();
        distance = constrain(distance, 5.0, 25.0);
        force.normalize();

        float strength = (G * mass * m.mass) / (distance * distance);
        force.mult(strength);
        return force;
    }
}

Mover[] movers = new Mover[20];
 
float g = 0.4;
 
void setup() {
    size(1400, 600);
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