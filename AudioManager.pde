import processing.core.PApplet;
import ddf.minim.*;

class AudioManager {
    Minim minim;
    AudioPlayer[] sounds;
    int volume;

    AudioManager(PApplet p) {
        minim = new Minim(p);
        sounds = new AudioPlayer[6];
        loadSounds();
        volume = 5; // Default volume level
    }

    void loadSounds() {
        for (int i = 0; i < 6; i++) {
            sounds[i] = minim.loadFile((i + 1) + ".wav");
        }
    }

    void playSound(int index) {
        if (index >= 0 && index < sounds.length) {
            sounds[index].rewind();
            sounds[index].play();
        }
    }

    void setSoundVolume(int volume) {
        this.volume = volume;
        for (AudioPlayer sound : sounds) {
            sound.setGain((volume - 5) * 10);  // Convert the range to gain (-50 to +50)
        }
    }

    int getVolume() {
        return volume;  // Return the current volume level
    }
}
