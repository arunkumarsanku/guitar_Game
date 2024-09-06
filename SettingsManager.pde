import controlP5.*;
import processing.core.PApplet;
import java.util.List;

// The SettingsManager class manages the settings panel in the game, allowing the user to customize various game settings
class SettingsManager {
    PApplet p;                     // Reference to the PApplet instance
    ControlP5 cp5;                 // ControlP5 instance for managing UI components
    Game game;                     // Reference to the Game instance
    PFont boldFont;                // Bold font used in the settings panel
    Slider cursorSizeSlider, volumeSlider;  // Sliders for cursor size and volume
    DropdownList nodeColorDropdown, cursorColorDropdown, fontSelector, fontSizeSelector, backgroundColorDropdown;  // Dropdown lists for various settings
    String selectedFont;           // Selected font name from the font selector
    int selectedFontSize;          // Selected font size from the font size selector

    // Constructor to initialize the SettingsManager
    SettingsManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;                             // Initialize PApplet reference
        this.cp5 = cp5;                              // Initialize ControlP5 instance
        this.game = game;                            // Initialize Game reference
        this.boldFont = p.createFont("Verdana Bold", 12);  // Create a bold font for the settings UI
    }

    // Method to initialize the settings panel with available fonts, font sizes, and high-contrast colors
    void initializeSettingsPanel(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        // Define colors and dimensions for UI elements to avoid recalculation
        int dropdownWidth = 150;
        int dropdownHeight = 30;
        int dropdownListVisibleItems = 4;
        int settingsBackgroundColor = p.color(5, 36, 89);

        // Create and configure the cursor size slider
        cursorSizeSlider = cp5.addSlider("cursorSizeSlider")
            .setPosition(450, 130)
            .setSize(200, dropdownHeight)
            .setRange(10, 50)
            .setValue(game.getCursorSize())
            .setLabel("Cursor Size")
            .setFont(boldFont)
            .setColorBackground(settingsBackgroundColor)
            .setVisible(false)
            .addListener(event -> game.setCursorSize(cursorSizeSlider.getValue()));

        // Create and configure the volume slider
        volumeSlider = cp5.addSlider("volumeSlider")
            .setPosition(130, 130)
            .setSize(200, dropdownHeight)
            .setRange(1, 10)
            .setValue(game.getAudioManager().getVolume())
            .setLabel("Sound+/-")
            .setFont(boldFont)
            .setColorBackground(settingsBackgroundColor)
            .setVisible(false)
            .addListener(event -> game.getAudioManager().setSoundVolume((int) volumeSlider.getValue()));

        // Create dropdowns for node color, cursor color, font selection, font size, and background color
        nodeColorDropdown = createColorDropdown("nodeColorDropdown", 130, 180, dropdownWidth, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Node Color", settingsBackgroundColor, colValue -> game.setNodeCol(colValue));
        cursorColorDropdown = createColorDropdown("cursorColorDropdown", 310, 180, dropdownWidth, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Cursor Color", settingsBackgroundColor, colValue -> game.setCursorCol(colValue));
        fontSelector = createFontDropdown("fontSelector", 130, 360, dropdownWidth + 20, dropdownHeight, dropdownListVisibleItems, fonts, "Font Selector", settingsBackgroundColor);
        fontSizeSelector = createFontSizeDropdown("fontSizeSelector", 310, 360, dropdownWidth, dropdownHeight, dropdownListVisibleItems, fontSizes, "Font Size Selector", settingsBackgroundColor);
        backgroundColorDropdown = createColorDropdown("backgroundColorDropdown", 490, 180, dropdownWidth + 20, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Background Color", settingsBackgroundColor, colValue -> game.setBackgroundCol(colValue));
    }

    
    // Method to apply the selected font settings to the game and UI components
void applyFontSettings() {
    if (selectedFont != null && selectedFontSize > 0) {
        PFont newFont = p.createFont(selectedFont, selectedFontSize);
        game.updateFont(selectedFont, selectedFontSize);

        // Trigger recalculation of the background boxes for the labels
        game.drawScoreBox();
        game.drawSpeedBox();

        // Apply the new font to all relevant UI components
        cp5.getAll().stream()
            .filter(controller -> controller instanceof Textlabel || controller instanceof Textarea)
            .forEach(controller -> {
                controller.setFont(newFont);
            });
    }
}


    // Method to toggle the visibility of the settings panel
    void toggleSettingsVisibility() {
        boolean isVisible = cursorSizeSlider.isVisible();  // Check the current visibility state
        cursorSizeSlider.setVisible(!isVisible);           // Toggle visibility for cursor size slider
        volumeSlider.setVisible(!isVisible);               // Toggle visibility for volume slider
        nodeColorDropdown.setVisible(!isVisible);          // Toggle visibility for node color dropdown
        cursorColorDropdown.setVisible(!isVisible);        // Toggle visibility for cursor color dropdown
        fontSelector.setVisible(!isVisible);               // Toggle visibility for font selector
        fontSizeSelector.setVisible(!isVisible);           // Toggle visibility for font size selector
        backgroundColorDropdown.setVisible(!isVisible);    // Toggle visibility for background color dropdown
    }

    // Helper method to create a color dropdown list
    private DropdownList createColorDropdown(String name, int x, int y, int width, int height, int visibleItems, List<String> colors, String label, int backgroundColor, java.util.function.Consumer<Integer> colorChangeCallback) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(colors.toArray(new String[0]))  // Populate dropdown with color names
            .setLabel(label)
            .setFont(boldFont)
            .setColorBackground(backgroundColor)
            .setVisible(false)
            .addListener(event -> {
                String selectedColorName = colors.get((int) event.getValue());
                int selectedColor = getColorFromName(selectedColorName);
                colorChangeCallback.accept(selectedColor);
                updateDropdownAppearance((DropdownList) event.getController(), selectedColor);
            });
    }

    // Helper method to create a font dropdown list
    private DropdownList createFontDropdown(String name, int x, int y, int width, int height, int visibleItems, List<String> fonts, String label, int backgroundColor) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(fonts.toArray(new String[0]))  // Populate dropdown with font names
            .setLabel(label)
            .setFont(boldFont)
            .setColorBackground(backgroundColor)
            .setVisible(false)
            .addListener(event -> {
                selectedFont = fonts.get((int) event.getValue());
                applyFontSettings();  // Apply font settings when a new font is selected
            });
    }

    // Helper method to create a font size dropdown list
    private DropdownList createFontSizeDropdown(String name, int x, int y, int width, int height, int visibleItems, List<Integer> fontSizes, String label, int backgroundColor) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(fontSizes.stream().map(String::valueOf).toArray(String[]::new))  // Populate dropdown with font sizes
            .setLabel(label)
            .setFont(boldFont)
            .setColorBackground(backgroundColor)
            .setVisible(false)
            .addListener(event -> {
                selectedFontSize = fontSizes.get((int) event.getValue());
                applyFontSettings();  // Apply font settings when a new font size is selected
            });
    }

    // Method to update the appearance of a dropdown based on the selected color
    private void updateDropdownAppearance(DropdownList dropdown, int selectedColor) {
        dropdown.setColorBackground(selectedColor);
        dropdown.setColorActive(selectedColor);

        Label captionLabel = dropdown.getCaptionLabel();
        captionLabel.setFont(boldFont);
        captionLabel.setColorBackground(selectedColor);
        captionLabel.setColor(selectedColor == p.color(0, 0, 0) ? p.color(255, 255, 255) : p.color(0, 0, 0));  // Adjust text color based on background
    }

    // Helper method to convert a color name to a color value
    private int getColorFromName(String colorName) {
        switch (colorName) {
            case "Black":
                return p.color(0, 0, 0);
            case "Yellow":
                return p.color(255, 255, 0);
            case "Blue":
                return p.color(0, 0, 255);
            case "Red":
                return p.color(255, 0, 0);
            case "Orange":
                return p.color(255, 165, 0);
            case "Green":
                return p.color(0, 255, 0);
            case "Purple":
                return p.color(128, 0, 128);
            case "Cyan":
                return p.color(0, 255, 255);
            case "Magenta":
                return p.color(255, 0, 255);
            default:
                return p.color(255, 255, 255);  // Default to white if no match
        }
    }
}
