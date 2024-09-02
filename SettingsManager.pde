import controlP5.*;
import processing.core.PApplet;
import java.util.List;

class SettingsManager {
    PApplet p;
    ControlP5 cp5;
    Game game;
    PFont boldFont;
    Slider cursorSizeSlider, volumeSlider;
    DropdownList nodeColorDropdown, cursorColorDropdown, fontSelector, fontSizeSelector, backgroundColorDropdown;
    String selectedFont;
    int selectedFontSize;

    SettingsManager(PApplet parent, ControlP5 cp5, Game game) {
        this.p = parent;
        this.cp5 = cp5;
        this.game = game;
        this.boldFont = p.createFont("Verdana Bold", 12); // Create a bold font once and reuse
    }

    void initializeSettingsPanel(List<String> fonts, List<Integer> fontSizes, List<String> highContrastColors) {
        // Define colors and dimensions once to avoid recalculation
        int dropdownWidth = 150;
        int dropdownHeight = 30;
        int dropdownListVisibleItems = 4;
        int settingsBackgroundColor = p.color(5, 36, 89);

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

        nodeColorDropdown = createColorDropdown("nodeColorDropdown", 130, 180, dropdownWidth, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Node Color", settingsBackgroundColor, colValue -> game.setNodeCol(colValue));
        cursorColorDropdown = createColorDropdown("cursorColorDropdown", 310, 180, dropdownWidth, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Cursor Color", settingsBackgroundColor, colValue -> game.setCursorCol(colValue));
        fontSelector = createFontDropdown("fontSelector", 130, 360, dropdownWidth + 20, dropdownHeight, dropdownListVisibleItems, fonts, "Font Selector", settingsBackgroundColor);
        fontSizeSelector = createFontSizeDropdown("fontSizeSelector", 310, 360, dropdownWidth, dropdownHeight, dropdownListVisibleItems, fontSizes, "Font Size Selector", settingsBackgroundColor);
        backgroundColorDropdown = createColorDropdown("backgroundColorDropdown", 490, 180, dropdownWidth + 20, dropdownHeight, dropdownListVisibleItems, highContrastColors, "Background Color", settingsBackgroundColor, colValue -> game.setBackgroundCol(colValue));
    }

    void applyFontSettings() {
        if (selectedFont != null && selectedFontSize > 0) {
            PFont newFont = p.createFont(selectedFont, selectedFontSize);
            game.updateFont(selectedFont, selectedFontSize);

            cp5.getAll().stream()
                .filter(controller -> controller instanceof Textlabel || controller instanceof Textarea)
                .forEach(controller -> {
                    controller.setFont(newFont);
                    if (controller instanceof Textlabel) {
                        ((Textlabel) controller).setFont(newFont);
                    } else if (controller instanceof Textarea) {
                        ((Textarea) controller).setFont(newFont);
                    }
                });
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

    private DropdownList createColorDropdown(String name, int x, int y, int width, int height, int visibleItems, List<String> colors, String label, int backgroundColor, java.util.function.Consumer<Integer> colorChangeCallback) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(colors.toArray(new String[0]))
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

    private DropdownList createFontDropdown(String name, int x, int y, int width, int height, int visibleItems, List<String> fonts, String label, int backgroundColor) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(fonts.toArray(new String[0]))
            .setLabel(label)
            .setFont(boldFont)
            .setColorBackground(backgroundColor)
            .setVisible(false)
            .addListener(event -> {
                selectedFont = fonts.get((int) event.getValue());
                applyFontSettings();
            });
    }

    private DropdownList createFontSizeDropdown(String name, int x, int y, int width, int height, int visibleItems, List<Integer> fontSizes, String label, int backgroundColor) {
        return cp5.addDropdownList(name)
            .setPosition(x, y)
            .setSize(width, height)
            .setBarHeight(height)
            .setItemHeight(height)
            .setHeight(height * visibleItems)
            .setOpen(false)
            .setItems(fontSizes.stream().map(String::valueOf).toArray(String[]::new))
            .setLabel(label)
            .setFont(boldFont)
            .setColorBackground(backgroundColor)
            .setVisible(false)
            .addListener(event -> {
                selectedFontSize = fontSizes.get((int) event.getValue());
                applyFontSettings();
            });
    }

    private void updateDropdownAppearance(DropdownList dropdown, int selectedColor) {
        dropdown.setColorBackground(selectedColor);
        dropdown.setColorActive(selectedColor);

        Label captionLabel = dropdown.getCaptionLabel();
        captionLabel.setFont(boldFont);
        captionLabel.setColorBackground(selectedColor);
        captionLabel.setColor(selectedColor == p.color(0, 0, 0) ? p.color(255, 255, 255) : p.color(0, 0, 0));
    }

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
                return p.color(255, 255, 255);
        }
    }
}
