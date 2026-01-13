/* 
   Example sketch to show how the glitch filter works in FIP. 
*/

import fip.*; // Import the FIP library

PShader ripple;
PImage image;
float movement = 0.0;


void setup() {
    size(1000, 1000, P3D); // Set up the canvas with a renderer (P3D in this case)
    ripple = loadShader(FIP.ripple);
    ripple.set("rippleFrequency", 10.0);
    image = loadImage("ocean.jpg");
}

void draw() {
    image(image, 0, 0, width, height);
    filter(ripple); // Apply the glitch shader
    ripple.set("rippleAmplitude", map(mouseX, 0, width, 0, 0.05));
    ripple.set("rippleCenterOffset", movement, 0);
    float inc = abs(map(mouseX, 0, 1024, 0, 0.01));
    movement = movement + inc;
}
