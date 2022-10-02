class Walker {
    int x;
    int y;
    
    Walker() {
        x = width / 2;
        y = height / 2;
    }
    
    void step() {
        int choice = int(random(4));
        if (choice == 0) {
            x = x + 2;
        } else if (choice == 1) {
            x = x - 2;
        } else if (choice == 2) {
            y = y + 2;
        } else {
            y = y - 2;
        }
    }
    
    void display() {
        stroke(0);
        point(x, y);
    }
}

Walker w;

void setup() {
    size(800, 800);
    w = new Walker();
    background(255);
}

void draw() {
    w.step();
    w.display();
}
