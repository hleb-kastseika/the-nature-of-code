class Branch {
    PVector loc;
    PVector vel;
    float timer;
    float timerstart;

    Branch(PVector l, PVector v, float n) {
        loc = l.copy();
        vel = v.copy();
        timerstart = n;
        timer = timerstart;
    }
  
    void update() {
        loc.add(vel);
    }
  
    void render() {
        fill(0);
        noStroke();
        ellipseMode(CENTER);
        ellipse(loc.x, loc.y, 2, 2);
    }
  
    boolean timeToBranch() {
        timer--;
        if (timer < 0) {
            return true;
        } else {
            return false;
        }
    }

    Branch branch(float angle) {
        float theta = vel.heading2D();
        float mag = vel.mag();
        theta += radians(angle);
        PVector newvel = new PVector(mag * cos(theta), mag * sin(theta));
        return new Branch(loc,newvel,timerstart*0.66f);
    }
}

ArrayList<Branch> tree;

void setup() {
    size(200, 200);
    background(255);
    smooth();
    tree = new ArrayList();
    Branch b = new Branch(new PVector(width / 2, height), new PVector(0, -0.5), 100);
    tree.add(b);
}

void draw() {
    if (tree.size() < 1024) {
        for (int i = tree.size() - 1; i >= 0; i--) {
            Branch b = tree.get(i);
            b.update();
            b.render();
            if (b.timeToBranch()) {
                tree.remove(i);
                tree.add(b.branch( 30));
                tree.add(b.branch(-25));
            }
        }
    }
}
