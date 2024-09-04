import processing.core.PApplet;
import processing.core.PImage;
import java.util.Arrays;
import java.util.List;

// Dashboard class to manage the UI components and background for the game
class Dashboard {
    PApplet p;              // Reference to the main PApplet (Processing) instance
    UIManager uiManager;    // Instance of UIManager to handle UI components
    Game game;              // Reference to the Game object
    PImage guitarBackground; // Image for the guitar background

    // Constructor for the Dashboard class
    Dashboard(PApplet parent, Game game) {
        this.p = parent;                   // Initialize PApplet reference
        this.game = game;                  // Initialize Game reference
        this.uiManager = new UIManager(parent, game, this); // Initialize UIManager

        // Load the guitar background image
        guitarBackground = p.loadImage("guitar_background.jpg");
        if (guitarBackground != null) {
            guitarBackground.resize(p.width, p.height); // Resize the background to fit the screen
        }

        // List of fonts, font sizes, and high-contrast colors for UI components
        List<String> fonts = Arrays.asList("Arial", "Algerian", "Comic Sans MS Bold", "Verdana", "Courier New", "Georgia", "Times New Roman");
        List<Integer> fontSizes = Arrays.asList(12, 16, 20, 24, 28, 32);
        List<String> highContrastColors = Arrays.asList("Black", "Yellow", "Blue", "Red", "Orange", "Green", "Purple", "Cyan", "Magenta");

        // Initialize UI components with the provided fonts, sizes, and colors
        uiManager.initializeUIComponents(fonts, fontSizes, highContrastColors);
    }

    // Method to draw the dashboard (currently, it sets a background color)
    void draw() {
        // Set the background color to a specific RGB value (dark color)
        p.background(17, 24, 36);
    }

    // Method to update the speed label in the UI
    void updateSpeedLabel(float speed) {
        uiManager.updateSpeedLabel(speed); // Delegate to UIManager
    }

    // Method to update the UI components based on the current game state
    void updateUIForGameState(String gameState) {
        uiManager.updateUIForGameState(gameState); // Delegate to UIManager
    }

    // Method to reinitialize the dashboard buttons, possibly after a game state change
    void reinitializeDashboardButtons() {
        uiManager.reinitializeDashboardButtons(); // Delegate to UIManager
    }
}





//import processing.core.PApplet;
//import java.util.ArrayList;
//import java.util.List;

//class Dashboard {
//    PApplet p;
//    UIManager uiManager;
//    Game game;

//    List<MusicalNote> notes;  // List to store the musical notes

//    Dashboard(PApplet parent, Game game) {
//        this.p = parent;
//        this.game = game;
//        this.uiManager = new UIManager(parent, game, this);

//        List<String> fonts = Arrays.asList("Arial", "Verdana", "Courier New", "Georgia", "Times New Roman");
//        List<Integer> fontSizes = Arrays.asList(12, 16, 20, 24, 28, 32);
//        List<String> highContrastColors = Arrays.asList("Black", "Yellow", "White", "Blue", "Red", "Orange", "Green", "Purple", "Cyan", "Magenta");

//        uiManager.initializeUIComponents(fonts, fontSizes, highContrastColors);

//        notes = new ArrayList<>();
//        createMusicalNotes(10);  // Create 10 notes
//    }

//    void draw() {
//        // Set the background color
//        p.background(17, 24, 36);

//        // Update and draw the musical notes
//        for (MusicalNote note : notes) {
//            note.update();
//            note.display();
//        }
//    }

//    void createMusicalNotes(int count) {
//        for (int i = 0; i < count; i++) {
//            float x = p.random(p.width);
//            float y = p.random(p.height);
//            float speedX = p.random(-0.5f, 0.5f);  // Slow movement on x-axis
//            float speedY = p.random(-0.5f, 0.5f);  // Slow movement on y-axis
//            int noteType = p.floor(p.random(3));  // Randomly choose a note type
//            notes.add(new MusicalNote(p, x, y, speedX, speedY, noteType));
//        }
//    }

//    void updateSpeedLabel(float speed) {
//        uiManager.updateSpeedLabel(speed);
//    }

//    void updateUIForGameState(String gameState) {
//        uiManager.updateUIForGameState(gameState);
//    }

//    void reinitializeDashboardButtons() {
//        uiManager.reinitializeDashboardButtons();
//    }
//}

//class MusicalNote {
//    PApplet p;
//    float x, y;
//    float speedX, speedY;
//    int noteType;

//    MusicalNote(PApplet p, float x, float y, float speedX, float speedY, int noteType) {
//        this.p = p;
//        this.x = x;
//        this.y = y;
//        this.speedX = speedX;
//        this.speedY = speedY;
//        this.noteType = noteType;
//    }

//    void update() {
//        x += speedX;
//        y += speedY;

//        // Wrap around the screen edges
//        if (x < 0) x = p.width;
//        if (x > p.width) x = 0;
//        if (y < 0) y = p.height;
//        if (y > p.height) y = 0;
//    }

//    void display() {
//        p.fill(255);  // White color for the notes
//        p.noStroke();

//        switch (noteType) {
//            case 0: // Eighth Note
//                drawEighthNote();
//                break;
//            case 1: // Quarter Note
//                drawQuarterNote();
//                break;
//            case 2: // Half Note
//                drawHalfNote();
//                break;
//        }
//    }

//    void drawEighthNote() {
//        p.ellipse(x, y, 20, 20);  // The note head
//        p.rect(x + 5, y - 40, 5, 40);  // The stem
//        p.triangle(x + 10, y - 40, x + 20, y - 50, x + 15, y - 40);  // The flag
//    }

//    void drawQuarterNote() {
//        p.ellipse(x, y, 20, 20);  // The note head
//        p.rect(x + 5, y - 40, 5, 40);  // The stem
//    }

//    void drawHalfNote() {
//        p.ellipse(x, y, 30, 20);  // The note head
//        p.rect(x + 10, y - 40, 5, 40);  // The stem
//    }
//}
