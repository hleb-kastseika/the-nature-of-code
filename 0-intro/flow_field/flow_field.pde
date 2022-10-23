class FlowField {
    PVector[][] field;
    int cols, rows;
    int resolution;

    FlowField(int r) {
        resolution = r;
        cols = width / resolution;
        rows = height / resolution;
        field = new PVector[cols][rows];
        init();
    }

    void init() {
        noiseSeed((int) random(10000));
        float xoff = 0;
        for (int i = 0; i < cols; i++) {
            float yoff = 0;
            for (int j = 0; j < rows; j++) {
                float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
                field[i][j] = new PVector(cos(theta), sin(theta));
                yoff += 0.1;
            }
            xoff += 0.1;
        }
    }

    void display() {
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                drawVector(field[i][j], i * resolution, j * resolution, resolution - 2);
            }
        }
    }

    void drawVector(PVector v, float x, float y, float scayl) {
        pushMatrix();
        float arrowsize = 4;
        translate(x, y);
        stroke(0, 100);
        rotate(v.heading2D());
        float len = v.mag() * scayl;
        line(0, 0, len, 0);
        popMatrix();
    }

    PVector lookup(PVector lookup) {
        int column = int(constrain(lookup.x / resolution, 0, cols - 1));
        int row = int(constrain(lookup.y / resolution, 0, rows - 1));
        return field[column][row].copy();
    }
}

class Vehicle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;
    float maxspeed;

    Vehicle(PVector l, float ms, float mf) {
        location = l.copy();
        r = 3.0;
        maxspeed = ms;
        maxforce = mf;
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
    }

    public void run() {
        update();
        borders();
        display();
    }

    void follow(FlowField flow) {
        PVector desired = flow.lookup(location);
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce);
        applyForce(steer);
    }

    void applyForce(PVector force) {
        acceleration.add(force);
    }

    void update() {
        velocity.add(acceleration);
        velocity.limit(maxspeed);
        location.add(velocity);
        acceleration.mult(0);
    }

    void display() {
        float theta = velocity.heading2D() + radians(90);
        fill(175);
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

    void borders() {
        if (location.x < -r) location.x = width + r;
        if (location.y < -r) location.y = height + r;
        if (location.x > width + r) location.x = -r;
        if (location.y > height + r) location.y = -r;
    }
}

boolean debug = true;
FlowField flowfield;
ArrayList<Vehicle> vehicles;

void setup() {
    size(380, 200);
    smooth();
    flowfield = new FlowField(20);
    vehicles = new ArrayList<Vehicle>();
    for (int i = 0; i < 120; i++) {
        vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(2, 5), random(0.1, 0.5)));
    }
}

void draw() {
    background(255);
    if (debug) flowfield.display();
    for (Vehicle v : vehicles) {
        v.follow(flowfield);
        v.run();
    }

    fill(0);
}

void keyPressed() {
    if (key == ' ') {
        debug = !debug;
    }
}

void mousePressed() {
    flowfield.init();
}
