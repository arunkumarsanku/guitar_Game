import ddf.minim.*;
import processing.core.PApplet;

class AudioManager {
    Minim minim;
    AudioPlayer[] sounds;

    AudioManager(PApplet p) {
        minim = new Minim(p);
        sounds = new AudioPlayer[6];
        loadSounds();
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
        for (AudioPlayer sound : sounds) {
            sound.setGain((volume - 1) * 10);
        }
    }
}
