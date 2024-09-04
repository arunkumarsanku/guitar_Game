PApplet parent;
Game game;
Dashboard dashboard;
PFont globalFont; // Define a global font variable

void setup() {
    size(800, 600); // Set canvas size
    //globalFont = createFont("Arial", 40); // Define a font with a specific size (e.g., 20)

    parent = this; // Set parent PApplet
    
    game = new Game(parent); // Create game instance
    game.setup(); // Setup game
    
    dashboard = new Dashboard(parent, game); // Create dashboard instance
    game.setDashboard(dashboard); // Pass reference to the dashboard
}

void draw() {
    if (game.getGameState().equals("DASHBOARD")) {
        // Only draw the dashboard when in the DASHBOARD state
        dashboard.draw();
    } else if (game.getGameState().equals("IN_GAME")) {
        // When the game is running, draw the game elements
        game.draw(); // Draw the game
    } else if (game.getGameState().equals("WIN_WINDOW")) {
        // Only draw the win window when in the WIN_WINDOW state
        game.displayWinWindow();
    }
}

void mouseMoved() {
    if (!game.useKineticTracker) { // Only update if Kinect is not being used
        game.updateTrackerPosition(mouseX, mouseY); // Update tracker position with mouse coordinates
    }
}
