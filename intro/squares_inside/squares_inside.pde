int width = 1600;
int height = 800;
int borderWidth = 20;
int size = 500;

void setup() {
  size(1600, 800);
  background(255);
  border();
  frameRate(20);
}

int centerX = width / 2;
int centerY = height / 2; 

int i = 0;
boolean up = true;
void draw() {
        int x1 = centerX - size / 2 + i * 20;
        int y1 = centerY - size / 2;
 
        int x2 = centerX + size / 2;
        int y2 = centerY - size / 2 + i * 20;
  
        int x3 = centerX - size / 2;
        int y3 = centerY + size / 2 - i * 20;
   
        int x4 = centerX + size / 2 - i * 20;
        int y4 = centerY + size / 2;
        
        drawRectangle(x1, y1, x2, y2, x3, y3, x4, y4);
        if (up) {
            if (i < 25){
                i++;
            } else {
                up = false;
            }           
        } else {
           if (i > 0){
                i--;
            } else {
                up = true;
            }
        }
}


void border() {
  rect(borderWidth, borderWidth, width - borderWidth * 2, height - borderWidth * 2);
}

void drawRectangle(int x1,int y1,int x2,int y2,int x3,int y3,int x4, int y4) {    
    line(x1, y1, x2, y2);
    line(x2, y2, x4, y4);
    line(x3, y3, x4, y4);
    line(x1, y1, x3, y3);
}
