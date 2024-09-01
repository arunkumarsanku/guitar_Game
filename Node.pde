import processing.core.PApplet;
import processing.core.PConstants;

class Node {
    float x, y;
    float speed;
    final float size = 40;
    PApplet p;
    int nodeCol;

    Node(PApplet parent, float startX, float startY, float speed) {
        this.p = parent;
        this.x = startX;
        this.y = startY;
        this.speed = speed;
        this.nodeCol = parent.color(222, 255, 0); // Initial color
    }

    void update() {
        y += speed;
    }

    void display() {
        p.fill(nodeCol);
        p.rectMode(PConstants.CENTER);
        p.rect(x, y, size, size * 2);
    }

    void setSpeed(float speed) {
        this.speed = speed;
    }

    void setNodeCol(int col) {
        this.nodeCol = col;
    }

    void reset(float startX, float startY, float speed) {
        this.x = startX;
        this.y = startY;
        this.speed = speed;
    }

    float getX() {
        return x;
    }

    float getY() {
        return y;
    }

    float getSpeed() {
        return speed;
    }

    float getSize() {
        return size;
    }
}
