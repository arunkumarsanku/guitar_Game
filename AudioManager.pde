import processing.core.PApplet;
import ddf.minim.*;

class AudioManager {
    Minim minim;             // The Minim object used to manage audio loading and playback
    AudioPlayer[] sounds;    // Array to hold multiple AudioPlayer objects for different sound files
    int volume;              // Integer to represent the current volume level

    // Constructor to initialize the AudioManager
    AudioManager(PApplet p) {
        minim = new Minim(p);           // Initialize Minim with the PApplet context
        sounds = new AudioPlayer[6];    // Create an array to hold 6 different audio files
        loadSounds();                   // Load the sound files into the array
        volume = 5;                     // Set the default volume level to 5 (mid-range)
    }

    // Method to load sound files into the sounds array
    void loadSounds() {
        for (int i = 0; i < 6; i++) {
            sounds[i] = minim.loadFile((i + 1) + ".wav");  // Load each sound file named "1.wav", "2.wav", etc.
        }
    }

    // Method to play a sound at a given index
    void playSound(int index) {
        if (index >= 0 && index < sounds.length) {  // Check if the index is within the valid range
            sounds[index].rewind();  // Rewind the sound to the beginning before playing
            sounds[index].play();    // Play the sound at the specified index
        }
    }

    // Method to set the volume for all sounds
    void setSoundVolume(int volume) {
        this.volume = volume;  // Update the volume instance variable with the new value
        for (AudioPlayer sound : sounds) {
            sound.setGain((volume - 5) * 10);  // Adjust the gain based on volume (-50 to +50 dB range)
        }
    }

    // Method to get the current volume level
    int getVolume() {
        return volume;  // Return the current volume level
    }
}
