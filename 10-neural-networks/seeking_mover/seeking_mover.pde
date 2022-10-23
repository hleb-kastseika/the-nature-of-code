class Perceptron {
    float[] weights;
    float c;

    Perceptron(int n, float c_) {
        weights = new float[n];
        c = c_;
        for (int i = 0; i < weights.length; i++) {
            weights[i] = random(0, 1);
        }
    }

    void train(PVector[] forces, PVector error) {
        for (int i = 0; i < weights.length; i++) {
            weights[i] += c*error.x * forces[i].x;         
            weights[i] += c*error.y * forces[i].y;
            weights[i] = constrain(weights[i], 0, 1);
        }
    }

    PVector feedforward(PVector[] forces) {
        PVector sum = new PVector();
        for (int i = 0; i < weights.length; i++) {
            forces[i].mult(weights[i]);
            sum.add(forces[i]);
        }
        return sum;
    }
}

class Vehicle {
    Perceptron brain;
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;
    float maxspeed;

    Vehicle(int n, float x, float y) {
        brain = new Perceptron(n, 0.001);
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
        location = new PVector(x, y);
        r = 3.0;
        maxspeed = 4;
        maxforce = 0.1;
    }

    void update() {
        velocity.add(acceleration);
        velocity.limit(maxspeed);
        location.add(velocity);
        acceleration.mult(0);
    
        location.x = constrain(location.x, 0, width);
        location.y = constrain(location.y, 0, height);
    }

    void applyForce(PVector force) {
        acceleration.add(force);
    }
  
    void steer(ArrayList<PVector> targets) {
        PVector[] forces = new PVector[targets.size()];
    
        for (int i = 0; i < forces.length; i++) {
            forces[i] = seek(targets.get(i));
        }
    
        PVector result = brain.feedforward(forces);
    
        applyForce(result);
    
        PVector error = PVector.sub(desired, location);
        brain.train(forces,error);
    }
  
    PVector seek(PVector target) {
        PVector desired = PVector.sub(target, location);
        desired.normalize();
        desired.mult(maxspeed);
        
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce);
        return steer;
    }
    
    void display() {
        float theta = velocity.heading2D() + PI / 2;
        fill(175);
        stroke(0);
        strokeWeight(1);
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        beginShape();
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
        endShape(CLOSE);
        popMatrix();
    }
}

Vehicle v;
PVector desired;
ArrayList<PVector> targets;

void setup() {
    size(800, 200);
    smooth();
  
    desired = new PVector(width / 2, height / 2);
    makeTargets();
    v = new Vehicle(targets.size(), random(width), random(height));
}

void makeTargets() {
    targets = new ArrayList<PVector>();
    for (int i = 0; i < 8; i++) {
        targets.add(new PVector(random(width), random(height)));
    }
}

void draw() {
    background(255);

    rectMode(CENTER);
    stroke(0);
    strokeWeight(2);
    fill(0, 100);
    rect(desired.x, desired.y, 36, 36);

    for (PVector target : targets) {
        fill(0, 100);
        stroke(0);
        strokeWeight(2);
        ellipse(target.x, target.y, 30, 30);
    }
  
    v.steer(targets);
    v.update();
    v.display();
}

void mousePressed() {
    makeTargets();
}
