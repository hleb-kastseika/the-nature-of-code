class Oscillator {
    float theta;
    float amplitude;

    Oscillator(float r) {
        theta = 0;
        amplitude = r;
    }

    void update(float thetaVel) {
        theta += thetaVel;
    }

    void display() {
        float x = map(cos(theta), -1, 1, 0, amplitude);
        stroke(0);
        fill(50);
        line(0, 0, x, 0);
        ellipse(x, 0, 8, 8);
    }
}

class Crawler {
    PVector loc;
    PVector vel;
    PVector acc;
    float mass;
    Oscillator osc;
    
    Crawler() {
        acc = new PVector();
        vel = new PVector(random(-1, 1), random(-1, 1));
        loc = new PVector(random(width), random(height));
        mass = random(8, 16);
        osc = new Oscillator(mass * 2);
    }
  
    void applyForce(PVector force) {
        PVector f = force.copy();  
        f.div(mass);
        acc.add(f);
    }

    void update() {
        vel.add(acc);
        loc.add(vel);
        
        acc.mult(0);
        
        osc.update(vel.mag() / 10);
    }
  
    void display() {
        float angle = vel.heading2D();
        pushMatrix();
        translate(loc.x,loc.y);
        rotate(angle);
        ellipseMode(CENTER);
        stroke(0);
        fill(175, 100);
        ellipse(0, 0, mass * 2, mass * 2);
        
        osc.display();
        popMatrix();
    }
}

class Attractor {
    float mass;
    float G;
    PVector loc;
    boolean dragging = false;
    boolean rollover = false;
    PVector drag;
    
    Attractor(PVector l_,float m_, float g_) {
        loc = l_.copy();
        mass = m_;
        G = g_;
        drag = new PVector(0.0, 0.0);
    }

    void go() {
        render();
        drag();
    }

    PVector attract(Crawler c) {
        PVector dir = PVector.sub(loc, c.loc);
        float d = dir.mag();
        d = constrain(d, 5.0, 25.0);
        dir.normalize();
        float force = (G * mass * c.mass) / (d * d);
        dir.mult(force);
        return dir;
    }

    void render() {
        ellipseMode(CENTER);
        stroke(0, 100);
        if (dragging) fill (50);
        else if (rollover) fill(100);
        else fill(175, 50);
        ellipse(loc.x, loc.y, mass * 2, mass * 2);
    }

    void clicked(int mx, int my) {
        float d = dist(mx, my, loc.x, loc.y);
        if (d < mass) {
            dragging = true;
            drag.x = loc.x - mx;
            drag.y = loc.y - my;
        }
    }

    void rollover(int mx, int my) {
        float d = dist(mx, my, loc.x, loc.y);
        if (d < mass) {
            rollover = true;
        } else {
            rollover = false;
        }
    }

    void stopDragging() {
        dragging = false;
    }

    void drag() {
        if (dragging) {
            loc.x = mouseX + drag.x;
            loc.y = mouseY + drag.y;
        }
    }
}

Crawler[] crawlers = new Crawler[6];
Attractor a;

void setup() {
    size(640, 360);
    smooth();

    for (int i = 0; i < crawlers.length; i++) {
        crawlers[i] = new Crawler();
    }
    a = new Attractor(new PVector(width / 2, height / 2), 20, 0.4);
}

void draw() {
    background(255);
    a.rollover(mouseX, mouseY);
    a.go();

    for (int i = 0; i < crawlers.length; i++) {
        PVector f = a.attract(crawlers[i]);
        crawlers[i].applyForce(f);
        crawlers[i].update();
        crawlers[i].display();
    }
}

void mousePressed() {
    a.clicked(mouseX, mouseY);
}

void mouseReleased() {
    a.stopDragging();
}
