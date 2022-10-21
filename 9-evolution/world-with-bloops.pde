class Bloop {
    PVector location;
    DNA dna;
    float health;
    float xoff;
    float yoff;
    float r;
    float maxspeed;

    Bloop(PVector l, DNA dna_) {
        location = l.copy();
        health = 200;
        xoff = random(1000);
        yoff = random(1000);
        dna = dna_;
        maxspeed = map(dna.genes[0], 0, 1, 15, 0);
        r = map(dna.genes[0], 0, 1, 0, 50);
    }

    void run() {
        update();
        borders();
        display();
    }

    void eat(Food f) {
        ArrayList<PVector> food = f.getFood();
        for (int i = food.size()-1; i >= 0; i--) {
            PVector foodLocation = food.get(i);
            float d = PVector.dist(location, foodLocation);
            if (d < r/2) {
                health += 100; 
                food.remove(i);
            }
        }
    }

    Bloop reproduce() {
        if (random(1) < 0.0005) {
            DNA childDNA = dna.copy();
            childDNA.mutate(0.01);
            return new Bloop(location, childDNA);
        } else {
            return null;
        }
    }

    void update() {
        float vx = map(noise(xoff), 0, 1, -maxspeed, maxspeed);
        float vy = map(noise(yoff), 0, 1, -maxspeed, maxspeed);
        PVector velocity = new PVector(vx,vy);
        xoff += 0.01;
        yoff += 0.01;

        location.add(velocity);
        health -= 0.2;
    }

    void borders() {
        if (location.x < -r) location.x = width + r;
        if (location.y < -r) location.y = height+r;
        if (location.x > width + r) location.x = -r;
        if (location.y > height + r) location.y = -r;
    }

    void display() {
        ellipseMode(CENTER);
        stroke(0, health);
        fill(0, health);
        ellipse(location.x, location.y, r, r);
    }

    boolean dead() {
        if (health < 0.0) {
            return true;
        } else {
            return false;
        }
    }
}

class DNA {
    float[] genes;
  
    DNA() {
        genes = new float[1];
        for (int i = 0; i < genes.length; i++) {
            genes[i] = random(0, 1);
        }
    }
  
    DNA(float[] newgenes) {
        genes = newgenes;
    }
  
    DNA copy() {
        float[] newgenes = new float[genes.length];
        for (int i = 0; i < newgenes.length; i++) {
            newgenes[i] = genes[i];
        }
        return new DNA(newgenes);
    }
  
    void mutate(float m) {
        for (int i = 0; i < genes.length; i++) {
            if (random(1) < m) {
                 genes[i] = random(0, 1);
            }
        }
    }
}

class Food {
    ArrayList<PVector> food;
 
    Food(int num) {
        food = new ArrayList();
        for (int i = 0; i < num; i++) {
            food.add(new PVector(random(width), random(height))); 
        }
    } 

    void add(PVector l) {
        food.add(l.copy()); 
    }
  
    void run() {
        for (PVector f: food) {
            rectMode(CENTER);
            stroke(0);
            fill(175);
            rect(f.x, f.y, 8, 8);
        } 
    
        if (random(1) < 0.001) {
            food.add(new PVector(random(width), random(height))); 
        }
    }
  
    ArrayList getFood() {
        return food; 
    }
}

class World {
    ArrayList<Bloop> bloops;
    Food food;

    World(int num) {
        food = new Food(num);
        bloops = new ArrayList<Bloop>();
        for (int i = 0; i < num; i++) {
            PVector l = new PVector(random(width), random(height));
            DNA dna = new DNA();
            bloops.add(new Bloop(l,dna));
        }
    }

    void born(float x, float y) {
        PVector l = new PVector(x, y);
        DNA dna = new DNA();
        bloops.add(new Bloop(l, dna));
    }

    void run() {
        food.run();
    
        for (int i = bloops.size() - 1; i >= 0; i--) {
            Bloop b = bloops.get(i);
            b.run();
            b.eat(food);
            if (b.dead()) {
                bloops.remove(i);
                food.add(b.location);
            }
            Bloop child = b.reproduce();
            if (child != null) bloops.add(child);
        }
    }
}

World world;

void setup() {
    size(1400, 600);
    world = new World(20);
    smooth();
}

void draw() {
    background(255);
    world.run();
}

void mousePressed() {
    world.born(mouseX, mouseY); 
}

