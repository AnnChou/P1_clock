/*
    Processing 2.2.1 Script
    Author:      Ann Chou
    Date:        06-Oct-2017
    Assignment:  Project One: Build a Cool Clock
    Minimun Requirements:   display the progress of time in a non-traditional way.  
                            give a sense of the passage of time in multiple scales 
    
*/

void setup() {
  size(640, 640);
  rectMode(CENTER);  
  
}

void draw() {
  
  float current_ctr_x = width/2;
  float current_ctr_y = height/2;
  PImage bgdPhoto = loadImage("courtyard01b_7575.png");
  
  float ms = millis();
  float s = second();  // Values from 0 - 59
  float m = minute();  // Values from 0 - 59
  float h = hour();    // Values from 0 - 23
  
  background(5, 5, 125, 255); 
 //m =2;
 // m = 20;
// m = 20; s = 40; h = 0;  // group of edge appears in bottom area.
 //m = 20; s = 40; h = 11;
  //**** begin  unit-test data
//  h=0; //for unit-test
//  h=1;
//  h=2;
//  h=3;
//  h=5; //for unit-test
//    h=6;
//h = 7;
//h= 8;
//    h=22;
// h=23; //for unit-test



  // variables for sec and minute behaviour
  float full_cir = s * m;
  float cir_r = 100;
  int step = 6;
  float edge_length = 150;

  float path_start = current_ctr_x - 50 - edge_length/2;
  float path_end = current_ctr_x + 50 - edge_length/2;
  float m_pos = map(m, 0, 59, path_start, path_end);

  // variables for hour behaviour    
  float popsicle_width = 150;  
  int s_bar_width = 50;
  float stick_height = 150;
  //float s_pos = map(s, 0, 60, 0, 400);  //do I need this?
    
  // hardcode current_ctr or ??? - each hour has different location 
  float h_pos_x = map(h+m/60, 0, 24, edge_length + popsicle_width, width-edge_length); // move linearly
  float h_pos_y = map(h+m/60, 0, 24, edge_length, height-edge_length);  // move linearly
  
  float h_12hr = h%12;  // I only want to show 0 - 11 (or 1 - 12?) popsicles
  float h_rot = map(h_12hr+m/60, 0, 12, -0.5*PI, 0.5*PI);  // need to tweak more

 
  
  // set centre for groups of edge (minutes/ sec related)
  current_ctr_x = h_pos_x;
  current_ctr_y = cos(h_pos_y)*(height-edge_length)+ edge_length;  //now change to a up-and-down path like cosine
  
  float bottom_popsicle_x = popsicle_width/2; // fixed 
  float bottom_popsicle_y = current_ctr_y + edge_length /2;// set as the same level as the groups of edges
 
  // in case it needs wrapping
  if (current_ctr_y < edge_length) {
    current_ctr_y = edge_length;
  }
  if (current_ctr_y > height - edge_length) {
    current_ctr_y = height - edge_length;
  }
  if (bottom_popsicle_y < stick_height + 160) {
    bottom_popsicle_y = stick_height + 160;
  }
  if (bottom_popsicle_y > height - stick_height) {
    bottom_popsicle_y = height - stick_height;
  }
  
 
  // sticking a centre photo -- not sure if it is a good design
  float imageSize = 75;
  float image_top_left_x = current_ctr_x - imageSize - 10;
  float image_top_left_y = current_ctr_y - imageSize/2;
  pushMatrix();
  translate(image_top_left_x, image_top_left_y);
  //rotate(HALF_PI);
  image(bgdPhoto, 0 , 0);
  noFill();
  strokeWeight(3);
  ellipse(0 + imageSize/2, 0 + imageSize/2, 72, 72); // do not need this ellipse
  popMatrix(); 
  

  
  // Setting 2 groups of edges (minutes and sec behaviours)
  // renew each minute (as the second == 0)
  // more edges as the "m" value increases
  // first group of edges
  // full_cir = s * m (max = 360), step = 6 ==> max no edge = 60
  pushMatrix();
  translate (current_ctr_x - 50, current_ctr_y);
  for (int i = 0; i < full_cir; i = i + step) {
    float x = sin(radians(i)) * cir_r;   // x, y moves along a circlar path
    float y = cos(radians(i)) * cir_r;
    pushMatrix();
    translate (x, y);
    rotate(radians(-i + frameCount));   // make sure there is a new edge with new rotation per new frame
    fill(50, 100, sin(radians(i/2))*255);  //R, G, B - various
    strokeWeight(3);
    rect(0, 0, edge_length, 2, 25);
    strokeWeight(8);
    point(edge_length + 10 * i/60, 30);
//    drawPopsicle(current_ctr_x - edge_length, current_ctr_y + edge_length, stick_height, h_12hr, ini_rot, s);
    popMatrix();
  } // end for
  popMatrix();
  
  pushMatrix();
 // second group of edges with opposite rotation
  translate (current_ctr_x + 50, current_ctr_y);
  //  60 * 60 = 360
  for (int i = 0; i < full_cir; i = i + step) {
    float x = sin(radians(i)) * cir_r;   // x, y moves along a circlar path
    float y = cos(radians(i)) * cir_r;
    pushMatrix();
    translate (x, y);
   // print("fc ", frameCount, "|");
    rotate(-(radians(-i + frameCount)));  // make sure there is a new edge with new rotation per new frame
    fill(150, 50, sin(radians(i/2))*255);  //R, G, B - various
    //float adj = random(1);
    //strokeWeight(4 * adj + 4);
    strokeWeight(4);
    rect(0, 0, edge_length, 2, 25 * sin(radians(i)));
    popMatrix();
  } // end for
  popMatrix();
  
  // Third groups of edges (minute behavior, two edges per minutes)
  //  making a horizational bar with respect to the "m"
  for (int i = 0; i < m * 3; i = i+3) {
    // TODO: different color?  done
    // TODO: different positioning of the bar? done - with respect to hour
    //colorMode(RGB,100-h,500-h,10,255 - h);
    stroke(213,36,90+i, 75+i*3 );  // not fill - which is for the shape
    strokeWeight(2);
    fill(213,36,90+i, 75+i*3 );  
    //line(x1, y1, x2, y2);
    line((current_ctr_x - m_pos)/2, i, (current_ctr_x - m_pos), i);  
    line((current_ctr_x - m_pos)/2 + 5, i + 3, (current_ctr_x - m_pos) - 5, i + 3);
  }  //end for
  
  // draw popsicle for hours; somehow the popsicle function gets recusive
  // drawPopsicle(h_pos + s_bar_width/2, height - 5, stick_height, h_12hr, ini_rot, s);
   float numPop = h_12hr;
   if (numPop == 0) {numPop = 12;}
   //drawPopsicle(bottom_popsicle_x, bottom_popsicle_y, stick_height, numPop, ini_rot, s);
   float ini_rot = h_rot /2;
   drawPopsicle(70, bottom_popsicle_y, stick_height, numPop, ini_rot, s);
  // drawPopsicle(bottom_popsicle_x, bottom_popsicle_y, h_12hr, numPop, ini_rot, s);
  // drawPopsicle(current_ctr_x - edge_length, current_ctr_y + edge_length, h_12hr, numPop, ini_rot, s);
   
   stick_height = stick_height *0.8; 
   

   
}  // end draw

void drawPopsicle(float bottom_x, float bottom_y, float stick_height, float count, float rot, float s ) {
  // for hour behavior : one pop per hour
  //note: reference point at stick bottom
  float pop_r = (100 + s)*0.5;
  //print("count", count);
  float i = count;
  if (i <= 0) { // hour == 0
    //print ("!!inside <=0!!", pop_r);
    // do not drawPopsicle, but the circle only
    // do not use translate
        float x = bottom_x;
        float y = bottom_y;
        stroke(255,200,195+i, 75+i*3 );
        fill(230,195,195+i, 75+i*3 );
        float adj = random(-1,1);
        ellipse(x, y-stick_height, pop_r, pop_r);
        ellipse(x, y-stick_height, pop_r + adj * 10, pop_r + adj * 10);
        if (s%2 ==0) {
          pop_r = pop_r + 10;
        } else {
          pop_r = pop_r - 10;
        }
   }
  else {
   // print ("inside else: ", count) ;
    //other case  : trying to draw the number of popsicle = number of hour
    while (i >= 1 && i <= count) {
      
      //final int stick_height = 60;
      pushMatrix();
      translate(bottom_x, bottom_y);
      float adj = random(-1,1);
      //rotate(-(radians(-i + count)) * adj);
      rotate(rot);
      float x = 0;
      float y = 0;
      
      stroke(255,200,195+i, 75+i*3 );
      line(x, y-stick_height, x, y);
      fill(230,195,195+i, 75+i*3 );
      ellipse(x, y-stick_height, pop_r, pop_r);
      ellipse(x, y-stick_height, pop_r + adj * 10, pop_r + adj * 10);
      popMatrix();
      i = i - 1;
      bottom_x = bottom_x - 4 * adj;
      bottom_y = bottom_y - 4 * adj;
      stick_height = stick_height * 0.8;
      pop_r = pop_r * 0.8;
      
      if (i%2 ==0) {
        //      rotate(-(radians(-i + count)) * adj);
        rot = rot -(radians(-i + count)) * adj;
      } else {
        rot = rot + 0.1;
      }
    
      // call drawPopsicle recursively -- it seems the draw() will call it recursively!!!

    } //end while
  } //end else
}
    

  

