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
    dashboard.draw(); // Draw dashboard
    
    if (game.isGameStarted() && !game.isPaused()) {
        game.draw(); // Draw game if it's started and not paused
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
