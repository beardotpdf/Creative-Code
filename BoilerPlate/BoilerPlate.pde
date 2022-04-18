import processing.svg.*;
import processing.pdf.*;

// Set the width and height of your screen canvas in pixels
final int CONFIG_WIDTH_PIXELS = 900;
final int CONFIG_HEIGHT_PIXELS = 900;

/*
 * When generating high-resolution images, the CONFIG_SCALE_FACTOR
 * is used as the multiplier for the number of pixels. (e.g, a canvas
 * of 1000x1000px with a scale factor of 5 gives a 5000x5000px image)
 */
int CONFIG_SCALE_FACTOR = 10;
int CONFIG_NUM_XTILES = 2;
int CONFIG_NUM_YTILES = 2;


/*
 * Originally written and published by sighack
 * https://github.com/sighack/processing-boilerplate/blob/master/code/boilerplate/scaffold.pde
 * https://github.com/sighack
 * https://sighack.com
 *
 * Adapted by Bear.pdf
 * Notablly switching all methods to HSB, dropping gcode support (for this varient), adding datename and increasing seed values
 *
 * This is to be applied in conjunction to all creative coding projects in processing, allowing for the omission of
 * setup, draw, settings, and output methods
 * The only requirement is render();
 */


/*
 * =========================================================
 * =========================================================
 * Ignore everything below this line! Just press '?' while
 * your sketch is running to get a list of available options
 * to export your sketch into various formats.
 * =========================================================
 * =========================================================
 */

int seed;
String datename = setDatename();


void settings() {
  size(CONFIG_WIDTH_PIXELS, CONFIG_HEIGHT_PIXELS);
} // close settings method


void setup() {
  colorMode(HSB, 360, 100, 100, 100); // 0:red,90:yellow,180:white?,270:blue
  seed = millis() * second();
  seededRender();
} // close setup method


void draw() {
} // close draw method


void seededRender() {
  randomSeed(seed);
  noiseSeed(seed);
  render();
} // close seededRender method


void keyPressed() {
  switch(key) {
  case ESC:
    exit();
    break;
  case 'l':
    saveLowRes();
    break;
  case 'h':
    saveHighRes(CONFIG_SCALE_FACTOR);
    break;
  case 't':
      saveHighResTiled(CONFIG_SCALE_FACTOR, CONFIG_NUM_XTILES, CONFIG_NUM_YTILES);
      break;
  case 'p':
    savePDF();
    break;
  case 's':
    saveSVG();
    break;
  case 'n':
    //generate new seed & generate new image
    seed = millis() * second();
    seededRender();
    break;
  case '?':
    shortcuts();
  }
} // close keyPressed method


void saveLowRes() {
  println("Saving low-resolution image...");
  save("output/" + datename + "-lowres-" + seed + ".png");
  println("saved output/" + datename + "-lowres-" + seed + ".png");
} // close saveLowRes method


void saveHighRes(int scaleFactor) {
  PGraphics hiRes = createGraphics( 
    width * scaleFactor, 
    height * scaleFactor, 
    JAVA2D);
  hiRes.colorMode(HSB, 360, 100, 100, 100); 
  println("Saving high-resolution image...");
  beginRecord(hiRes);
  hiRes.scale(scaleFactor);
  seededRender();
  endRecord();
  hiRes.save("output/" + datename + "-highres-" + seed + ".png");
  println("Saved output/" + datename + "-highres-" + seed + ".png");
} // close saveHighRes method


void saveHighResTiled(int scaleFactor, int nxtiles, int nytiles) {
  int tWidth = width / nxtiles;
  int tHeight = height / nytiles;
  for (int i = 0; i < nxtiles; i++) {
    for (int j = 0; j < nytiles; j++) {
      PGraphics hiRes = createGraphics(
                        tWidth * scaleFactor,
                        tHeight * scaleFactor,
                        JAVA2D);
      println("Saving high-resolution tile: " + j + ", " + i);
      beginRecord(hiRes);
      hiRes.scale(scaleFactor);
      pushMatrix();
      hiRes.colorMode(HSB, 360, 100, 100, 100);
      translate(- i * tWidth, - j * tHeight);
      seededRender();
      popMatrix();
      endRecord();
      hiRes.save("tiles/" + seed + "-tile-" + j + "-" + i + ".png");
      println("Saved tiles/ " + seed + "-tile-" + j + "-" + i + ".png");
    }
  }
  println("Finished");
} // close saveHighResTiled method


void savePDF() {
  println("Saving PDF image...");
  beginRecord(PDF, "output/" + datename + "-vector-" + seed + ".pdf");
  colorMode(HSB, 360, 100, 100, 100);
  seededRender();
  endRecord();
  println("Saved output/" + datename + "-vector-" + seed + ".pdf");
}


void saveSVG() {
  println("Saving SVG image...");
  beginRecord(SVG, "output/" + datename + "-vector-" + seed + ".svg");
  colorMode(HSB, 360, 100, 100, 100);
  seededRender();
  endRecord();
  println("Saved output/" + datename + "-vector-" + seed + ".svg");
}


void shortcuts() {
  println("Keyboard shortcuts:");
  println("    n: Generate a new seeded image");
  println("    l: Save low-resolution image");
  println("    h: Save high-resolution image");
  println("    t: Save tiled, high-resolution image");
  println("    p: Save PDF version");
  println("    s: Save SVG version");
  println("  ESC: Exit sketch without saving");
  println("space: Stop animated sketch on frame");
} // close shortcuts method


String setDatename() {
  String datename = "";
  int[] dateIn = new int[5];
  dateIn[0] = month();
  dateIn[1] = day();
  dateIn[2] = hour();
  dateIn[3] = minute();
  dateIn[4] = second();
  String[] dateOut = new String[5];
  for (int i = 0; i < 5; i++) {
    if (dateIn[i] < 10) {
      dateOut[i] = "0" + String.valueOf(dateIn[i]);
    } else {
      dateOut[i] = String.valueOf(dateIn[i]);
    }
    datename += dateOut[i];
  }
  return datename;
} // close setDatename method
