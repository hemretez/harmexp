//FOR DEBUGGING & ANALYSIS
//PrintWriter lyinOutputSong; 
//PrintWriter lyinUserData; 
//PrintWriter lyinUserOnlyChords; 


//FOR START STOP PAUSE
boolean last = false;
boolean runTheSketch = true;
boolean startWasPressed = false;
int frameRec = 0;
int nChordsPlayed = 0;
int whichArea = 0;

float attRepThreshold;
//FOR OBJECTS
int tTone = 0; // tonic chord initialization
int numOfChords = 135;
int numOfDiffChords;
int[] elements = new int[numOfChords];
float[] masses = new float[numOfChords];

int isPlayed1 = 0;
int isPlayed2 = 0;
int isPlayed3 = 0;
int locked;

float[][] transArray;

float theDist = 60.0;
float radii = 20.0;
float attractorSize = radii; // attractor size = chord sizes
float bpm =   133.3;
float velocityFactor = 6.0; 
float fRate = 60;
float sec = 1.0*(fRate/bpm);
float tick = 27.0;//round(fRate/(bpm/fRate));
float speedMultiplier = 0.05;
float pulseRadius = 0;
float pulseStroke = 0;
int endNote = -1;
float howmuchwait;

// FOR TIMINGS AND SEQUENTIAL ARRANGEMENT
Integer[] referenceIndex = new Integer[numOfChords];
float[] timeDataToSort = new float[numOfChords];

boolean isMouseOnUI = false;
boolean notOutOfAll;
boolean draggingOne;

//MidiBus myBus; // The MidiBus
//int joyLevel = 0;

//Lyin Eyes 120 BPM - Key: G -> trans down 7    135 chords
  int Yes[][] =
  {{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26},
  {7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26},
  {7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26}};
  
//Transition probabilities will be extracted according to this:
  int TYes[][] = 
  {{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26},
  {7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26},
  {7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7},{0},{21},{26},{7},{0},{21,0},{7},
  {7,0},{7},{16,23},{21,26},
  {7,31},{0,9},{21,26}};
  
//import processing.core.*; 
import java.util.*;
//import java.lang.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

//import themidibus.*; //Import the library
//import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
//import javax.sound.midi.SysexMessage;
//import javax.sound.midi.ShortMessage;

ControlP5 cp5;
DropdownList d1;  
OscP5 oscP5;
NetAddress myRemoteLocation;

Mover[] movers = new Mover[numOfChords];
Attractor a;

void setup() {
  frameRate(fRate);
  //println("tick is: ", tick);
  //lyinOutputSong = createWriter("lyinOutputSong.csv");
  //lyinUserData = createWriter("lyinUserData.txt");
  //lyinUserOnlyChords = createWriter("lyinUserOnlyChords.txt");
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  OscMessage myMessage = new OscMessage("/");
  myMessage.add(new float[] {123, bpm});
  oscP5.send(myMessage, myRemoteLocation);
  
//  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
//  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object

//MAJOR table:
float floatArray[][] = 
{{0.451834665,0.000171866,0.003523245,0.004640371,0.002234253,0.220417633,0.00060153,0.078026983,0.005155968,0.00369511,0.023373722,0.000171866,0.000859328,0,0.046833376,0,0.015296038,0.004038842,0,0.00274985,0,0.067457248,0,0,0.023029991,8.59E-05,0.003007648,0.000171866,0.001288992,0.00274985,0,0.035232448,8.59E-05,0.003265446,0,0},
{0.003134796,0.131661442,0,0.018808777,0,0,0.307210031,0.006269592,0.29153605,0.037617555,0,0,0.031347962,0.018808777,0,0,0,0.02507837,0,0,0,0,0.103448276,0,0.003134796,0.003134796,0,0,0,0,0,0,0.018808777,0,0,0},
{0.09939759,0,0.246987952,0,0.003012048,0.075301205,0,0.177710843,0,0.156626506,0.003012048,0,0,0,0.009036145,0,0,0,0.015060241,0.003012048,0,0.177710843,0,0,0,0,0.006024096,0,0,0,0,0.015060241,0,0.012048193,0,0},
{0.161490683,0.034161491,0.01242236,0.086956522,0,0.335403727,0,0.00931677,0.133540373,0,0.071428571,0,0.00931677,0,0,0,0.00621118,0.074534161,0,0.01552795,0.01863354,0,0.00621118,0,0.00931677,0,0,0,0,0.00310559,0,0,0.01242236,0,0,0},
{0.067307692,0,0,0,0.25,0.115384615,0.125,0.067307692,0,0.038461538,0,0,0,0,0,0,0,0,0,0,0,0.336538462,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.379781421,0.000303582,0.002580449,0.010473588,0.000607165,0.185944141,0,0.238919247,0.002580449,0.000303582,0.036581664,0,0.002884032,0,0.024438373,0,0.016241651,0.009562842,0,0.000758956,0,0.027018822,0.000607165,0,0.030661809,0,0.004250152,0,0.000910747,0.001821494,0,0.02140255,0.000151791,0.000910747,0.000303582,0},
{0.02247191,0.434456929,0,0.04494382,0,0.029962547,0.052434457,0.003745318,0.063670412,0.003745318,0,0.194756554,0,0,0,0,0,0.007490637,0,0,0.08988764,0,0.011235955,0,0,0.018726592,0,0.003745318,0,0,0,0,0.018726592,0,0,0},
{0.397821454,0.000236798,0.009235141,0.001894388,0.000710395,0.207672271,0.002367985,0.246744021,0.002604783,0.000236798,0.013734312,0,0.000236798,0,0.020838267,0,0.01089273,0.000473597,0,0.000236798,0,0.054463651,0,0.000710395,0.000947194,0,0,0,0.000947194,0.002604783,0,0.023206251,0,0.001183992,0,0},
{0.096385542,0.277108434,0,0.027108434,0.021084337,0.039156627,0.045180723,0.045180723,0.153614458,0,0.13253012,0,0.063253012,0,0,0,0,0.036144578,0,0.009036145,0,0,0.009036145,0,0.021084337,0,0,0.003012048,0,0,0,0.021084337,0,0,0,0},
{0.090909091,0.025252525,0.287878788,0,0,0.116161616,0,0.04040404,0,0.353535354,0.015151515,0,0,0,0,0,0,0,0,0,0,0,0,0.015151515,0,0,0.02020202,0,0,0,0,0,0.035353535,0,0,0},
{0.216753927,0,0.00104712,0.017801047,0,0.459685864,0,0.036649215,0.002094241,0.003141361,0.120418848,0,0.008376963,0,0.003141361,0,0,0,0,0.018848168,0,0.030366492,0.002094241,0,0.014659686,0,0,0,0,0.009424084,0,0.054450262,0.00104712,0,0,0},
{0.010752688,0,0,0.021505376,0.010752688,0,0.903225806,0,0,0,0.010752688,0.043010753,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.027972028,0.048951049,0,0.125874126,0,0.167832168,0.013986014,0,0.034965035,0,0.027972028,0,0.440559441,0,0,0,0,0.062937063,0,0.027972028,0,0,0,0,0,0,0.013986014,0,0,0,0,0.006993007,0,0,0,0},
{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.245575221,0,0,0.001474926,0.004424779,0.196165192,0,0.151179941,0,0,0.018436578,0,0,0,0.192477876,0.003687316,0.031710914,0,0,0,0,0.018436578,0,0,0.003687316,0,0,0,0,0,0,0.12020649,0.001474926,0.011061947,0,0},
{0,0,0,0,0,0,0.625,0,0,0,0,0,0,0,0,0.1875,0.1875,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.078333333,0,0,0.005,0,0.303333333,0,0.063333333,0,0.001666667,0,0.013333333,0,0,0.216666667,0,0.178333333,0,0,0.003333333,0,0.108333333,0,0.013333333,0.008333333,0,0.001666667,0,0,0.001666667,0,0,0,0.003333333,0,0},
{0.379464286,0,0.017857143,0.084821429,0,0.03125,0,0.125,0,0,0.066964286,0,0.026785714,0,0,0.035714286,0,0.151785714,0,0,0,0,0,0,0.004464286,0,0.017857143,0,0,0,0,0.035714286,0,0,0.022321429,0},
{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.345238095,0,0.011904762,0.095238095,0,0.202380952,0,0,0.05952381,0,0.130952381,0,0,0,0.071428571,0,0,0,0,0.083333333,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.037037037,0,0,0.074074074,0,0,0,0,0,0,0,0.444444444,0,0,0,0,0,0,0,0,0.444444444,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0.153157895,0,0.044210526,0,0.008421053,0.245263158,0,0.145789474,0.003157895,0.003157895,0.013684211,0,0.001052632,0,0.053684211,0,0.055263158,0.011578947,0,0.003157895,0,0.235789474,0,0.000526316,0,0,0.02,0,0.001052632,0,0,0.000526316,0.000526316,0,0,0},
{0.018867925,0.452830189,0,0.075471698,0,0,0.245283019,0,0.018867925,0,0,0.056603774,0,0,0,0,0,0,0,0,0,0,0.113207547,0,0,0,0,0.018867925,0,0,0,0,0,0,0,0},
{0.12,0,0,0,0.04,0,0,0,0,0.04,0,0,0,0,0,0,0.32,0,0.04,0,0,0.04,0,0.4,0,0,0,0,0,0,0,0,0,0,0,0},
{0.033061594,0.002264493,0,0.02173913,0,0.106884058,0,0.000452899,0.005887681,0,0.048913043,0,0,0,0.001811594,0,0,0.000452899,0,0,0,0.001358696,0,0,0.620471014,0.000452899,0.007246377,0,0,0.09057971,0,0.057065217,0,0,0.001358696,0},
{0,0.033333333,0,0,0.2,0,0.033333333,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.7,0,0,0,0,0,0,0.033333333,0,0,0},
{0.143410853,0,0.011627907,0,0,0.046511628,0,0.108527132,0,0,0.031007752,0,0,0,0.054263566,0,0,0,0,0,0,0,0,0,0.023255814,0,0.213178295,0,0,0.096899225,0,0.271317829,0,0,0,0},
{0,0.090909091,0,0,0,0,0,0,0.090909091,0,0,0,0,0,0.181818182,0,0,0,0,0,0,0,0,0,0.090909091,0,0,0.545454545,0,0,0,0,0,0,0,0},
{0.03125,0,0,0,0,0.34375,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.34375,0,0,0,0,0,0,0.15625,0,0,0,0,0.125,0,0},
{0.165454545,0,0,0.021818182,0,0.010909091,0,0.001818182,0.007272727,0,0,0,0,0,0.001818182,0,0,0.001818182,0,0,0,0,0,0,0.4,0,0.056363636,0,0,0.289090909,0,0.036363636,0,0,0.007272727,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,0,0,0.5,0,0,0},
{0.460182371,0,0,0,0.004863222,0.045592705,0,0.007902736,0,0,0,0,0.000607903,0,0.009118541,0,0.000607903,0,0,0,0,0.02006079,0,0,0.05775076,0,0.002431611,0,0,0.061398176,0,0.329483283,0,0,0,0},
{0,0.483870968,0,0,0,0,0.161290323,0,0.032258065,0,0,0,0,0,0,0,0,0.064516129,0,0,0,0,0,0,0,0,0,0,0,0,0.064516129,0.129032258,0.064516129,0,0,0},
{0,0,0.034482759,0,0,0,0,0.022988506,0,0.034482759,0.034482759,0,0,0,0.24137931,0,0.022988506,0,0,0,0,0,0,0,0,0,0.459770115,0,0,0,0,0,0,0.149425287,0,0},
{0.206896552,0,0,0,0,0,0,0,0,0,0,0,0,0,0.034482759,0,0,0,0,0,0,0,0,0,0.24137931,0,0,0,0,0,0,0,0,0,0.517241379,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}};

//floatArray = transposeArray(floatArray);
floatArray = logMyArray(floatArray);

  // transposes all chords to an absolute degree, so that the key of the song will be 0
  TYes = transposeNotes(Yes, TYes, -7);
  
  int ii = 0;
  for  (int i = 0; i < Yes.length; i++) {
    for  (int k = 0; k < Yes[i].length; k++) {
      elements[ii] = Yes[i][k];
      ii++;
    }}
    
  int iii = 1;
  for(int i=0;i<elements.length;i++){
    boolean isDistinct = false;
    for(int j=0;j<i;j++){
       if(elements[i] == elements[j]){
          isDistinct = true;
            break;
            }
            }
        if(!isDistinct){
            numOfDiffChords = iii;
            iii = iii+1;
            }
        }

  // this size is selected, because it fits to my tablet well
  size(900, 580);
  
  cp5 = new ControlP5(this);

  PImage[] imgs_play = {loadImage("button_a.png"),loadImage("button_b.png"),loadImage("button_c.png")};
  cp5.addButton("play")
     .setValue(1234)
     .setPosition(845,5)
     .setImages(imgs_play)
     .updateSize()
     ;
     
    PImage[] imgs_pause = {loadImage("button_a_ps.png"),loadImage("button_b_ps.png"),loadImage("button_c_ps.png")}; 
    cp5.addButton("pause")
     .setValue(1235)
     .setPosition(845,60)
     .setImages(imgs_pause)
     .updateSize()
     ;
     
  d1 = cp5.addDropdownList("myList-d1")
          .setSize(132,100)
          .setPosition(758, 485)

          ;
  customize(d1); // customize the first list

  cp5.addSlider("speed")
     //.setBroadcast(false)
     .setRange(0.005, 0.1)
     .setPosition(20, 350)
     .setSize(20, 180)
     //.setBroadcast(true)
     .setValue(0.05)
     ;
     
  tTone = Yes[0][0];
  a = new Attractor(tTone);
  
  float cont = 0;
  int m = 0; 
  int howmanybeats = 0; 
  int dummy1 = 0;
  int dummy2 = 0;
  float forAngle = 0;
  int ik = 0;
  int tik = 0;
  for  (int i = 0; i < Yes.length; i++) {
    for  (int k = 0; k < Yes[i].length; k++) {

      cont = cont + floatArray[TYes[dummy1][dummy2]][TYes[i][k]];
      masses[m] = floatArray[TYes[dummy1][dummy2]][TYes[i][k]];
      //lyinOutputSong.println(masses[m]+","+TYes[dummy1][dummy2]+","+TYes[i][k]+","+Yes[dummy1][dummy2]+","+Yes[i][k]);
      
      dummy1 = i; 
      dummy2 = k;
      m++;
    }}
    
  m = 0; 
  dummy1 = 0;
  dummy2 = 0;
  
    for  (int i = 0; i < Yes.length; i++) {
    for  (int k = 0; k < Yes[i].length; k++) {
      
      if (Yes[i].length == 1){howmanybeats = 4;}
      else if (Yes[i].length == 2){howmanybeats = 2;}
      else if (Yes[i].length == 4){howmanybeats = 1;}
      
      ik = Yes[i][k]; //this variable, ik, will be passed to movers as TYPE. they're not transposed, because it will be used just to play chords
      tik = TYes[i][k]; //this variable, tik, will be passed to movers as the determiner actual progression relationships. they're transposed

      if (ik == 7){forAngle = 0;}
      else if (ik == 0){forAngle = 30;}
      else if (ik == 31){forAngle = 100;}
      else if (ik == 26){forAngle = 140;}
      else if (ik == 21){forAngle = 210;}
      else if (ik == 16){forAngle = 240;}
      else if (ik == 23){forAngle = 270;}
      else if (ik == 9){forAngle = 330;}
      
      if ( (m == 0) && (i == 0) && (k == 0) ){

      movers[m] = new Mover(masses[m],ik, tik,
      width/2 + cos(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+4*k)*sec+(radii+radii)/2), 
      height/2 + sin(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+4*k)*sec+(radii+radii)/2),
      dummy1,dummy2,m,howmanybeats
      ); 
    }

      else {     
    
    if ( Yes[i].length == 1 ){
  movers[m] = new Mover(masses[m],ik, tik,
  width/2 + cos(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+4*k)*sec+(radii+radii)/2), 
  height/2 + sin(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+4*k)*sec+(radii+radii)/2),
  i,k,m,howmanybeats
  );
}
    else if ( Yes[i].length == 2 ){
  movers[m] = new Mover(masses[m],ik, tik,
  width/2 + cos(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+2*k)*sec+(radii+radii)/2), 
  height/2 + sin(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+2*k)*sec+(radii+radii)/2),
  i,k,m,howmanybeats
  );
}
    else if ( Yes[i].length == 4 ){
  movers[m] = new Mover(masses[m],ik, tik,
  width/2 + cos(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+k)*sec+(radii+radii)/2), 
  height/2 + sin(radians(forAngle))*(velocityFactor*fRate*masses[m]*((i+1)*4-3+k)*sec+(radii+radii)/2),
  i,k,m,howmanybeats
  );
}
    }

    if ( (i == Yes.length-1) && (k == Yes[i].length-1) ){endNote = m;}
      dummy1 = i;
      dummy2 = k;
      m++;
    }}
//       for (int z = 0; z < movers.length; z++) {
//         println(z,"  ",movers[z].playtype,"  ",movers[z].progtype,"  ",movers[z].mass,"  ",movers[z].time," howmany: ", movers[z].manybeats);
//     }  
  transArray = floatArray;
  
  for (int j = 0; j < movers.length; j++) {referenceIndex[j] = j;}   
//noLoop();
}

void displayAll() {
  
  a.display();
  for (int n = 0; n < movers.length; n++) {
    if (movers[n].played == false) movers[n].display(a.attract(movers[n]));
  }          
}

void interactAll() {

  a.drag();
  a.hover(mouseX, mouseY);
  
  for (int n = 0; n < movers.length; n++) {
    if (movers[n].played == false) {
    
    movers[locked].drag();
    movers[n].hover(mouseX, mouseY);
    }
  }
}

void draw() { 

  isMouseOnUI = cp5.isMouseOver();
  cp5.show();
  cp5.update();

  background(0);
  pushMatrix();

  //saveFrame("frames/####.png"); 
  if(runTheSketch){
  
  shiftMovers(); 

  for (int n = 0; n < movers.length; n++) {

    if (movers[n].played == false){
      if (a.dragging==false) {movers[n].update(a.attract(movers[n]));}
    
      for (int m = 0; m < movers.length; m++) {
        timeDataToSort[m] = movers[m].time;
      }
    
      if (last == true && a.dragging == false){
        sortMyAss();
        int hasan = 0;
      
        for(int zxc = movers.length-1; zxc >= 0; zxc--){ 
          if(movers[referenceIndex[zxc]].played == false) {hasan = movers[referenceIndex[zxc]].manybeats + 1;}
        }
        for(int www = 0; www < movers.length; www++){ 
          //println(www," ",movers[www].distance," ",movers[www].time," ",movers[www].progtype);
          if(movers[referenceIndex[www]].played) { }
          else {           
            movers[referenceIndex[www]].mass = (movers[referenceIndex[www]].distance - radii ) / (velocityFactor * (hasan) * tick - velocityFactor *(frameCount%tick) ); 
            hasan += movers[referenceIndex[www]].manybeats;
          } 
        } 
      }
      last = a.dragging;
      movers[n].playit(); 
      }  

    isPlayed1 = (movers[n].isPlayeda[0]);
    isPlayed2 = (movers[n].isPlayeda[1]);
    isPlayed3 = (movers[n].isPlayeda[2]);
    
//    if (movers[endNote].isPlayeda[0]==1){
//      OscMessage lastMessage = new OscMessage("/");
//      lastMessage.add(new float[] {123, 0});
//      oscP5.send(lastMessage, myRemoteLocation);}
    }
  }

  if (startWasPressed && frameCount%30==frameRec){
    runTheSketch = true;
    startWasPressed = false;
  } 
  interactAll();
  displayAll();
  //lyinUserData.println(a.dragging+" "+float(frameCount)+" "+a.posX+" "+a.posY+" "+a.speed+" "+whichArea+" "+nChordsPlayed+" "+joyLevel); 
  popMatrix();
}


void mousePressed() {
  a.clicked(mouseX, mouseY);
  for (int k = 0; k < numOfChords; k++) {
    movers[k].clicked(mouseX, mouseY);
  }
}

void mouseReleased() {
  a.stopDragging();
  for (int k = 0; k < numOfChords; k++) {
    movers[k].stopDragging();
  }
}

void shiftMovers(){
  //ellipse( mouseX, mouseY, 5, 5 );
  textSize(12);
//  text(  "area: " + whichArea+" x: " + a.posX + " y: " + a.posY+ " J:"+ joyLevel, width/2-60, height-20 );
  if ((mousePressed)&&(a.dragging)&&(isMouseOnUI == false)){
    for (int k = 0; k < movers.length; k++) {
      movers[k].location.x = movers[k].location.x-(mouseX-width/2)*speedMultiplier ;
      movers[k].location.y = movers[k].location.y-(mouseY-height/2)*speedMultiplier ;
    }
      a.speed = mag((mouseX-width/2)*speedMultiplier, (mouseY-height/2)*speedMultiplier );
      a.posX = a.posX +(mouseX-width/2)*speedMultiplier;
      a.posY = a.posY -(mouseY-height/2)*speedMultiplier;
  } 
}

void mouseDragged() {
  boolean notOutOfAll = false;
  if (a.mousedist < 0) {notOutOfAll = true;}  
  for (int i = 0; i < movers.length; i++) {      
    if (movers[i].mousedist < 0) {
    notOutOfAll = true;
    }
  }
  boolean draggingOne = false; 
  for (int i = 0; i < movers.length; i++) {      
    if (movers[i].dragging == true) {
      draggingOne = true;
    }
  }
// if (notOutOfAll == true) {}
//      else if ((a.dragging == false)&&(draggingOne == false)&&(isMouseOnUI == false)){
//          a.location.x = a.location.x+(mouseX-pmouseX) ;
//          a.location.y = a.location.y+(mouseY-pmouseY) ;
//        for (int k = 0; k < movers.length; k++) {
//          movers[k].location.x = movers[k].location.x+(mouseX-pmouseX) ;
//          movers[k].location.y = movers[k].location.y+(mouseY-pmouseY) ;
//        }
//      }   
}
  
void sortMyAss() {
   Arrays.sort(referenceIndex, new Comparator<Integer>() {
    @Override public int compare(final Integer o3, final Integer o4) {
        return Float.compare(timeDataToSort[o3], timeDataToSort[o4]);} } );      
}

public static float[][] transposeArray(float[][] m) {
  float[][] temp = new float[m[0].length][m.length];
  for (int i = 0; i < m.length; i++)
    for (int j = 0; j < m[0].length; j++)
      if ( m[i][j] != 0){
        temp[j][i] = m[i][j]; }
      else { temp[j][i] = 0; }
  return temp;
}

public static float[][] logMyArray(float[][] m) {
  float[][] temp = new float[m[0].length][m.length];
  for (int i = 0; i < m.length; i++)
    for (int j = 0; j < m[0].length; j++)
      if ( m[i][j] != 0){
        temp[i][j] = log(1+log(1+log(1+log(1+log(m[i][j]+1.3)))));} 
      else { temp[i][j] = 0; }
  return temp;
}

public static int[][] transposeNotes(int[][] realMatrix ,int[][] transedMatrix, int transposeFactor) {

  for (int i = 0; i < realMatrix.length; i++){
    for (int j = 0; j < realMatrix[i].length; j++){
      
      int mod = realMatrix[i][j]/12;
      if ( (realMatrix[i][j]%12 + transposeFactor) < 0){
        transedMatrix[i][j] = (realMatrix[i][j]%12 + transposeFactor + 12) + mod*12;
      }
      else if ( (realMatrix[i][j]%12 + transposeFactor) > 11) {
        transedMatrix[i][j] = (realMatrix[i][j]%12 + transposeFactor - 12) + mod*12;
      }
      else if ( ( (realMatrix[i][j]%12 + transposeFactor) > -1)&&( (realMatrix[i][j]%12 + transposeFactor) <  12) ){
        transedMatrix[i][j] = (realMatrix[i][j]%12 + transposeFactor) + mod*12;
      }
      mod = 0;
      
    }
  }
  return transedMatrix;
}

public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getName());
    if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

public void play(int theVal) {
  //println("a button event from buttonB: ",theVal);
  if (theVal == 1234 ){startWasPressed=true;}
    else {runTheSketch = false;}
}
public void pause(int theVal) {
  //println("a button event from buttonB: ",theVal);
  if (theVal == 1235){startWasPressed = false;runTheSketch = false;frameRec=frameCount%30;}
}
void speed(float thespd) {
  speedMultiplier = thespd;
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("Songs");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.addItem("Higher Ground ", 0);
  ddl.addItem("Lyin' Eyes ", 1);
  ddl.addItem("Something About You ",2);
  ddl.addItem("A Hard Day's Night",3);
  ddl.addItem("Riders On The Storm", 4);
  ddl.addItem("The Ways Of A Woman In Love ", 5);
  for (int i=6;i<40;i++) {
    ddl.addItem("song  "+i, i);
  }
  ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}


void keyPressed() {
  if (key=='q') {
    //lyinOutputSong.flush(); // Writes the remaining data to the file
    //lyinOutputSong.close(); // Finishes the file
    
    //lyinUserData.flush(); // Writes the remaining data to the file
    //lyinUserData.close(); // Finishes the file
    
    //lyinUserOnlyChords.flush(); // Writes the remaining data to the file
    //lyinUserOnlyChords.close(); // Finishes the file

    OscMessage myMessage = new OscMessage("/");
    myMessage.add(new float[] {123, 111});
    oscP5.send(myMessage, myRemoteLocation);
    
    exit(); // Stops the program
  }
  if (key=='s') {noLoop();}
  if (key=='c') {loop();}
}

//void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
//    joyLevel = (int)(message.getMessage()[2] & 0xFF)-63;
//}
