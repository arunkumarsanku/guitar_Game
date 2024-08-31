//PApplet parent;
//Game game;
//Dashboard dashboard;

//// Setup method
//void setup() {
//    size(800, 600); // Set canvas size
//    parent = this; // Set parent PApplet
    
//    game = new Game(parent); // Create game instance
//    game.setup(); // Setup game
    
//    dashboard = new Dashboard(parent, game); // Create dashboard instance
//    game.setDashboard(dashboard); // Pass reference to the dashboard
//}

//// Draw method
//void draw() {
//    dashboard.draw(); // Draw dashboard
    
//    if (game.isGameStarted() && !game.isPaused()) {
//        game.draw(); // Draw game if it's started and not paused
//    } else if (game.getGameState().equals("WIN_WINDOW")) {
//        game.draw(); // Draw win window if the game is won
//    }
//}

//// Capture mouse movement
//void mouseMoved() {
//    if (game != null) {
//        game.updateTrackerPosition(mouseX, mouseY); // Update tracker position based on mouse position
//    }
//}





PApplet parent;
Game game;
Dashboard dashboard;

// Setup method
void setup() {
    size(800, 600); // Set canvas size
    parent = this; // Set parent PApplet
    
    game = new Game(parent); // Create game instance
    game.setup(); // Setup game
    
    dashboard = new Dashboard(parent, game); // Create dashboard instance
    game.setDashboard(dashboard); // Pass reference to the dashboard
}

// Draw method
void draw() {
    dashboard.draw(); // Draw dashboard
    
    if (game.isGameStarted() && !game.isPaused()) {
        game.draw(); // Draw game if it's started and not paused
    } else if (game.getGameState().equals("WIN_WINDOW")) {
        game.draw(); // Draw win window if the game is won
    }
}

// Capture mouse movement
void mouseMoved() {
    if (game != null) {
        game.updateTrackerPosition(mouseX, mouseY); // Update tracker position based on mouse position
    }
}
