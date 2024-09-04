import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;
import processing.core.PVector;
import controlP5.ControlP5;
import SimpleOpenNI.SimpleOpenNI;

import java.util.LinkedList;
import java.util.Queue;

// The Game class handles the main game logic, including managing nodes, score, and interactions
class Game {
    PApplet p;                        // Reference to the PApplet instance
    ControlP5 cp5;                    // ControlP5 library instance for managing UI components
    Dashboard dashboard;              // Reference to the Dashboard for updating UI
    AudioManager audioManager;        // AudioManager to handle game sounds
    SummaryManager summaryManager;    // SummaryManager to display session summaries

    PImage guitarBackground;          // Background image for the game
    PImage guitarWinImage;            // Image to display when the game is won
    PFont font;                       // Font used for displaying text

    Node currentNode;                 // The current node on the screen
    PerformanceData performanceData;  // Data structure to track player performance

    Queue<Node> nodePool = new LinkedList<>();  // Pool of reusable nodes to optimize memory usage
    boolean isPaused = false;                   // Flag to check if the game is paused
    boolean isGameStarted = false;              // Flag to check if the game has started
    String gameState = "DASHBOARD";             // State of the game ("DASHBOARD", "IN_GAME", "WIN_WINDOW")
    int score = 0;                              // Current score

    float nodeSpeed = 5;                        // Speed at which nodes move
    float trackerX, trackerY;                   // Tracker position (for mouse or Kinect input)
    float cursorSize = 20;                      // Size of the cursor
    int cursorCol;                              // Color of the cursor
    int backgroundCol;                          // Background color of the game screen
    int nodeCol;                                // Color of the nodes

    boolean useKineticTracker = false;          // Flag to indicate if Kinect is used for tracking
    SimpleOpenNI kinect;                        // SimpleOpenNI instance for Kinect tracking

    // Constructor for the Game class
    Game(PApplet parent) {
        this.p = parent;                       // Initialize PApplet reference
        this.cp5 = new ControlP5(p);           // Initialize ControlP5
        this.audioManager = new AudioManager(parent);  // Initialize AudioManager
        this.font = p.createFont("Arial", 48); // Set default font
        this.cursorCol = p.color(255, 0, 0);   // Set default cursor color (red)
        this.backgroundCol = p.color(55, 47, 69); // Set background color
        this.nodeCol = p.color(222, 255, 0);   // Set default node color (yellow)
        this.summaryManager = new SummaryManager(parent, cp5, this); // Initialize SummaryManager
        
        initializeKinect(); // Attempt to initialize Kinect
    }
    
    // Method to initialize Kinect tracking
    void initializeKinect() {
        kinect = new SimpleOpenNI(p);
        if (kinect.isInit()) {
            useKineticTracker = true;          // Kinect initialized successfully
            kinect.enableDepth();              // Enable depth tracking
            kinect.enableUser();               // Enable user tracking with skeleton
            println("Kinect initialized successfully.");
        } else {
            useKineticTracker = false;         // Kinect not detected, fallback to mouse control
            println("Kinect not detected. Falling back to mouse control.");
        }
    }
    
    // Setup method to load resources and initialize UI components
    void setup() {
        guitarWinImage = p.loadImage("winimage.jpg");  // Load the win image
        if (guitarWinImage == null) {
            println("Failed to load win image. Ensure the file 'winimage.jpg' is in the 'data' folder.");
        }

        // Add a score label to the UI, initially hidden
        cp5.addTextlabel("scoreLabel")
            .setText("Score: 0")
            .setPosition(600, 20)
            .setFont(p.createFont("Arial", 40))
            .setColor(p.color(255, 255, 255))
            .setVisible(false);
    }

    // Method to start the game
    void startGame() {
        isGameStarted = true;
        gameState = "IN_GAME";
        score = 0;
        performanceData = new PerformanceData();  // Initialize performance data
        performanceData.startSession();           // Start recording performance data
        newRandomNode();                          // Create a new node to start the game
        toggleScoreLabelVisibility(true);         // Show the score label
        dashboard.updateUIForGameState(gameState); // Update dashboard to reflect game state
    }


    
    // Main draw loop of the game
    void draw() {
        if (gameState.equals("IN_GAME")) {
            if (useKineticTracker) {
                // Update Kinect input if Kinect is being used
                kinect.update();

                // Use Kinect depth or projective data
                int centerX = kinect.depthWidth() / 2;
                int centerY = kinect.depthHeight() / 2;
                int depthIndex = centerX + centerY * kinect.depthWidth();
                float depthValue = kinect.depthMapRealWorld()[depthIndex].z; // Get the z-depth

                PVector convertedPosition = new PVector();
                kinect.convertRealWorldToProjective(new PVector(centerX, centerY, depthValue), convertedPosition);

                // Update the tracker position with the Kinect data
                updateTrackerPosition(convertedPosition.x, convertedPosition.y);
            }
            drawGame();  // Continue drawing the game regardless of input method
        } else if (gameState.equals("WIN_WINDOW")) {
            displayWinWindow();  // Display the win screen if the game is won
        }

        if (isPaused) {
            drawPausedOverlay();  // Display pause overlay if the game is paused
        }
    }

    // Method to draw the main game elements
    void drawGame() {
        p.background(backgroundCol);    // Set the background color
        drawGameBoard();                // Draw the game board with blocks

        p.stroke(0);
        float limitY = p.height * 0.6f;
        p.line(p.width * 0.1f, limitY, p.width * 0.9f, limitY); // Draw a line to indicate the limit

        p.fill(cursorCol);
        p.ellipse(trackerX, trackerY, cursorSize, cursorSize);  // Draw the cursor at the current tracker position

        if (!isPaused) {
            if (currentNode != null) {
                currentNode.update();   // Update the current node's position
                currentNode.display();  // Display the current node
            }
            checkCollisions();          // Check if the cursor has collided with the node
            checkNodeStatus();          // Check if the node has moved off-screen
            checkWinCondition();        // Check if the win condition has been met
        }
    }

    // Method to draw the game board with 6 blocks
    void drawGameBoard() {
        float x = p.width * 0.1f;
        float y = p.height * 0.6f;
        float rectWidth = p.width * 0.8f / 6;
        float rectHeight = p.height * 0.75f;
        p.rectMode(PApplet.CORNER);

        for (int i = 0; i < 6; i++) {
            float blockX = x + i * rectWidth;
            float blockY = p.height * 0.125f;
            p.fill(255);
            p.rect(blockX, blockY, rectWidth, rectHeight);  // Draw each block on the board
        }
    }

    // Method to draw the paused overlay
    void drawPausedOverlay() {
        p.fill(0, 0, 0, 150); // Semi-transparent black overlay
        p.rect(0, 0, p.width, p.height);  // Cover the entire screen
        p.fill(255); // White text
        p.textAlign(PApplet.CENTER, PApplet.CENTER);
        p.textFont(font);
        p.text("Paused", p.width / 2, p.height / 2); // Display "Paused" text in the center
    }

    // Method to check if the cursor has collided with the current node
    void checkCollisions() {
        float distance;
        if (useKineticTracker) {
            // Calculate distance from the tracker (Kinect) position to the node
            distance = p.sq(trackerX - currentNode.getX()) + p.sq(trackerY - currentNode.getY());
        } else {
            // Calculate distance from the mouse position to the node
            distance = p.sq(p.mouseX - currentNode.getX()) + p.sq(p.mouseY - currentNode.getY());
        }

        float limitY = p.height * 0.6f;

        if (currentNode != null && distance <= p.sq(10 + 20) && currentNode.getY() > limitY) {
            if (currentNode.isTouched(useKineticTracker ? trackerX : p.mouseX, useKineticTracker ? trackerY : p.mouseY)) {
                handleCollision(currentNode.getX()); // Handle collision if the node is touched
            }
        }
    }

    // Method to handle a collision between the cursor and a node
    void handleCollision(float nodeX) {
        setScore(score + 1);  // Increment score
        int blockIndex = (int) ((nodeX - p.width * 0.1f) / (p.width * 0.8f / 6));
        audioManager.playSound(blockIndex);  // Play sound corresponding to the block
        long reactionTime = System.currentTimeMillis() - performanceData.startTime;
        performanceData.logReactionTime(reactionTime);  // Log the reaction time
        performanceData.successfulHits++;
        performanceData.totalNodes++;
        newRandomNode();  // Generate a new node after collision
    }

    // Method to check if the node has moved off-screen and reset it
    void checkNodeStatus() {
        if (currentNode != null && currentNode.getY() > p.height + 20) {
            performanceData.missedHits++;
            performanceData.totalNodes++;
            returnNodeToPool(currentNode);  // Return the current node to the pool for reuse
            newRandomNode();  // Generate a new node
        }
    }

    // Method to check if the player has won the game
    void checkWinCondition() {
        if (score >= 10) {
            gameState = "WIN_WINDOW";   // Change the game state to "WIN_WINDOW"
            isGameStarted = false;
            performanceData.endSession();  // End the performance session
            toggleScoreLabelVisibility(false);  // Hide the score label
            dashboard.updateUIForGameState(gameState);  // Update the dashboard to the win state
            displaySessionSummary();  // Display the session summary
        }
    }

    // Method to display the win window
    void displayWinWindow() {
        // Clear the screen with a solid background to avoid overlaps
        p.background(0);

        if (guitarWinImage != null) {
            p.image(guitarWinImage, 0, 0, p.width, p.height);  // Draw the win image
        } else {
            p.fill(255);  // Fallback if the image isn't loaded
            p.textAlign(PApplet.CENTER, PApplet.CENTER);
            p.text("Congratulations! You won!", p.width / 2, p.height / 2);  // Display text fallback
        }

        dashboard.updateUIForGameState("WIN_WINDOW");  // Update the UI to the win state
    }

    // Method to display the session summary after the game ends
    void displaySessionSummary() {
        String summary = "Session Summary:\n";
        summary += "Total Nodes: " + performanceData.totalNodes + "\n";
        summary += "Successful Hits: " + performanceData.successfulHits + "\n";
        summary += "Missed Hits: " + performanceData.missedHits + "\n";
        summary += "Accuracy: " + PApplet.nf(performanceData.getAccuracy(), 0, 2) + "%\n";
        summary += "Average Reaction Time: " + PApplet.nf(performanceData.getAverageReactionTime(), 0, 2) + " ms\n";
        summary += "Total Time: " + performanceData.getTotalTime() / 1000 + " seconds\n";

        summaryManager.updateSessionSummary(summary);  // Use the SummaryManager to display the summary
    }

    // Method to create a new random node on the screen
    void newRandomNode() {
        int blockIndex = (int) p.random(0, 6);
        float startX = p.width * 0.1f + blockIndex * (p.width * 0.8f / 6) + (p.width * 0.8f / 6) / 2;
        float startY = p.height * 0.125f;

        Node node;
        if (nodePool.isEmpty()) {
            node = new Node(p, startX, startY, nodeSpeed);  // Create a new node if pool is empty
        } else {
            node = nodePool.poll();  // Reuse a node from the pool
            node.reset(startX, startY, nodeSpeed);  // Reset the node's position and speed
        }

        node.setNodeCol(nodeCol);  // Set the current node color
        currentNode = node;  // Set the current node
    }

    // Method to return a node to the pool for reuse
    void returnNodeToPool(Node node) {
        nodePool.offer(node);  // Add the node to the pool
    }
    
    // Getter method for AudioManager
    AudioManager getAudioManager() {
        return this.audioManager;
    }

    // Method to toggle the pause state of the game
    void togglePause() {
        isPaused = !isPaused;  // Toggle the pause state
    }

    // Method to increase the speed of nodes
    void increaseNodeSpeed() {
        nodeSpeed = PApplet.min(10, nodeSpeed + 1);  // Increase speed, but cap at 10
        if (currentNode != null) {
            currentNode.setSpeed(nodeSpeed);  // Update the speed of the current node
        }
        dashboard.updateSpeedLabel(nodeSpeed);  // Update the speed label in the dashboard
    }

    // Method to decrease the speed of nodes
    void decreaseNodeSpeed() {
        nodeSpeed = PApplet.max(1, nodeSpeed - 1);  // Decrease speed, but no lower than 1
        if (currentNode != null) {
            currentNode.setSpeed(nodeSpeed);  // Update the speed of the current node
        }
        dashboard.updateSpeedLabel(nodeSpeed);  // Update the speed label in the dashboard
    }

    // Method to toggle the visibility of the score label
    void toggleScoreLabelVisibility(boolean isVisible) {
        cp5.get(Textlabel.class, "scoreLabel").setVisible(isVisible);
    }

    // Method to update the score
    void setScore(int newScore) {
        score = newScore;  // Update the score
        cp5.get(Textlabel.class, "scoreLabel").setText("Score: " + score);  // Update the score label text
    }

    // Getter method for node speed
    float getNodeSpeed() {
        return nodeSpeed;
    }

    // Setter method for the dashboard
    void setDashboard(Dashboard dashboard) {
        this.dashboard = dashboard;
    }

    // Setter method for the node color
    void setNodeCol(int col) {
        if (this.nodeCol != col) {  // Avoid unnecessary updates
            this.nodeCol = col;  // Update the node color
            if (currentNode != null) {
                currentNode.setNodeCol(col);  // Apply the color to the current node
            }
        }
    }

    // Getter method for the node color
    int getNodeCol() {
        return this.nodeCol;  // Return the current node color
    }

    // Setter method for the cursor color
    void setCursorCol(int col) {
        this.cursorCol = col;
    }

    // Setter method for the cursor size
    void setCursorSize(float size) {
        this.cursorSize = size;  // Update the cursor size
    }

    // Getter method for the cursor size
    float getCursorSize() {
        return this.cursorSize;  // Return the current cursor size
    }

    // Setter method for the background color
    void setBackgroundCol(int col) {
        this.backgroundCol = col;
    }

    // Method to update the font used in the game
    void updateFont(String fontName, int fontSize) {
        font = p.createFont(fontName, fontSize);
        cp5.get(Textlabel.class, "scoreLabel").setFont(font);
    }

    // Method to update the tracker's position
    void updateTrackerPosition(float x, float y) {
        trackerX = x;
        trackerY = y;
    }

    // Method to reset the game and redirect to the dashboard
    void redirectToDashboard() {
        gameState = "DASHBOARD";  // Change the game state to "DASHBOARD"
        isGameStarted = false;
        resetGame();  // Reset the game variables
        dashboard.updateUIForGameState(gameState);  // Update the dashboard to reflect the game state
        dashboard.reinitializeDashboardButtons(); // Ensure buttons are reinitialized
    }

    // Method to reset game variables for a new session
    void resetGame() {
        score = 0;  // Reset the score
        currentNode = null;  // Clear the current node
        if (performanceData != null) {
            performanceData.reset();  // Reset performance data
        }
        toggleScoreLabelVisibility(false);  // Hide the score label
    }

    // Check if the game is paused
    boolean isPaused() {
        return isPaused;
    }

    // Check if the game has started
    boolean isGameStarted() {
        return isGameStarted;
    }

    // Getter method for the game state
    String getGameState() {
        return gameState;
    }

    // Methods to manage summary button visibility
    void showSummaryButton() {
        summaryManager.showSummaryButton();  // Show the summary button
    }

    void hideSummaryButton() {
        summaryManager.hideSummaryButton();  // Hide the summary button
    }
}
