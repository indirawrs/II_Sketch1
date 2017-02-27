//load movie + make some weird shit

import processing.video.*;

PImage prevFrame;
float threshold = 50;
color trackColor;

Movie video;

void setup() {
  size(320, 240);
  video = new Movie(this, "spin.mov");
  video.loop();
  prevFrame = createImage(320, 240, RGB);
  trackColor = color(0, 255, 0);
}

void movieEvent(Movie video) {
  video.read();
}

void draw() {
  //float worldRecord = 500; 
  video.loadPixels();
  prevFrame.loadPixels();
  image(video, 0, 0);

  //  //walk thru pixels
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color currentColor = video.pixels[loc];      // Step 2, what is the current color
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);


      if (diff > threshold) { 
        // If motion, display black
        //pixels[loc] = color(255);
        fill(10,b2);
        stroke(205,random(180),150,20);
        ellipse(b2, b1, r1, r2*g1);
        
        //} else {
        ////  If not, display white
        // pixels[loc] = color(25);
      }
    }
  }
  updatePixels();
}
//// Ratio of mouse X over width
//float ratio = mouseX / (float) width;

//// The jump() function allows you to jump immediately to a point of time within the video. 
//// duration() returns the total length of the movie in seconds.  
//video.jump(ratio * video.duration()); 