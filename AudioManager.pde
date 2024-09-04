import processing.core.PApplet;
import ddf.minim.*;

class AudioManager {
    Minim minim;             // Manages audio loading and playback
    AudioPlayer[] sounds;    // Holds multiple sound files
    int volume;              // Represents the current volume level

    // Constructor initializes Minim and loads sounds
    AudioManager(PApplet p) {
        minim = new Minim(p);           // Initializes Minim
        sounds = new AudioPlayer[6];    // Creates an array for 6 sound files
        loadSounds();                   // Loads sound files into array
        volume = 5;                     // Default volume level set to 5
    }

    // Loads sound files into the array
    void loadSounds() {
        for (int i = 0; i < 6; i++) {
            sounds[i] = minim.loadFile((i + 1) + ".wav");  // Loads files "1.wav" to "6.wav"
        }
    }

    // Plays the sound at the specified index
    void playSound(int index) {
        if (index >= 0 && index < sounds.length) {  // Checks if index is valid
            sounds[index].rewind();  // Rewinds the sound
            sounds[index].play();    // Plays the sound
        }
    }

    // Sets the volume for all sounds
    void setSoundVolume(int volume) {
        this.volume = volume;  // Updates the volume level
        for (AudioPlayer sound : sounds) {
            sound.setGain((volume - 5) * 10);  // Adjusts the sound gain based on volume
        }
    }

    // Returns the current volume level
    int getVolume() {
        return volume;  // Returns volume
    }
}
