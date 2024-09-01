

import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class SettingsManager {
    PApplet p;
    ControlP5 cp5;
    Game game;

    Range soundRange;
    DropdownList nodeColorDropdown, cursorColorDropdown, fontSelector, fontSizeSelector, backgroundColorDropdown;
    Slider cursorSizeSlider;

    String selectedFont;
    int selectedFontSize;

    SettingsManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;
        this.cp5 = cp5;
        this.game = game;
    }

    void initializeSettingsPanel(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        soundRange = cp5.addRange("soundRange")
            .setPosition(150, 200)
            .setSize(200, 40)
            .setRange(1, 10)
            .setValue(5)
            .setLabel("Sound Volume")
            .setVisible(false);

        nodeColorDropdown = cp5.addDropdownList("nodeColorDropdown")
            .setPosition(150, 250)
            .setSize(200, 100)
            .setItems(highContrastColors.toArray(new String[0]))
            .setLabel("Node Color")
            .setVisible(false)
            .addListener(new ControlListener() {
                public void controlEvent(ControlEvent event) {
                    String selectedColorName = highContrastColors.get((int) event.getValue());
                    int selectedColor = getColorFromName(selectedColorName);
                    game.setNodeCol(selectedColor);
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
                    String selectedColorName = highContrastColors.get((int) event.getValue());
                    int selectedColor = getColorFromName(selectedColorName);
                    game.setCursorCol(selectedColor);
                }
            });

        cursorSizeSlider = cp5.addSlider("cursorSizeSlider")
            .setPosition(150, 400)
            .setSize(200, 40)
            .setRange(10, 50)
            .setValue(20)
            .setLabel("Cursor Size")
            .setVisible(false);

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
            cp5.get(Textlabel.class, "speedLabel").setFont(p.createFont(selectedFont, selectedFontSize));
            cp5.get(Textarea.class, "helpLabel").setFont(p.createFont(selectedFont, selectedFontSize));
            cp5.get(Textarea.class, "sessionSummary").setFont(p.createFont(selectedFont, selectedFontSize));
        }
    }

    void toggleSettingsVisibility() {
        boolean isVisible = soundRange.isVisible();
        soundRange.setVisible(!isVisible);
        nodeColorDropdown.setVisible(!isVisible);
        cursorColorDropdown.setVisible(!isVisible);
        cursorSizeSlider.setVisible(!isVisible);
        fontSelector.setVisible(!isVisible);
        fontSizeSelector.setVisible(!isVisible);
        backgroundColorDropdown.setVisible(!isVisible);
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
