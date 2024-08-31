import controlP5.*;
import processing.core.PApplet;
import processing.core.PImage;
import java.util.Arrays;
import java.util.List;

class Dashboard {
    PApplet p;
    UIManager uiManager;
    Game game;
    boolean isSummaryVisible = false;
    PImage guitarBackground;

    Dashboard(PApplet parent, Game game) {
        this.p = parent;
        this.game = game;
        this.uiManager = new UIManager(parent, game, this);

        guitarBackground = p.loadImage("guitar_background.jpg");
        if (guitarBackground != null) {
            guitarBackground.resize(p.width, p.height);
        }

        List<String> fonts = Arrays.asList("Arial", "Verdana", "Courier New", "Georgia", "Times New Roman");
        List<Integer> fontSizes = Arrays.asList(12, 16, 20, 24, 28, 32);
        List<String> highContrastColors = Arrays.asList("Black", "Yellow", "White", "Blue", "Red", "Orange", "Green", "Purple", "Cyan", "Magenta");

        uiManager.initializeUIComponents(fonts, fontSizes, highContrastColors);
    }

    void draw() {
        if (guitarBackground != null) {
            p.image(guitarBackground, 0, 0);
        }
    }

    void toggleSummaryVisibility() {
        isSummaryVisible = !isSummaryVisible;
        uiManager.toggleSessionSummaryVisibility(isSummaryVisible);
    }

    void displaySessionSummary(String summary) {
        uiManager.updateSessionSummary(summary);
        isSummaryVisible = true;
    }

    void updateSpeedLabel(float speed) {
        uiManager.updateSpeedLabel(speed);
    }

    void updateUIForGameState(String gameState) {
        uiManager.updateUIForGameState(gameState);
    }

    void reinitializeDashboardButtons() {
        uiManager.reinitializeDashboardButtons();
    }
}
