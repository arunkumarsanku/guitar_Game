PApplet parent;
Game game;
Dashboard dashboard;

void setup() {
    size(800, 600); // Set canvas size
    parent = this; // Set parent PApplet
    
    game = new Game(parent); // Create game instance
    game.setup(); // Setup game
    
    dashboard = new Dashboard(parent, game); // Create dashboard instance
    game.setDashboard(dashboard); // Pass reference to the dashboard
}


void draw() {
    // Check the current game state and act accordingly
    if (game.getGameState().equals("DASHBOARD")) {
        // Draw the dashboard background and other dashboard elements
        dashboard.draw();
    } else if (game.getGameState().equals("IN_GAME")) {
        // Clear the screen or set a neutral background
        parent.background(0); // Set to a solid color to avoid overlapping images
        game.draw(); // Draw the game elements
    } else if (game.getGameState().equals("WIN_WINDOW")) {
        // Clear the screen or set a neutral background before drawing the win window
        parent.background(0); // Set to a solid color to avoid overlapping images
        game.displayWinWindow(); // Draw the win window with the win image
    }

    if (game.useKineticTracker) {
        updateKinectInput(); // Update Kinect input if Kinect is being used
    }
}


// Method to capture Kinect sensor input and pass it to game logic
void updateKinectInput() {
    game.kinect.update(); // Update Kinect data
    int[] userIds = game.kinect.getUsers();
    if (userIds.length > 0) {
        int userId = userIds[0];
        if (game.kinect.isTrackingSkeleton(userId)) {
            PVector handPosition = new PVector();
            game.kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, handPosition);
            PVector convertedPosition = new PVector();
            game.kinect.convertRealWorldToProjective(handPosition, convertedPosition);
            game.updateTrackerPosition(convertedPosition.x, convertedPosition.y);
        }
    }
}

void mouseMoved() {
    if (!game.useKineticTracker) { // Only update if Kinect is not being used
        game.updateTrackerPosition(mouseX, mouseY); // Update tracker position with mouse coordinates
    }
}
