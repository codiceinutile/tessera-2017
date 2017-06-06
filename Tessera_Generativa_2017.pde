/*
 * Codice Inutile
 * Script Tessera Generativa 2017
 *
 * Inspired by Matt Pearson's book: Generative Art
 * ISBN: 978-1935182627
*/

float xstart, xnoise, ynoise, lunghezza;
Table soci, inDesign;

void setup() {
  // --- GENERAL SETUP
  size(1004, 650);
  pixelDensity(2);
  noLoop();
  colorMode(HSB);
  smooth();
  // --- CREATE CSV FILE FOR INDSEGIN
  inDesign = new Table();
  inDesign.addColumn("#");
  inDesign.addColumn("Nome");
  inDesign.addColumn("Cognome");
  inDesign.addColumn("@Tessera");
  // --- DRAW THE FILE
  soci = loadTable("soci.csv");
   for(int i = 1; i < soci.getRowCount(); i++) {
    int numTessera = soci.getInt(i, 0);
    String nomeSocio = soci.getString(i, 1)+" "+soci.getString(i, 2);
    drawTessera(numTessera, nomeSocio);
    // ADD ROW INDESIGN
    TableRow newRow = inDesign.addRow();
    newRow.setInt("#", numTessera);
    newRow.setString("Nome", soci.getString(i, 1));
    newRow.setString("Cognome", soci.getString(i, 2));
    newRow.setString("@Tessera", "Macintosh HD"+sketchPath("").replace("/",":")+"data:images:"+numTessera+"_"+nomeSocio+".png");
    // END ROW INDESIGN 
  }
  saveTable(inDesign, "data/inDesign.csv");
  exit();
}

void draw() {
}

void drawTessera(int number, String name) {
  background(getBackgroundColor(name));
  stroke(getStrokeColor(getBackgroundColor(name)), 150);
  lunghezza = name.length();
  xstart = number;
  xnoise = xstart;
  ynoise = random(10); 
  for (int y=0; y<=height; y+=lunghezza/2) {
    ynoise += 0.1;
    xnoise = xstart; 
    for (int x=0; x<=width; x+=lunghezza/2) {
      xnoise += 0.1;
      drawPoint(x, y, noise(xnoise, ynoise));
    }
  }
  println(number+"_"+name+".png");
  save("data/images/"+number+"_"+name+".png");
}

void drawPoint(float x, float y, float noiseFactor) {
  pushMatrix();
  translate(x, y);
  rotate(noiseFactor * radians(360));
  line(0, 0, lunghezza*2, 0);
  popMatrix();
}

color getBackgroundColor(String s) {
  int sum = 0;
  String[] list = split(s.toLowerCase(), ' ');  
  for(int i = 0; i < list.length; i++) {
    sum += int(list[i].charAt(0));
  }
  int range = int(map(sum, 194, 244, 0, 255));
  return color(range, 255, 255);
}

color getStrokeColor(color c) {
  // Calculating color contrast
  // https://24ways.org/2010/calculating-color-contrast
  float yiq = ((red(c)*299)+(green(c)*587)+(blue(c)*114))/1000;
  if(yiq  >= 128) {
    return(color(#000000));
  } else {
    return(color(#FFFFFF));
  }
}