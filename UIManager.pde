import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class UIManager {
    PApplet p;
    ControlP5 cp5;
    Game game;
    Dashboard dashboard;
    SettingsManager settingsManager;

    Button pauseButton, increaseSpeedButton, decreaseSpeedButton, helpButton, dashboardButton, settingsButton, startButton;
    Textlabel speedLabel;
    Textarea helpLabel;
    private static final int DEFAULT_FONT_SIZE = 12;

    UIManager(PApplet parent, Game game, Dashboard dashboard) {
        this.p = parent;
        this.game = game;
        this.dashboard = dashboard;
        this.cp5 = new ControlP5(p);
        this.settingsManager = new SettingsManager(parent, cp5, game);
    }

    void initializeUIComponents(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        initializeButtons();
        initializeLabelsAndTextAreas(fonts, fontSizes);
        settingsManager.initializeSettingsPanel(fonts, fontSizes, highContrastColors);
    }

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

    private Button createButton(String name, int x, int y, int width, int height, String label, ControlListener listener) {
        return cp5.addButton(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setCaptionLabel(label)
            .setFont(p.createFont("Verdana Bold", DEFAULT_FONT_SIZE))
            .addListener(listener);
    }

    void initializeLabelsAndTextAreas(List<String> fonts, List<Integer> fontSizes) {
        int fontSize = DEFAULT_FONT_SIZE;

        speedLabel = cp5.addTextlabel("speedLabel")
            .setPosition(40, 560)
            .setFont(p.createFont("Verdana Bold", fontSize))
            .setColor(p.color(255, 24, 110))
            .setText("Node Speed: " + game.getNodeSpeed());

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
            .setVisible(false);
    }

    void toggleHelpVisibility() {
        helpLabel.setVisible(!helpLabel.isVisible());
    }

    void updateSpeedLabel(float speed) {
        speedLabel.setText("Node Speed: " + speed);
        if (speed >= 7) {
            speedLabel.setColor(p.color(255, 0, 0));
        } else if (speed >= 4 && speed < 7) {
            speedLabel.setColor(p.color(255, 255, 0));
        } else {
            speedLabel.setColor(p.color(0, 255, 0));
        }
    }

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


    void hideAllDashboardButtons() {
        startButton.hide();
        pauseButton.hide();
        increaseSpeedButton.hide();
        decreaseSpeedButton.hide();
        helpButton.hide();
        settingsButton.hide();
    }

    void showAllDashboardButtons() {
        startButton.show();
        pauseButton.show();
        increaseSpeedButton.show();
        decreaseSpeedButton.show();
        helpButton.show();
        settingsButton.show();
    }

    void togglePauseButtonVisibility(boolean isVisible) {
        pauseButton.setVisible(isVisible);
    }

    void toggleSpeedButtonsVisibility(boolean isVisible) {
        increaseSpeedButton.setVisible(isVisible);
        decreaseSpeedButton.setVisible(isVisible);
    }

    void toggleDashboardButtonVisibility(boolean isVisible) {
        dashboardButton.setVisible(isVisible);
    }

    void reinitializeDashboardButtons() {
        hideAllDashboardButtons();
        initializeButtons();
    }
}
