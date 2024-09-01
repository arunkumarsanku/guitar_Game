import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class SettingsManager {
    PApplet p;
    ControlP5 cp5;
    Game game;

    Slider cursorSizeSlider;
    Slider volumeSlider;  // Slider for volume control
    DropdownList nodeColorDropdown, cursorColorDropdown, fontSelector, fontSizeSelector, backgroundColorDropdown;

    String selectedFont;
    int selectedFontSize;

    SettingsManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;
        this.cp5 = cp5;
        this.game = game;
    }

    void initializeSettingsPanel(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        cursorSizeSlider = cp5.addSlider("cursorSizeSlider")
            .setPosition(150, 400)
            .setSize(200, 40)
            .setRange(10, 50) // Define the cursor size range
            .setValue(game.getCursorSize()) // Initialize with the current cursor size
            .setLabel("Cursor Size")
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
            .setPosition(150, 200)
            .setSize(200, 40)
            .setRange(1, 10) // Define the volume range
            .setValue(game.getAudioManager().getVolume()) // Initialize with the current volume level
            .setLabel("Sound Volume")
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
            .setPosition(150, 250)
            .setSize(200, 100)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Node Color")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(nodeColorDropdown)) {
                        String selectedColorName = highContrastColors.get((int) event.getValue());
                        int selectedColor = getColorFromName(selectedColorName);
                        game.setNodeCol(selectedColor); // Update the node color in the Game class
                    }
                }
            });

        cursorColorDropdown = cp5.addDropdownList("cursorColorDropdown")
            .setPosition(150, 300)
            .setSize(200, 100)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Cursor Color")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(cursorColorDropdown)) {
                        String selectedColorName = highContrastColors.get((int) event.getValue());
                        int selectedColor = getColorFromName(selectedColorName);
                        game.setCursorCol(selectedColor); // Update the cursor color in the Game class
                    }
                }
            });

        cursorSizeSlider = cp5.addSlider("cursorSizeSlider")
            .setPosition(150, 400)
            .setSize(200, 40)
            .setRange(10, 50) // Define the cursor size range
            .setValue(game.getCursorSize()) // Initialize with the current cursor size
            .setLabel("Cursor Size")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    if (event.isFrom(cursorSizeSlider)) {
                        float newSize = cursorSizeSlider.getValue();
                        game.setCursorSize(newSize); // Update the cursor size in the Game class
                    }
                }
            });

        fontSelector = cp5.addDropdownList("fontSelector")
            .setPosition(150, 450)
            .setSize(200, 100)
            .setItems(fonts.toArray(new String[0]))
            .setLabel("Font Selector")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    selectedFont = fonts.get((int) event.getValue());
                    applyFontSettings();
                }
            });

        fontSizeSelector = cp5.addDropdownList("fontSizeSelector")
            .setPosition(150, 500)
            .setSize(200, 100)
            .setItems(fontSizes.stream().map(String::valueOf).toArray(String[]::new))
            .setLabel("Font Size Selector")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    selectedFontSize = fontSizes.get((int) event.getValue());
                    applyFontSettings();
                }
            });

        backgroundColorDropdown = cp5.addDropdownList("backgroundColorDropdown")
            .setPosition(150, 550)
            .setSize(200, 100)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Background Color")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    String selectedColorName = highContrastColors.get((int) event.getValue());
                    int selectedColor = getColorFromName(selectedColorName);
                    game.setBackgroundCol(selectedColor);
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
        if (cursorSizeSlider != null) {
            boolean isCursorSizeVisible = cursorSizeSlider.isVisible();
            cursorSizeSlider.setVisible(!isCursorSizeVisible);
        }

        if (volumeSlider != null) {
            boolean isVolumeSliderVisible = volumeSlider.isVisible();
            volumeSlider.setVisible(!isVolumeSliderVisible);
        }

        if (nodeColorDropdown != null) {
            boolean isNodeColorVisible = nodeColorDropdown.isVisible();
            nodeColorDropdown.setVisible(!isNodeColorVisible);
        }

        if (cursorColorDropdown != null) {
            boolean isCursorColorVisible = cursorColorDropdown.isVisible();
            cursorColorDropdown.setVisible(!isCursorColorVisible);
        }

        if (fontSelector != null) {
            boolean isFontSelectorVisible = fontSelector.isVisible();
            fontSelector.setVisible(!isFontSelectorVisible);
        }

        if (fontSizeSelector != null) {
            boolean isFontSizeSelectorVisible = fontSizeSelector.isVisible();
            fontSizeSelector.setVisible(!isFontSizeSelectorVisible);
        }

        if (backgroundColorDropdown != null) {
            boolean isBackgroundColorVisible = backgroundColorDropdown.isVisible();
            backgroundColorDropdown.setVisible(!isBackgroundColorVisible);
        }
    }

    int getColorFromName(String colorName) {
        switch (colorName) {
            case "Black":
                return p.color(0, 0, 0);
            case "Yellow":
                return p.color(255, 255, 0);
            case "White":
                return p.color(255, 255, 255);
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
