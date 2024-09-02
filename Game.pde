import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;
import processing.core.PVector;
import controlP5.ControlP5;
import SimpleOpenNI.SimpleOpenNI;

import java.util.LinkedList;
import java.util.Queue;

class Game {
    PApplet p;
    ControlP5 cp5;
    Dashboard dashboard;
    AudioManager audioManager;
    SummaryManager summaryManager;

    PImage guitarBackground;
    PImage guitarWinImage;
    PFont font;

    Node currentNode;
    PerformanceData performanceData;

    Queue<Node> nodePool = new LinkedList<>();
    boolean isPaused = false;
    boolean isGameStarted = false;
    String gameState = "DASHBOARD";
    int score = 0;

    float nodeSpeed = 5;
    float trackerX, trackerY;
    float cursorSize = 20;  // Initial cursor size
    int cursorCol;
    int backgroundCol;
    int nodeCol;

    boolean useKineticTracker = false;  // Flag indicating if Kinect tracker is being used
    SimpleOpenNI kinect;

    Game(PApplet parent) {
        this.p = parent;
        this.cp5 = new ControlP5(p);
        this.audioManager = new AudioManager(parent);
        this.font = p.createFont("Arial", 48);
        this.cursorCol = p.color(255, 0, 0);
        this.backgroundCol = p.color(55, 47, 69);
        this.nodeCol = p.color(222, 255, 0);  // Default node color
        this.summaryManager = new SummaryManager(parent, cp5, this);
        
        initializeKinect(); // Attempt to initialize Kinect
    }
    
    void initializeKinect() {
        kinect = new SimpleOpenNI(p);
        if (kinect.isInit()) {
            useKineticTracker = true;
            kinect.enableDepth();
            kinect.enableUser();  // Use the default skeleton tracking without specifying a profile
            println("Kinect initialized successfully.");
        } else {
            useKineticTracker = false;
            println("Kinect not detected. Falling back to mouse control.");
        }
    }
    
   
    
    
    void setup() {
    guitarBackground = p.loadImage("guitar_background.jpg");
    if (guitarBackground != null) {
        guitarBackground.resize(p.width, p.height);
    }

    guitarWinImage = p.loadImage("winimage.jpg");  // Load the win image correctly
    if (guitarWinImage == null) {
        println("Failed to load win image. Ensure the file 'winimage.jpg' is in the 'data' folder.");
    }

    cp5.addTextlabel("scoreLabel")
        .setText("Score: 0")
        .setPosition(600, 20)
        .setFont(p.createFont("Arial", 40))
        .setColor(p.color(0, 255, 0))
        .setVisible(false);
}




    void startGame() {
        isGameStarted = true;
        gameState = "IN_GAME";
        score = 0;
        performanceData = new PerformanceData();
        performanceData.startSession();
        newRandomNode();
        toggleScoreLabelVisibility(true);
        dashboard.updateUIForGameState(gameState);
    }

    void draw() {
        if (gameState.equals("IN_GAME")) {
            if (useKineticTracker) {
                kinect.update();
                int[] userIds = kinect.getUsers();
                if (userIds.length > 0) {
                    int userId = userIds[0];
                    if (kinect.isTrackingSkeleton(userId)) {
                        PVector handPosition = new PVector();
                        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, handPosition);
                        PVector convertedPosition = new PVector();
                        kinect.convertRealWorldToProjective(handPosition, convertedPosition);

                        // Update the tracker position with Kinect data
                        updateTrackerPosition(convertedPosition.x, convertedPosition.y);
                    }
                }
            }
            drawGame(); // Continue drawing the game regardless of input method
        } else if (gameState.equals("WIN_WINDOW")) {
            displayWinWindow();
        }

        if (isPaused) {
            drawPausedOverlay();
        }
    }

    void drawGame() {
        p.background(backgroundCol);
        drawGameBoard();

        p.stroke(0);
        float limitY = p.height * 0.6f;
        p.line(p.width * 0.1f, limitY, p.width * 0.9f, limitY);

        p.fill(cursorCol);
        p.ellipse(trackerX, trackerY, cursorSize, cursorSize);  // Use the updated tracker position

        if (!isPaused) {
            if (currentNode != null) {
                currentNode.update();
                currentNode.display();
            }
            checkCollisions();
            checkNodeStatus();
            checkWinCondition();
        }
    }

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
            p.rect(blockX, blockY, rectWidth, rectHeight);
        }
    }

    void drawPausedOverlay() {
        p.fill(0, 0, 0, 150);
        p.rect(0, 0, p.width, p.height);
        p.fill(255);
        p.textAlign(PApplet.CENTER, PApplet.CENTER);
        p.textFont(font);
        p.text("Paused", p.width / 2, p.height / 2);
    }

    void checkCollisions() {
        float distance;
        if (useKineticTracker) {
            distance = p.sq(trackerX - currentNode.getX()) + p.sq(trackerY - currentNode.getY());
        } else {
            distance = p.sq(p.mouseX - currentNode.getX()) + p.sq(p.mouseY - currentNode.getY());
        }

        float limitY = p.height * 0.6f;

        if (currentNode != null && distance <= p.sq(10 + 20) && currentNode.getY() > limitY) {
            if (useKineticTracker) {
                if (currentNode.isTouched(trackerX, trackerY)) {
                    handleCollision(currentNode.getX());
                }
            } else {
                if (currentNode.isTouched(p.mouseX, p.mouseY)) {
                    handleCollision(currentNode.getX());
                }
            }
        }
    }

    void handleCollision(float nodeX) {
        setScore(score + 1);  // Increment score
        int blockIndex = (int) ((nodeX - p.width * 0.1f) / (p.width * 0.8f / 6));
        audioManager.playSound(blockIndex);
        long reactionTime = System.currentTimeMillis() - performanceData.startTime;
        performanceData.logReactionTime(reactionTime);
        performanceData.successfulHits++;
        performanceData.totalNodes++;
        newRandomNode();
    }

    void checkNodeStatus() {
        if (currentNode != null && currentNode.getY() > p.height + 20) {
            performanceData.missedHits++;
            performanceData.totalNodes++;
            returnNodeToPool(currentNode);
            newRandomNode();
        }
    }

    void checkWinCondition() {
        if (score >= 10) {
            gameState = "WIN_WINDOW";
            isGameStarted = false;
            performanceData.endSession();
            toggleScoreLabelVisibility(false);
            dashboard.updateUIForGameState(gameState);
            displaySessionSummary();  // Ensure the summary is displayed
        }
    }

   
void displayWinWindow() {
    // Clear the screen with a solid background to avoid overlaps
    p.background(0);

    if (guitarWinImage != null) {
        p.image(guitarWinImage, 0, 0, p.width, p.height);  // Draw the win image
    } else {
        p.fill(255);  // Fallback if the image isn't loaded
        p.textAlign(CENTER, CENTER);
        p.text("Congratulations! You won!", p.width / 2, p.height / 2);  // Display text fallback
    }

    dashboard.updateUIForGameState("WIN_WINDOW");  // Update the UI to the win state
}




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

    void newRandomNode() {
        int blockIndex = (int) p.random(0, 6);
        float startX = p.width * 0.1f + blockIndex * (p.width * 0.8f / 6) + (p.width * 0.8f / 6) / 2;
        float startY = p.height * 0.125f;

        Node node;
        if (nodePool.isEmpty()) {
            node = new Node(p, startX, startY, nodeSpeed);
        } else {
            node = nodePool.poll();
            node.reset(startX, startY, nodeSpeed);
        }

        node.setNodeCol(nodeCol);  // Set the current node color
        currentNode = node;
    }

    void returnNodeToPool(Node node) {
        nodePool.offer(node);
    }
    
    AudioManager getAudioManager() {
        return this.audioManager;
    }

    void togglePause() {
        isPaused = !isPaused;
    }

    void increaseNodeSpeed() {
        nodeSpeed = PApplet.min(10, nodeSpeed + 1);
        if (currentNode != null) {
            currentNode.setSpeed(nodeSpeed);
        }
        dashboard.updateSpeedLabel(nodeSpeed);
    }

    void decreaseNodeSpeed() {
        nodeSpeed = PApplet.max(1, nodeSpeed - 1);
        if (currentNode != null) {
            currentNode.setSpeed(nodeSpeed);
        }
        dashboard.updateSpeedLabel(nodeSpeed);
    }

    void toggleScoreLabelVisibility(boolean isVisible) {
        cp5.get(Textlabel.class, "scoreLabel").setVisible(isVisible);
    }

    void setScore(int newScore) {
        score = newScore;
        cp5.get(Textlabel.class, "scoreLabel").setText("Score: " + score);
    }

    float getNodeSpeed() {
        return nodeSpeed;
    }

    void setDashboard(Dashboard dashboard) {
        this.dashboard = dashboard;
    }

    void setNodeCol(int col) {
        if (this.nodeCol != col) {  // Avoid unnecessary updates
            this.nodeCol = col;  // Update the node color
            if (currentNode != null) {
                currentNode.setNodeCol(col);  // Apply the color to the current node
            }
        }
    }

    int getNodeCol() {
        return this.nodeCol;  // Getter for the current node color
    }

    void setCursorCol(int col) {
        this.cursorCol = col;
    }

    void setCursorSize(float size) {
        this.cursorSize = size;  // Update the cursor size
    }

    float getCursorSize() {
        return this.cursorSize;  // Getter for the current cursor size
    }

    void setBackgroundCol(int col) {
        this.backgroundCol = col;
    }

    void updateFont(String fontName, int fontSize) {
        font = p.createFont(fontName, fontSize);
        cp5.get(Textlabel.class, "scoreLabel").setFont(font);
    }

    void updateTrackerPosition(float x, float y) {
        trackerX = x;
        trackerY = y;
    }

    void redirectToDashboard() {
        gameState = "DASHBOARD";
        isGameStarted = false;
        resetGame();
        dashboard.updateUIForGameState(gameState);
        dashboard.reinitializeDashboardButtons(); // Ensure buttons are reinitialized
    }

    void resetGame() {
        score = 0;
        currentNode = null;
        if (performanceData != null) {
            performanceData.reset();
        }
        toggleScoreLabelVisibility(false);
    }

    boolean isPaused() {
        return isPaused;
    }

    boolean isGameStarted() {
        return isGameStarted;
    }

    String getGameState() {
        return gameState;
    }

    // Methods to manage summary button visibility
    void showSummaryButton() {
        summaryManager.showSummaryButton();
    }

    void hideSummaryButton() {
        summaryManager.hideSummaryButton();
    }
}
