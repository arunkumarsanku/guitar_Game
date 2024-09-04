import controlP5.*;
import processing.core.PApplet;
import java.util.List;

// The UIManager class manages all UI components such as buttons, labels, and text areas in the game.
class UIManager {
    PApplet p;                          // Reference to the PApplet instance
    ControlP5 cp5;                      // ControlP5 instance for managing UI components
    Game game;                          // Reference to the Game instance
    Dashboard dashboard;                // Reference to the Dashboard instance
    SettingsManager settingsManager;    // Reference to the SettingsManager instance

    Button pauseButton, increaseSpeedButton, decreaseSpeedButton, helpButton, dashboardButton, settingsButton, startButton;
    Textlabel speedLabel;               // Label to display the current node speed
    Textarea helpLabel;                 // Text area to display help instructions
    private static final int DEFAULT_FONT_SIZE = 12;  // Default font size for UI elements

    // Constructor to initialize the UIManager
    UIManager(PApplet parent, Game game, Dashboard dashboard) {
        this.p = parent;                              // Initialize PApplet reference
        this.game = game;                             // Initialize Game reference
        this.dashboard = dashboard;                   // Initialize Dashboard reference
        this.cp5 = new ControlP5(p);                  // Initialize ControlP5
        this.settingsManager = new SettingsManager(parent, cp5, game);  // Initialize SettingsManager
    }

    // Method to initialize all UI components, including buttons, labels, and the settings panel
    void initializeUIComponents(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        initializeButtons();  // Initialize all buttons
        initializeLabelsAndTextAreas(fonts, fontSizes);  // Initialize labels and text areas
        settingsManager.initializeSettingsPanel(fonts, fontSizes, highContrastColors);  // Initialize the settings panel
    }

    // Method to initialize all buttons with their positions, sizes, labels, and event listeners
    void initializeButtons() {
        startButton = createButton("startButton", 20, 20, 100, 40, "Start", event -> game.startGame());
        pauseButton = createButton("pauseButton", 280, 560, 150, 40, "Pause", event -> {
            game.togglePause();
            pauseButton.setCaptionLabel(game.isPaused() ? "Resume" : "Pause");
        });
        increaseSpeedButton = createButton("increaseSpeedButton", 460, 560, 80, 40, "Speed +1", event -> game.increaseNodeSpeed());
        decreaseSpeedButton = createButton("decreaseSpeedButton", 550, 560, 80, 40, "Speed -1", event -> game.decreaseNodeSpeed());
        helpButton = createButton("helpButton", 20, 70, 100, 40, "Help", event -> toggleHelpVisibility());
        dashboardButton = createButton("dashboardButton", 640, 560, 100, 40, "Dashboard", event -> game.redirectToDashboard());
        dashboardButton.setVisible(false);  // Start with the button hidden
        settingsButton = createButton("settingsButton", 20, 120, 100, 40, "Settings", event -> settingsManager.toggleSettingsVisibility());
    }

    // Helper method to create a button with the specified properties
    private Button createButton(String name, int x, int y, int width, int height, String label, ControlListener listener) {
        return cp5.addButton(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setCaptionLabel(label)
            .setFont(p.createFont("Verdana Bold", DEFAULT_FONT_SIZE))
            .addListener(listener);  // Add the event listener to handle button clicks
    }

    // Method to initialize labels and text areas
    void initializeLabelsAndTextAreas(List<String> fonts, List<Integer> fontSizes) {
        int fontSize = DEFAULT_FONT_SIZE;

        // Initialize the speed label to display the current node speed
        speedLabel = cp5.addTextlabel("speedLabel")
            .setPosition(40, 560)
            .setFont(p.createFont("Verdana Bold", fontSize))
            .setColor(p.color(255, 24, 110))
            .setText("Node Speed: " + game.getNodeSpeed());

        // Initialize the help label to display game instructions
        helpLabel = cp5.addTextarea("helpLabel")
            .setPosition(150, 70)
            .setSize(650, 250)
            .setFont(p.createFont("Verdana Bold", fontSize))
            .setLineHeight(20)
            .setColor(p.color(0, 0, 0))
            .setColorBackground(p.color(255, 255, 204))
            .setBorderColor(p.color(0, 0, 0))
            .setText("Instructions:\n"
                    + "1. Start the game by clicking the 'Start' button.\n"
                    + "2. Move your mouse to control the tracker.\n"
                    + "3. Touch the nodes as they fall to score points.\n"
                    + "4. Use 'Speed +1' and 'Speed -1' buttons to adjust node speed.\n"
                    + "5. Pause the game using the 'Pause' button.\n"
                    + "6. Reach a score of 10 to win the game.\n")
            .setVisible(false);  // Initially hidden, shown when needed
    }

    // Method to toggle the visibility of the help label
    void toggleHelpVisibility() {
        helpLabel.setVisible(!helpLabel.isVisible());
    }

    // Method to update the speed label with the current node speed and adjust its color based on the speed
    void updateSpeedLabel(float speed) {
        speedLabel.setText("Node Speed: " + speed);
        if (speed >= 7) {
            speedLabel.setColor(p.color(255, 0, 0));  // Red color for high speed
        } else if (speed >= 4 && speed < 7) {
            speedLabel.setColor(p.color(255, 255, 0));  // Yellow color for moderate speed
        } else {
            speedLabel.setColor(p.color(0, 255, 0));  // Green color for low speed
        }
    }

    // Method to update the UI components based on the current game state
    void updateUIForGameState(String gameState) {
        if (gameState.equals("DASHBOARD")) {
            showAllDashboardButtons();
            togglePauseButtonVisibility(false);
            toggleSpeedButtonsVisibility(false);
            game.hideSummaryButton();
            dashboardButton.setVisible(false);  // Ensure it's hidden in the dashboard state
        } else if (gameState.equals("IN_GAME")) {
            hideAllDashboardButtons();
            togglePauseButtonVisibility(true);
            toggleSpeedButtonsVisibility(true);
            game.hideSummaryButton();
            dashboardButton.setVisible(false);  // Ensure it's hidden in the in-game state
        } else if (gameState.equals("WIN_WINDOW")) {
            hideAllDashboardButtons();
            game.showSummaryButton();
            dashboardButton.setVisible(true);  // Show it only in the win window state
        }
    }

    // Method to hide all dashboard-related buttons
    void hideAllDashboardButtons() {
        startButton.hide();
        pauseButton.hide();
        increaseSpeedButton.hide();
        decreaseSpeedButton.hide();
        helpButton.hide();
        settingsButton.hide();
    }

    // Method to show all dashboard-related buttons
    void showAllDashboardButtons() {
        startButton.show();
        pauseButton.show();
        increaseSpeedButton.show();
        decreaseSpeedButton.show();
        helpButton.show();
        settingsButton.show();
    }

    // Method to toggle the visibility of the pause button
    void togglePauseButtonVisibility(boolean isVisible) {
        pauseButton.setVisible(isVisible);
    }

    // Method to toggle the visibility of the speed adjustment buttons
    void toggleSpeedButtonsVisibility(boolean isVisible) {
        increaseSpeedButton.setVisible(isVisible);
        decreaseSpeedButton.setVisible(isVisible);
    }

    // Method to toggle the visibility of the dashboard button
    void toggleDashboardButtonVisibility(boolean isVisible) {
        dashboardButton.setVisible(isVisible);
    }

    // Method to reinitialize the dashboard buttons, typically called when the dashboard needs to be reset
    void reinitializeDashboardButtons() {
        hideAllDashboardButtons();  // Hide all buttons before reinitializing
        initializeButtons();  // Reinitialize the buttons
    }
}
