import processing.core.PApplet;
import processing.core.PConstants;

class Node {
    float x, y;
    float speed;
    static final float SIZE = 40; // Use static final to avoid reallocation
    PApplet p;
    int nodeCol;

    Node(PApplet parent, float startX, float startY, float speed) {
        this.p = parent;
        this.x = startX;
        this.y = startY;
        this.speed = speed;
        this.nodeCol = parent.color(222, 255, 0);
    }

    void update() {
        y += speed;
    }

    void display() {
        p.fill(nodeCol);
        p.rectMode(PConstants.CENTER);
        p.rect(x, y, SIZE, SIZE * 2);
    }

    boolean isTouched(float px, float py) {
        return p.dist(px, py, x, y) < SIZE / 2;
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
        return SIZE;
    }
}
