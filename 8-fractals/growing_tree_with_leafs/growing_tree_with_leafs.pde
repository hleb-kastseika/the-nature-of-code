class Branch {
    PVector start;
    PVector end;
    PVector vel;
    float timer;
    float timerstart;
    boolean growing = true;

    Branch(PVector l, PVector v, float n) {
        start = l.copy();
        end = l.copy();
        vel = v.copy();
        timerstart = n;
        timer = timerstart;
    }

    void update() {
        if (growing) {
            end.add(vel);
        }
    }

    void render() {
        stroke(0);
        line(start.x, start.y, end.x, end.y);
    }

    boolean timeToBranch() {
        timer--;
        if (timer < 0 && growing) {
            growing = false;
            return true;
        } else {
            return false;
        }
    }

    Branch branch(float angle) {
        float theta = vel.heading2D();
        float mag = vel.mag();
        theta += radians(angle);
        PVector newvel = new PVector(mag * cos(theta), mag *sin(theta));
        return new Branch(end, newvel, timerstart * 0.66f);
    }
}

class Leaf {
    PVector loc;

    Leaf(PVector l) {
        loc = l.copy();
    }

    void display() {
        noStroke();
        fill(50, 100);
        ellipse(loc.x, loc.y, 4, 4);   
    }
}

ArrayList<Branch> tree;
ArrayList<Leaf> leaves;

void setup() {
    size(200, 200);
    background(255);
    smooth();

    tree = new ArrayList<Branch>();
    leaves = new ArrayList<Leaf>();
    Branch b = new Branch(new PVector(width / 2, height), new PVector(0, -0.5), 100);
    tree.add(b);
}

void draw() {
    background(255);
    for (int i = tree.size() - 1; i >= 0; i--) {
        Branch b = tree.get(i);
        b.update();
        b.render();
        if (b.timeToBranch()) {
            if (tree.size() < 1024) {
                tree.add(b.branch( 30));
                tree.add(b.branch(-25));
            } else {
                leaves.add(new Leaf(b.end));
            }
        }
    }
  
    for (Leaf leaf : leaves) {
        leaf.display(); 
    }
}
