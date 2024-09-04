import controlP5.*;
import processing.core.PApplet;

// The SummaryManager class handles the display of the session summary in the game
class SummaryManager {
    PApplet p;                     // Reference to the PApplet instance
    ControlP5 cp5;                 // ControlP5 instance for managing UI components
    Game game;                     // Reference to the Game instance
    Textarea sessionSummary;       // Textarea to display the session summary
    Button summaryButton;          // Button to toggle the visibility of the summary
    boolean isSummaryVisible;      // Flag to track whether the summary is visible

    // Constructor to initialize the SummaryManager
    SummaryManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;                           // Initialize PApplet reference
        this.cp5 = cp5;                            // Initialize ControlP5 instance
        this.game = game;                          // Initialize Game reference
        this.isSummaryVisible = false;             // Default to the summary being hidden
        initializeSummaryComponents();             // Call method to set up UI components
    }

    // Method to initialize the summary button and textarea
    void initializeSummaryComponents() {
        // Create and configure the summary button
        summaryButton = cp5.addButton("summaryButton")
            .setPosition(640, 20)                 // Position near the top right
            .setSize(100, 40)                     // Set size of the button
            .setCaptionLabel("Summary")           // Set button label
            .setVisible(false)                    // Initially hidden, shown when needed
            .addListener(new ControlListener() {  // Add a listener to handle button clicks
                public void controlEvent(ControlEvent event) {
                    toggleSummaryVisibility();    // Toggle the summary visibility when clicked
                }
            });

        // Create and configure the session summary textarea
        sessionSummary = cp5.addTextarea("sessionSummary")
            .setPosition(20, 400)                 // Position near the bottom left
            .setSize(760, 160)                    // Set size of the textarea
            .setFont(p.createFont("Arial", 16))   // Set font for the text
            .setLineHeight(20)                    // Set line height for readability
            .setColor(p.color(0, 0, 0))           // Set text color (black)
            .setColorBackground(p.color(255, 255, 204))  // Set background color (light yellow)
            .setBorderColor(p.color(0, 0, 0))     // Set border color (black)
            .setText("")                          // Initialize with empty text
            .setVisible(false);                   // Initially hidden
    }

    // Method to toggle the visibility of the session summary
    void toggleSummaryVisibility() {
        isSummaryVisible = !isSummaryVisible;     // Toggle the visibility flag
        sessionSummary.setVisible(isSummaryVisible);  // Show or hide the textarea
    }

    // Method to update the session summary with new text
    void updateSessionSummary(String summary) {
        sessionSummary.setText(summary);  // Update the text in the textarea with the provided summary
    }

    // Method to show the summary button
    void showSummaryButton() {
        summaryButton.setVisible(true);   // Make the summary button visible
    }

    // Method to hide the summary button
    void hideSummaryButton() {
        summaryButton.setVisible(false);  // Hide the summary button
    }
}
