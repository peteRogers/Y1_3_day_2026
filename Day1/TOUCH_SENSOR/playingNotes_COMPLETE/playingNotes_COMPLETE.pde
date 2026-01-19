import processing.serial.*;
import processing.sound.*;

Serial myPort;

Float[] arduinoValues = new Float[5];

// One note object per Arduino channel
NoteChannel[] notes = new NoteChannel[5];

// “Delicious chord” stack: Cmaj9(add6) tones across octaves
float[] freqs = {
  261.63, // C4
  329.63, // E4
  392.00, // G4
  493.88, // B4
  587.33  // D5
};

// ADSR settings (seconds)
float ATTACK  = 0.05;
float DECAY   = 0.08;
float SUSTAIN = 0.9;  // sustain level (0..1) * amp
float RELEASE = 0.6;

float AMP = 0.25;      // overall loudness per note (0..1)

void setup() {
  size(1024, 1024);

  printArray(Serial.list());
  try {
    myPort = new Serial(this, Serial.list()[5], 9600);
    myPort.clear();
    myPort.bufferUntil('\n');
  }
  catch (Exception e) {
    println(e);
  }

  // init values
  for (int i = 0; i < arduinoValues.length; i++) {
    arduinoValues[i] = 1.0; // assume "not pressed" initially
  }

  // init note channels
  for (int i = 0; i < notes.length; i++) {
    notes[i] = new NoteChannel(this, freqs[i], AMP, ATTACK, DECAY, SUSTAIN, RELEASE);
  }
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(50);

  // Visuals: show dot when pressed (value == 0)
  for (int i = 0; i < arduinoValues.length; i++) {
    if (isPressed(arduinoValues[i])) {
      ellipse(50*(i+1), height/2, 20, 20);
    }
  }

  // Update note playback (edge-triggered + ADSR)
  for (int i = 0; i < notes.length; i++) {
    notes[i].update(isPressed(arduinoValues[i]));
  }

  drawInterface();
}



// Treat “pressed” as value == 0 (with a tiny tolerance)
boolean isPressed(Float v) {
  if (v == null) return false;
  return abs(v) < 0.0001;
}





// ============================================================
// NOTE CHANNEL CLASS (Oscillator + ADSR + edge-trigger logic)
// ============================================================
class NoteChannel {
  SinOsc osc;

  // envelope settings
  float ampMax;
  float attack;
  float decay;
  float sustainLevel; // 0..1 of ampMax
  float release;

  // state
  boolean wasPressed = false;

  // ADSR state machine
  static final int OFF = 0;
  static final int ATT = 1;
  static final int DEC = 2;
  static final int SUS = 3;
  static final int REL = 4;

  int state = OFF;
  float stateStartTime = 0;
  float currentAmp = 0;
  float releaseStartAmp = 0;

  NoteChannel(PApplet parent, float freq, float ampMax,
              float attack, float decay, float sustainLevel, float release) {
    osc = new SinOsc(parent);
    osc.freq(freq);
    this.ampMax = ampMax;
    this.attack = max(0.0001, attack);
    this.decay = max(0.0001, decay);
    this.sustainLevel = constrain(sustainLevel, 0, 1);
    this.release = max(0.0001, release);
  }

  void update(boolean pressed) {
    // edge-trigger: only react on change
    if (pressed && !wasPressed) {
      noteOn();
    }
    if (!pressed && wasPressed) {
      noteOff();
    }

    // run envelope each frame
    tickEnvelope();

    wasPressed = pressed;
  }

  void noteOn() {
    // start osc if not already
    if (state == OFF) {
      osc.amp(0);
      osc.play();
    }
    // start attack
    state = ATT;
    stateStartTime = millis() / 1000.0;
  }

  void noteOff() {
    // begin release from current amplitude
    if (state != OFF && state != REL) {
      releaseStartAmp = currentAmp;
      state = REL;
      stateStartTime = millis() / 1000.0;
    }
  }

  void tickEnvelope() {
    float t = millis() / 1000.0;
    float dt = t - stateStartTime;

    if (state == OFF) return;

    if (state == ATT) {
      float k = constrain(dt / attack, 0, 1);
      currentAmp = lerp(0, ampMax, k);

      if (k >= 1) {
        state = DEC;
        stateStartTime = t;
      }
    }
    else if (state == DEC) {
      float k = constrain(dt / decay, 0, 1);
      float target = ampMax * sustainLevel;
      currentAmp = lerp(ampMax, target, k);

      if (k >= 1) {
        state = SUS;
        stateStartTime = t;
      }
    }
    else if (state == SUS) {
      currentAmp = ampMax * sustainLevel;
    }
    else if (state == REL) {
      float k = constrain(dt / release, 0, 1);
      currentAmp = lerp(releaseStartAmp, 0, k);

      if (k >= 1) {
        currentAmp = 0;
        osc.amp(0);
        osc.stop();     // stop the oscillator after fade-out
        state = OFF;
        return;
      }
    }

    osc.amp(currentAmp);
  }
}
