class DNA {
    PVector[] genes;
    float maxforce = 0.1;

    DNA() {
        genes = new PVector[lifetime];
        for (int i = 0; i < genes.length; i++) {
            float angle = random(TWO_PI);
            genes[i] = new PVector(cos(angle), sin(angle));
            genes[i].mult(random(0, maxforce));
        }
        genes[0].normalize();
    }
    
    DNA(PVector[] newgenes) {
        genes = newgenes;
    }
    
    DNA crossover(DNA partner) {
        PVector[] child = new PVector[genes.length];
        int crossover = int(random(genes.length));
        for (int i = 0; i < genes.length; i++) {
            if (i > crossover) {
                child[i] = genes[i];
            } else {
                child[i] = partner.genes[i];
            }
        }    
        DNA newgenes = new DNA(child);
        return newgenes;
    }

    void mutate(float m) {
        for (int i = 0; i < genes.length; i++) {
            if (random(1) < m) {
                float angle = random(TWO_PI);
                genes[i] = new PVector(cos(angle), sin(angle));
                genes[i].mult(random(0, maxforce));
                if (i ==0) {
                    genes[i].normalize();
                }
            }
        }
    }
}

class Obstacle {
    PVector location;
    float w,h;
  
    Obstacle(float x, float y, float w_, float h_) {
        location = new PVector(x, y);
        w = w_;
        h = h_;
    }

    void display() {
        stroke(0);
        fill(175);
        strokeWeight(2);
        rectMode(CORNER);
        rect(location.x, location.y, w, h);
    }

    boolean contains(PVector spot) {
        if (spot.x > location.x && spot.x < location.x + w && spot.y > location.y && spot.y < location.y + h) {
            return true;
        } else {
            return false;
        }
    }
}

class Population {
    float mutationRate;
    Rocket[] population;
    ArrayList<Rocket> matingPool;
    int generations;

    Population(float m, int num) {
        mutationRate = m;
        population = new Rocket[num];
        matingPool = new ArrayList<Rocket>();
        generations = 0;
        
        for (int i = 0; i < population.length; i++) {
            PVector location = new PVector(width / 2, height + 20);
            population[i] = new Rocket(location, new DNA(), population.length);
        }
    }

    void live(ArrayList<Obstacle> os) {
        for (int i = 0; i < population.length; i++) {
            population[i].checkTarget();
            population[i].run(os);
        }
    }

    boolean targetReached() {
        for (int i = 0; i < population.length; i++) {
            if (population[i].hitTarget) {
                return true;
            }
        }
        return false;
    }

    void fitness() {
        for (int i = 0; i < population.length; i++) {
            population[i].fitness();
        }
    }

    void selection() {
        matingPool.clear();

        float maxFitness = getMaxFitness();
        for (int i = 0; i < population.length; i++) {
            float fitnessNormal = map(population[i].getFitness(), 0, maxFitness, 0, 1);
            int n = (int) (fitnessNormal * 100);
            for (int j = 0; j < n; j++) {
                matingPool.add(population[i]);
            }
        }
    }

    void reproduction() {
        for (int i = 0; i < population.length; i++) {
            int m = int(random(matingPool.size()));
            int d = int(random(matingPool.size()));
      
            Rocket mom = matingPool.get(m);
            Rocket dad = matingPool.get(d);
            DNA momgenes = mom.getDNA();
            DNA dadgenes = dad.getDNA();
            DNA child = momgenes.crossover(dadgenes);
            child.mutate(mutationRate);
            PVector location = new PVector(width / 2, height + 20);
            population[i] = new Rocket(location, child, population.length);
        }
        generations++;
    }

    int getGenerations() {
        return generations;
    }
    
    float getMaxFitness() {
        float record = 0;
        for (int i = 0; i < population.length; i++) {
            if(population[i].getFitness() > record) {
                record = population[i].getFitness();
            }
        }
        return record;
    }
}

class Rocket {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float recordDist;
    float fitness;
    DNA dna;
    int geneCounter = 0;

    boolean hitObstacle = false;
    boolean hitTarget = false;
    int finishTime;

    Rocket(PVector l, DNA dna_, int totalRockets) {
        acceleration = new PVector();
        velocity = new PVector();
        location = l.copy();
        r = 4;
        dna = dna_;
        finishTime = 0;
        recordDist = 10000;
    }

    void fitness() {
        if (recordDist < 1) recordDist = 1;
        fitness = (1 / (finishTime * recordDist));
        fitness = pow(fitness, 4);

        if (hitObstacle) fitness *= 0.1;
        if (hitTarget) fitness *= 2;
    }

    void run(ArrayList<Obstacle> os) {
        if (!hitObstacle && !hitTarget) {
            applyForce(dna.genes[geneCounter]);
            geneCounter = (geneCounter + 1) % dna.genes.length;
            update();
            obstacles(os);
        }
    
        if (!hitObstacle) {
            display();
        }
    }

    void checkTarget() {
        float d = dist(location.x, location.y, target.location.x, target.location.y);
        if (d < recordDist) {
            recordDist = d;
        }

        if (target.contains(location) && !hitTarget) {
            hitTarget = true;
        } else if (!hitTarget) {
            finishTime++;
        }
    }

    void obstacles(ArrayList<Obstacle> os) {
        for (Obstacle obs : os) {
            if (obs.contains(location)) {
                hitObstacle = true;
            }
        }
    }

    void applyForce(PVector f) {
        acceleration.add(f);
    }

    void update() {
        velocity.add(acceleration);
        location.add(velocity);
        acceleration.mult(0);
    }

    void display() {
        float theta = velocity.heading2D() + PI / 2;
        fill(200, 100);
        stroke(0);
        strokeWeight(1);
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);

        rectMode(CENTER);
        fill(0);
        rect(-r / 2, r * 2, r / 2, r);
        rect(r / 2, r * 2, r / 2, r);
        
        fill(175);
        beginShape(TRIANGLES);
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
        endShape();

        popMatrix();
    }

    float getFitness() {
        return fitness;
    }

    DNA getDNA() {
        return dna;
    }

    boolean stopped() {
        return hitObstacle;
    }
}

int lifetime;
Population population;
int lifecycle;
int recordtime;
Obstacle target;
ArrayList<Obstacle> obstacles;

void setup() {
    size(800, 200);
    smooth();
    lifetime = 300;

    lifecycle = 0;
    recordtime = lifetime;
  
    target = new Obstacle(width / 2 - 12, 24, 24, 24);

    float mutationRate = 0.01;
    population = new Population(mutationRate, 50);

    obstacles = new ArrayList<Obstacle>();
    obstacles.add(new Obstacle(300, height / 2, width - 600, 10));
}

void draw() {
    background(255);
    
    target.display();

    if (lifecycle < lifetime) {
        population.live(obstacles);
        if ((population.targetReached()) && (lifecycle < recordtime)) {
            recordtime = lifecycle;
        }
        lifecycle++;
    } else {
        lifecycle = 0;
        population.fitness();
        population.selection();
        population.reproduction();
    }
    
    for (Obstacle obs : obstacles) {
        obs.display();
    }

    fill(0);
    text("Generation #: " + population.getGenerations(), 10, 18);
    text("Cycles left: " + (lifetime - lifecycle), 10, 36);
    text("Record cycles: " + recordtime, 10, 54);
}

void mousePressed() {
    target.location.x = mouseX;
    target.location.y = mouseY;
    recordtime = lifetime;
}
