class GOL {
    int w = 8;
    int columns, rows;
    int[][] board;

    GOL() {
        columns = width / w;
        rows = height / w;
        board = new int[columns][rows];
        init();
    }

    void init() {
        for (int i = 1; i < columns - 1; i++) {
            for (int j =1; j < rows - 1; j++) {
                board[i][j] = int(random(2));
            }
        }
    }

    void generate() {
        int[][] next = new int[columns][rows];

        for (int x = 0; x < columns; x++) {
            for (int y = 0; y < rows; y++) {
                int neighbors = 0;
                for (int i = -1; i <= 1; i++) {
                    for (int j = -1; j <= 1; j++) {
                        neighbors += board[(x + i + columns) % columns][(y + j + rows) % rows];
                    }
                }
                neighbors -= board[x][y];

                if ((board[x][y] == 1) && (neighbors <  2)) next[x][y] = 0;
                else if ((board[x][y] == 1) && (neighbors >  3)) next[x][y] = 0;
                else if ((board[x][y] == 0) && (neighbors == 3)) next[x][y] = 1;
                else next[x][y] = board[x][y];
            }
        }
        board = next;
    }

    void display() {
        for (int i = 0; i < columns; i++) {
            for (int j = 0; j < rows; j++) {
                if ((board[i][j] == 1)) fill(0);
                else fill(255); 
                stroke(0);
                rect(i * w, j * w, w, w);
            }
        }
    }
}

GOL gol;

void setup() {
    size(400, 400);
    frameRate(5);
    smooth();
    gol = new GOL();
}

void draw() {
    background(255);
    gol.generate();
    gol.display();
}

void mousePressed() {
    gol.init();
}
