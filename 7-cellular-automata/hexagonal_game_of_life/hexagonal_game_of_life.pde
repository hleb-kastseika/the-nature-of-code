class GOL {
    float w = 20;
    float h = sin(radians(60)) * w;
     int columns, rows;  
     Cell[][] board;

    GOL() {
        columns = width / int(w * 3);
        rows = height / int(h);
        board = new Cell[columns][rows];
        init();
    }

    void init() {
        float h = sin(radians(60)) * w;
        for (int i = 0; i < columns; i++) {
            for (int j = 0; j < rows; j++) {
                if (j % 2 == 0) board[i][j] = new Cell(i * w * 3, j * h, w);
                else board[i][j] = new Cell(i * w * 3 + w + h / 2, j * h, w);
            }
        }
    }

    void display() {
        for ( int i = 0; i < columns; i++) {
            for ( int j = 0; j < rows; j++) {
                board[i][j].display();
            }
        }
    }
}

class Cell {
    float x, y;
    float w;
    float xoff;
    float yoff;  
    int state;
  
    Cell(float x_, float y_, float w_) {
        x = x_;
        y = y_;
        w = w_;
        xoff = w / 2;
        yoff = sin(radians(60)) * w;
        state = int(random(2));
    }

    void display() {
        fill(state * 255);
        stroke(0);
        pushMatrix();
        translate(x, y);
        beginShape();
        vertex(0, yoff);
        vertex(xoff, 0);
        vertex(xoff + w, 0);
        vertex(2 * w, yoff);
        vertex(xoff + w, 2 * yoff);
        vertex(xoff, 2 * yoff);
        vertex(0, yoff);
        endShape();
        popMatrix();
    }
}

GOL gol;

void setup() {
    size(800, 200);
    frameRate(5);
    smooth();
    gol = new GOL();
}

void draw() {
    background(255);
    gol.init();
    gol.display();
}
