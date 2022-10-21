class Mover {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float topspeed;
    int radius;

    Mover() {
        location = new PVector(random(width), random(height));
        velocity = new PVector(0, 0);
        topspeed = 10;
        radius = 20;
    }

    void update() {
        PVector mouse = new PVector(mouseX, mouseY);
        PVector dir = PVector.sub(mouse, location);
        dir.normalize();
        dir.mult(0.5);
        acceleration = dir;
        velocity.add(acceleration);
        velocity.limit(topspeed);
        location.add(velocity);
    }

    void display() {
        stroke(0);
        fill(175);
        ellipse(location.x, location.y, radius * 2, radius * 2);
    }
    
    void checkEdges() {
        if (location.x <= radius || location.x >= width - radius) {
            velocity.x = velocity.x * -1;
        }
        if (location.y <= radius|| location.y >= height - radius) {
            velocity.y = velocity.y * -1;
        }
    }
}

Mover[] movers = new Mover[20];

void setup() {
    size(800, 800);
    background(255);
    for (int i = 0; i < movers.length; i++) {
        movers[i] = new Mover();
    }
}

void draw() {
    background(255);
    for (int i = 0; i < movers.length; i++) {
        movers[i].update();
        movers[i].checkEdges();
        movers[i].display();
    }
}
