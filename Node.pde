import processing.core.PApplet;
import processing.core.PConstants;

// The Node class represents a moving block in the game
class Node {
    float x, y;                    // Position of the node
    float speed;                   // Speed at which the node moves
    static final float SIZE = 40;  // Size of the node, using static final to make it constant
    PApplet p;                     // Reference to the PApplet instance
    int nodeCol;                   // Color of the node

    // Constructor to initialize the node
    Node(PApplet parent, float startX, float startY, float speed) {
        this.p = parent;           // Initialize PApplet reference
        this.x = startX;           // Set initial X position
        this.y = startY;           // Set initial Y position
        this.speed = speed;        // Set the speed of the node
        this.nodeCol = parent.color(222, 255, 0);  // Set default node color (yellowish)
    }

    // Method to update the node's position
    void update() {
        y += speed;  // Move the node downwards by adding speed to the Y position
    }

    // Method to display the node on the screen
    void display() {
        p.fill(nodeCol);           // Set the fill color to the node's color
        p.rectMode(PConstants.CENTER);  // Set the rectangle mode to CENTER
        p.rect(x, y, SIZE, SIZE * 2);   // Draw the node as a rectangle
    }

    // Method to check if a given point (px, py) has touched the node
    boolean isTouched(float px, float py) {
        return p.dist(px, py, x, y) < SIZE / 2;  // Return true if the distance is within the node's size
    }

    // Method to set the speed of the node
    void setSpeed(float speed) {
        this.speed = speed;
    }

    // Method to set the color of the node
    void setNodeCol(int col) {
        this.nodeCol = col;
    }

    // Method to reset the node's position and speed for reuse
    void reset(float startX, float startY, float speed) {
        this.x = startX;           // Reset X position
        this.y = startY;           // Reset Y position
        this.speed = speed;        // Reset speed
    }

    // Getter method for X position
    float getX() {
        return x;
    }

    // Getter method for Y position
    float getY() {
        return y;
    }

    // Getter method for speed
    float getSpeed() {
        return speed;
    }

    // Getter method for the size of the node
    float getSize() {
        return SIZE;
    }
}
