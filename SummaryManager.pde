import controlP5.*;
import processing.core.PApplet;

class SummaryManager {
    PApplet p;
    ControlP5 cp5;
    Game game;
    Textarea sessionSummary;
    Button summaryButton;
    boolean isSummaryVisible;

    SummaryManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;
        this.cp5 = cp5;
        this.game = game;
        this.isSummaryVisible = false; // Default to not showing the summary
        initializeSummaryComponents();
    }

    void initializeSummaryComponents() {
        summaryButton = cp5.addButton("summaryButton")
            .setPosition(640, 20)
            .setSize(100, 40)
            .setCaptionLabel("Summary")
            .setVisible(false)  // Initially hidden, will be shown when needed
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    toggleSummaryVisibility();  // Toggle visibility when clicked
                }
            });

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

    void toggleSummaryVisibility() {
        isSummaryVisible = !isSummaryVisible;
        sessionSummary.setVisible(isSummaryVisible);
    }

    void updateSessionSummary(String summary) {
        sessionSummary.setText(summary);
        // The summary text is updated, but it only becomes visible when toggled
    }

    void showSummaryButton() {
        summaryButton.setVisible(true);
    }

    void hideSummaryButton() {
        summaryButton.setVisible(false);
    }
}
