// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-12: Simple background removal

// Click the mouse to memorize a current background image
import processing.video.*;

// Variable for capture device
Capture video;

// Saved background
PImage backgroundImage;
PImage scaleMe;

// How different must a pixel be to be a foreground pixel
float threshold = 55; 

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  // Create an empty image the same size as the video
  backgroundImage = createImage(video.width, video.height, RGB);
  scaleMe = createImage(video.width, video.height, RGB*2);
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  // We are looking at the video's pixels, the memorized backgroundImage's pixels, as well as accessing the display pixels. 
  // So we must loadPixels() for all!
  loadPixels();
  video.loadPixels(); 
  backgroundImage.loadPixels();
  scaleMe.loadPixels();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color

      // Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];

      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = fgColor;
      } else {
        // If not, display green
        pixels[loc] = bgColor; // its replaced with the backgorund lol ghosts
      }
    }
  }
  updatePixels();
  for (int i = 0; i < video.width; i++) {  //idk im trying to do something with drawing shapes and shit
    // Begin loop for rows
    for (int j = 0; j < video.height; j++) {

      // Where are we, pixel-wise?
      int x = i * 12;
      int y = j * 12;
      // Looking up the appropriate color in the pixel array
      color c = scaleMe.pixels[i + j * video.width];
      fill(c);
      stroke(11);
      rect(x, y, c/2, c);
    }
  }
}

void mousePressed() {
  // x, y, width, and height of region to be copied from the source
  // x, y, width, and height of copy destination
  backgroundImage.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  tint(0, 255, 50); //this changes the colors that are absent/missing. the higher the values, the less of my pale ass is visible
  backgroundImage.updatePixels();
}