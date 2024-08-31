import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class UIManager {
    PApplet p;
    ControlP5 cp5;
    Game game;
    Dashboard dashboard;

    Button pauseButton, increaseSpeedButton, decreaseSpeedButton, summaryButton, helpButton, dashboardButton, settingsButton, startButton;
    Textlabel speedLabel;
    Textarea sessionSummary, helpLabel;
    SettingsManager settingsManager;

    UIManager(PApplet parent, Game game, Dashboard dashboard) {
        this.p = parent;
        this.game = game;
        this.dashboard = dashboard;
        this.cp5 = new ControlP5(p);
        this.settingsManager = new SettingsManager(parent, cp5, game);
    }

    void initializeUIComponents(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        initializeButtons();
        initializeLabelsAndTextAreas();
        settingsManager.initializeSettingsPanel(fonts, fontSizes, highContrastColors);
    }

    void initializeButtons() {
        startButton = cp5.addButton("startButton")
            .setPosition(20, 20)
            .setSize(100, 40)
            .setCaptionLabel("Start")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    game.startGame();
                }
            });

        pauseButton = cp5.addButton("pauseButton")
            .setPosition(280, 560)
            .setSize(150, 40)
            .setCaptionLabel("Pause")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    game.togglePause();
                    pauseButton.setCaptionLabel(game.isPaused() ? "Resume" : "Pause");
                }
            });

        increaseSpeedButton = cp5.addButton("increaseSpeedButton")
            .setPosition(460, 560)
            .setSize(80, 40)
            .setCaptionLabel("Speed +1")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    game.increaseNodeSpeed();
                }
            });

        decreaseSpeedButton = cp5.addButton("decreaseSpeedButton")
            .setPosition(550, 560)
            .setSize(80, 40)
            .setCaptionLabel("Speed -1")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    game.decreaseNodeSpeed();
                }
            });

        summaryButton = cp5.addButton("summaryButton")
            .setPosition(640, 20)
            .setSize(100, 40)
            .setCaptionLabel("Summary")
            .setVisible(false)  // Initially hidden, will be shown in the win window
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    dashboard.toggleSummaryVisibility();  // Toggle visibility when clicked
                }
            });

        helpButton = cp5.addButton("helpButton")
            .setPosition(20, 70)
            .setSize(100, 40)
            .setCaptionLabel("Help")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    toggleHelpVisibility();
                }
            });

        dashboardButton = cp5.addButton("dashboardButton")
            .setPosition(640, 560)
            .setSize(100, 40)
            .setCaptionLabel("Dashboard")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    game.redirectToDashboard();
                }
            });

        settingsButton = cp5.addButton("settingsButton")
            .setPosition(20, 120)
            .setSize(100, 40)
            .setCaptionLabel("Settings")
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    settingsManager.toggleSettingsVisibility();
                }
            });
    }

    void initializeLabelsAndTextAreas() {
        speedLabel = cp5.addTextlabel("speedLabel")
            .setPosition(630, 560)
            .setFont(p.createFont("Arial", 20))
            .setColor(p.color(0, 0, 0))
            .setText("Node Speed: " + game.getNodeSpeed());

        helpLabel = cp5.addTextarea("helpLabel")
            .setPosition(150, 70)
            .setSize(600, 150)
            .setFont(p.createFont("Arial", 16))
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

        sessionSummary = cp5.addTextarea("sessionSummary")
            .setPosition(20, 400)
            .setSize(760, 160)
            .setFont(p.createFont("Arial", 16))
            .setLineHeight(20)
            .setColor(p.color(0, 0, 0))
            .setColorBackground(p.color(255, 255, 204))
            .setBorderColor(p.color(0, 0, 0))
            .setText("")
            .setVisible(false);  // Initially hidden
    }

    void toggleSessionSummaryVisibility(boolean isVisible) {
        sessionSummary.setVisible(isVisible);
    }

    void updateSessionSummary(String summary) {
        sessionSummary.setText(summary);
        sessionSummary.setVisible(true);  // Ensure it's visible after updating
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
            toggleSummaryButtonVisibility(false);
            toggleDashboardButtonVisibility(false);
        } else if (gameState.equals("IN_GAME")) {
            hideAllDashboardButtons();
            togglePauseButtonVisibility(true);
            toggleSpeedButtonsVisibility(true);
        } else if (gameState.equals("WIN_WINDOW")) {
            hideAllDashboardButtons();
            toggleSummaryButtonVisibility(true);
            toggleDashboardButtonVisibility(true);
        }
    }

    void toggleHelpVisibility() {
        boolean isVisible = helpLabel.isVisible();
        helpLabel.setVisible(!isVisible);
    }

    void hideAllDashboardButtons() {
        startButton.hide();
        pauseButton.hide();
        increaseSpeedButton.hide();
        decreaseSpeedButton.hide();
        summaryButton.hide();
        helpButton.hide();
        settingsButton.hide();
    }

    void showAllDashboardButtons() {
        startButton.show();
        pauseButton.show();
        increaseSpeedButton.show();
        decreaseSpeedButton.show();
        summaryButton.show();
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

    void toggleSummaryButtonVisibility(boolean isVisible) {
        summaryButton.setVisible(isVisible);
    }

    void toggleDashboardButtonVisibility(boolean isVisible) {
        dashboardButton.setVisible(isVisible);
    }

    void reinitializeDashboardButtons() {
        hideAllDashboardButtons();
        initializeButtons(); // Reinitialize all buttons to ensure functionality
    }
}
