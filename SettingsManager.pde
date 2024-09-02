import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class SettingsManager {
    PApplet p;
    ControlP5 cp5;
    Game game;
    int fontSize;
    PFont boldFont;

    Slider cursorSizeSlider;
    Slider volumeSlider;  // Slider for volume control
    DropdownList nodeColorDropdown, cursorColorDropdown, fontSelector, fontSizeSelector, backgroundColorDropdown;

    String selectedFont;
    int selectedFontSize;

    SettingsManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;
        this.cp5 = cp5;
        this.game = game;
        this.fontSize = 12; // Default font size
        this.boldFont = p.createFont("Verdana Bold", fontSize); // Create a bold font
    }

    void initializeSettingsPanel(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        // Adjust the positions and sizes to fit the UI
        int dropdownWidth = 150;
        int dropdownHeight = 30;
        int dropdownListVisibleItems = 4;  // Limit to 4 visible items in the dropdown list

        // RGB color for the background of settings items
        int settingsBackgroundColor = p.color(5, 36, 89);

        cursorSizeSlider = cp5.addSlider("cursorSizeSlider")
            .setPosition(450, 130)
            .setSize(200, dropdownHeight)
            .setRange(10, 50) // Define the cursor size range
            .setValue(game.getCursorSize()) // Initialize with the current cursor size
            .setLabel("Cursor Size")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(cursorSizeSlider)) {
                        float newSize = cursorSizeSlider.getValue();
                        game.setCursorSize(newSize); // Update the cursor size in the Game class
                    }
                }
            });

        volumeSlider = cp5.addSlider("volumeSlider") // Slider for volume control
            .setPosition(130, 130)
            .setSize(200, dropdownHeight)
            .setRange(1, 10) // Define the volume range
            .setValue(game.getAudioManager().getVolume()) // Initialize with the current volume level
            .setLabel("Sound+/-")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(volumeSlider)) {
                        int newVolume = (int) volumeSlider.getValue();
                        game.getAudioManager().setSoundVolume(newVolume); // Update the volume in the AudioManager class
                    }
                }
            });

        nodeColorDropdown = cp5.addDropdownList("nodeColorDropdown")
            .setPosition(130, 180)
            .setSize(dropdownWidth, dropdownHeight)
            .setBarHeight(dropdownHeight)
            .setItemHeight(dropdownHeight)
            .setHeight(dropdownHeight * dropdownListVisibleItems) // Set height to display only 4 items
            .setOpen(false)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Node Color")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(nodeColorDropdown)) {
                        String selectedColorName = highContrastColors.get((int) event.getValue());
                        int selectedColor = getColorFromName(selectedColorName);
                        game.setNodeCol(selectedColor); // Update the node color in the Game class
                        updateDropdownAppearance(nodeColorDropdown, selectedColor);
                    }
                }
            });

        cursorColorDropdown = cp5.addDropdownList("cursorColorDropdown")
            .setPosition(310, 180)
            .setSize(dropdownWidth, dropdownHeight)
            .setBarHeight(dropdownHeight)
            .setItemHeight(dropdownHeight)
            .setHeight(dropdownHeight * dropdownListVisibleItems) // Set height to display only 4 items
            .setOpen(false)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Cursor Color")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(cursorColorDropdown)) {
                        String selectedColorName = highContrastColors.get((int) event.getValue());
                        int selectedColor = getColorFromName(selectedColorName);
                        game.setCursorCol(selectedColor); // Update the cursor color in the Game class
                        updateDropdownAppearance(cursorColorDropdown, selectedColor);
                    }
                }
            });

        fontSelector = cp5.addDropdownList("fontSelector")
            .setPosition(130, 360)
            .setSize(dropdownWidth + 20, dropdownHeight)
            .setBarHeight(dropdownHeight)
            .setItemHeight(dropdownHeight)
            .setHeight(dropdownHeight * dropdownListVisibleItems) // Set height to display only 4 items
            .setOpen(false)
            .setItems(fonts.toArray(new String[0]))
            .setLabel("Font Selector")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    selectedFont = fonts.get((int) event.getValue());
                    applyFontSettings();
                }
            });

        fontSizeSelector = cp5.addDropdownList("fontSizeSelector")
            .setPosition(310, 360)
            .setSize(dropdownWidth, dropdownHeight)
            .setBarHeight(dropdownHeight)
            .setItemHeight(dropdownHeight)
            .setHeight(dropdownHeight * dropdownListVisibleItems) // Set height to display only 4 items
            .setOpen(false)
            .setItems(fontSizes.stream().map(String::valueOf).toArray(String[]::new))
            .setLabel("Font Size Selector")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    selectedFontSize = fontSizes.get((int) event.getValue());
                    applyFontSettings();
                }
            });

        backgroundColorDropdown = cp5.addDropdownList("backgroundColorDropdown")
            .setPosition(490, 180)
            .setSize(dropdownWidth + 20 , dropdownHeight)
            .setBarHeight(dropdownHeight)
            .setItemHeight(dropdownHeight)
            .setHeight(dropdownHeight * dropdownListVisibleItems) // Set height to display only 4 items
            .setOpen(false)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Background Color")
            .setFont(boldFont) // Use bold font for the caption label
            .setColorBackground(settingsBackgroundColor)  // Set the background color
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    String selectedColorName = highContrastColors.get((int) event.getValue());
                    int selectedColor = getColorFromName(selectedColorName);
                    game.setBackgroundCol(selectedColor);
                    updateDropdownAppearance(backgroundColorDropdown, selectedColor);
                }
            });
    }

    void applyFontSettings() {
        if (selectedFont != null && selectedFontSize > 0) {
            game.updateFont(selectedFont, selectedFontSize);

            Textlabel speedLabel = cp5.get(Textlabel.class, "speedLabel");
            if (speedLabel != null) {
                speedLabel.setFont(p.createFont(selectedFont, selectedFontSize));
            }

            Textarea helpLabel = cp5.get(Textarea.class, "helpLabel");
            if (helpLabel != null) {
                helpLabel.setFont(p.createFont(selectedFont, selectedFontSize));
            }

            Textarea sessionSummary = cp5.get(Textarea.class, "sessionSummary");
            if (sessionSummary != null) {
                sessionSummary.setFont(p.createFont(selectedFont, selectedFontSize));
            }
        }
    }

    void toggleSettingsVisibility() {
        boolean isVisible = cursorSizeSlider.isVisible();

        cursorSizeSlider.setVisible(!isVisible);
        volumeSlider.setVisible(!isVisible);
        nodeColorDropdown.setVisible(!isVisible);
        cursorColorDropdown.setVisible(!isVisible);
        fontSelector.setVisible(!isVisible);
        fontSizeSelector.setVisible(!isVisible);
        backgroundColorDropdown.setVisible(!isVisible);
    }

    void updateDropdownAppearance(DropdownList dropdown, int selectedColor) {
        // Update the background color for the dropdown items and active item
        dropdown.setColorBackground(selectedColor);
        dropdown.setColorActive(selectedColor);

        // Update the caption label's color and appearance
        Label captionLabel = dropdown.getCaptionLabel();
        captionLabel.setFont(boldFont); // Apply bold font to the caption label
        captionLabel.setColorBackground(selectedColor); // Set the background color
        captionLabel.setColor(selectedColor == p.color(0, 0, 0) ? p.color(255, 255, 255) : p.color(0, 0, 0)); // Adjust text color for contrast
    }

    int getColorFromName(String colorName) {
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
                return p.color(255, 255, 255);
        }
    }
}
