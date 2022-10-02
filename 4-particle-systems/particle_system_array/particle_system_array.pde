import java.util.Iterator;

class Particle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float lifespan;

    Particle(PVector l) {
        acceleration = new PVector(0, 0.05);
        velocity = new PVector(random(-1, 1), random(-2, 0));
        location = l.get();
        lifespan = 255.0;
    }

    void run() {
        update();
        display();
    }

    void update() {
        velocity.add(acceleration);
        location.add(velocity);
        lifespan -= 1.0;
    }

    void display() {
        stroke(0, lifespan);
        fill(random(0, 255), random(0, 255), random(0, 255), lifespan);
        ellipse(location.x, location.y, 8, 8);
    }

    boolean isDead() {
        if (lifespan < 0.0) {
            return true;
        } else {
            return false;
        }
    }
}


class ParticleSystem {
    ArrayList<Particle> particles;
    PVector origin;


    ParticleSystem(PVector location) {
        origin = location.get();
        particles = new ArrayList();
    }

    void addParticle() {
        particles.add(new Particle(origin));
    }

    void run() {
        Iterator<Particle> it = particles.iterator();
        while (it.hasNext()) {
            Particle p = it.next();
            p.run();
            if (p.isDead()) {
                it.remove();
            }
      }
  }
}

ArrayList<ParticleSystem> systems;
void setup() {
    size(1000, 800);
    systems = new ArrayList<ParticleSystem>();
}


void draw() {
    background(255);
    for (ParticleSystem ps: systems) {
        ps.run();
        ps.addParticle();
    }
}

void mousePressed() {
    systems.add(new ParticleSystem(new PVector(mouseX, mouseY)));
}
