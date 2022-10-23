class Path {
    ArrayList<PVector> points;
    float radius;

    Path() {
        radius = 20;
        points = new ArrayList<PVector>();
    }

    void addPoint(float x, float y) {
        PVector point = new PVector(x, y);
        points.add(point);
    }

    void display() {
        stroke(175);
        strokeWeight(radius * 2);
        noFill();
        beginShape();
        for (PVector v : points) {
            vertex(v.x, v.y);
        }
        endShape();
        stroke(0);
        strokeWeight(1);
        noFill();
        beginShape();
        for (PVector v : points) {
            vertex(v.x, v.y);
        }
        endShape();
    }
}

class Vehicle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;
    float maxspeed;

    Vehicle( PVector l, float ms, float mf) {
        location = l.copy();
        r = 4.0;
        maxspeed = ms;
        maxforce = mf;
        acceleration = new PVector(0, 0);
        velocity = new PVector(maxspeed, 0);
    }

    public void run() {
        update();
        borders();
        render();
    }

    void follow(Path p) {
       PVector predict = velocity.copy();
        predict.normalize();
        predict.mult(25);
        PVector predictLoc = PVector.add(location, predict);

        PVector normal = null;
        PVector target = null;
        float worldRecord = 1000000;
        
        for (int i = 0; i < p.points.size() - 1; i++) {
            PVector a = p.points.get(i);
            PVector b = p.points.get(i + 1);
            PVector normalPoint = getNormalPoint(predictLoc, a, b);
            if (normalPoint.x < a.x || normalPoint.x > b.x) {
                normalPoint = b.copy();
            }
            float distance = PVector.dist(predictLoc, normalPoint);
            if (distance < worldRecord) {
                worldRecord = distance;
                normal = normalPoint;
                PVector dir = PVector.sub(b, a);
                dir.normalize();
                dir.mult(10);
                target = normalPoint.copy();
                target.add(dir);
            }
        }
        if (worldRecord > p.radius) {
            seek(target);
        }

        if (debug) {
            stroke(0);
            fill(0);
            line(location.x, location.y, predictLoc.x, predictLoc.y);
            ellipse(predictLoc.x, predictLoc.y, 4, 4);
            stroke(0);
            fill(0);
            ellipse(normal.x, normal.y, 4, 4);
            line(predictLoc.x, predictLoc.y, normal.x, normal.y);
            if (worldRecord > p.radius) fill(255, 0, 0);
            noStroke();
            ellipse(target.x, target.y, 8, 8);
        }
    }

    PVector getNormalPoint(PVector p, PVector a, PVector b) {
        PVector ap = PVector.sub(p, a);
        PVector ab = PVector.sub(b, a);
        ab.normalize();
        ab.mult(ap.dot(ab));
        PVector normalPoint = PVector.add(a, ab);
        return normalPoint;
    }

    void update() {
        velocity.add(acceleration);
        velocity.limit(maxspeed);
        location.add(velocity);
        acceleration.mult(0);
    }

    void applyForce(PVector force) {
        acceleration.add(force);
    }

    void seek(PVector target) {
        PVector desired = PVector.sub(target, location);
        if (desired.mag() == 0) return;
    
        desired.normalize();
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce);
        applyForce(steer);
    }

    void render() {
        float theta = velocity.heading2D() + radians(90);
        fill(175);
        stroke(0);
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        beginShape(PConstants.TRIANGLES);
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
        endShape();
        popMatrix();
    }

    void borders() {
        if (location.x < -r) location.x = width + r;
        if (location.x > width + r) location.x = -r;
    }
}

boolean debug = true;
Path path;
Vehicle car1;
Vehicle car2;

void setup() {
    size(800, 200);
    smooth();
    newPath();

    car1 = new Vehicle(new PVector(0, height / 2), 3, 0.1);
    car2 = new Vehicle(new PVector(0, height / 2), 5, 0.2);
}

void draw() {
    background(255);
    path.display();
    car1.follow(path);
    car2.follow(path);
    car1.run();
    car2.run();

    fill(0);
    text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height - 30);
}

void newPath() {
    path = new Path();
    path.addPoint(0, height / 2);
    path.addPoint(random(0, width / 2), random(0, height));
    path.addPoint(random(width / 2, width), random(0, height));
    path.addPoint(width, height / 2);
}

public void keyPressed() {
    if (key == ' ') {
        debug = !debug;
    }
}

public void mousePressed() {
    newPath();
}
