// Martin Fernandez + Aaron Hill
// Coffea Arabica v3 Plant-Borer Model
// Geosimulation

//=================================LIBRARY
import controlP5.*;
//=================================GLOBAL

//===========controllers
ControlP5 cp1;
ControlP5 cp2;
ControlP5 cp3;
ControlP5 cp4;

boolean     recording             = true;
int         folder                = 01;
PImage      contours;

//===========coffee plant parameters
ArrayList   <Agent>                pop;
int         numClusters          = 10;
int         pointsPerCluster     = 50;
int         radMin               = 150;
int         radMax               = 20;
int         popSize              = pointsPerCluster * numClusters;
int         seedRange            = 14;

//===========epidemic parameters
int         minDaysBorer         = 1;
int         maxDaysBorer         = 14;
int         spreadDistance       = 14;
float       infectionProbability = 0.95;
float       initialDensity       = 0.05;

//=============frames
int         fps                  = 12;
int         timeCount            = 0;

//==============census
int         currentPop           = 0;
float       birthRate            = 0.031250;
float       deathRate            = 0.031250;



//============================================================//
void setup()
{
  size( 600, 600 );
  frameRate( fps );

  contours = loadImage( "contours.png" );

  pop = new ArrayList<Agent>();
  initializePopulation();

  cp1 = new ControlP5 (this);
  cp1.addSlider("seedRange").setPosition(25, 20).setRange(01, 20);
  cp2 = new ControlP5 (this);
  cp2.addSlider("spreadDistance").setPosition(200, 20).setRange(01, 20);
  cp3 = new ControlP5 (this);
  cp3.addSlider("maxDaysBorer").setPosition(400, 20).setRange(01, 20);
  cp4 = new ControlP5(this);
  cp4.addButton("record").setValue(0).setPosition(500, 570).setSize(75, 15);
}


//============================================================//
void draw()
{
  background(contours);

  for ( Agent plant : pop )
  {
    plant.update();
    plant.drawAgent();
  }

  infect();
  removeDead( pop );

  if ( frameCount % fps == 0 )
  {
    currentPop = pop.size();
    removeDead(pop);
    births();  

    reportStats();
  }

  if  (recording) {
    saveFrame("output/"+folder+"/cel_####.png");
    //saveFrame("output/"+ seedRange + '-' + spreadDistance + '-' + maxDaysBorer +"/cel_####.png");
    fill (255, 0, 0);
  } else {
    fill (0, 255, 0);
  } 

  ellipse(width/2, height-25, 20, 20);
}

//===========================================PLANT DEATHS (OLD AGE)
void deaths()
{
  int numberToDie = round( deathRate * currentPop );

  while ( numberToDie > 0 )
  {
    pop.remove(0);
    numberToDie -= 1;
  }
}

//===========================================PLANT BIRTHS
void births()
{
  int numberToBeBorn = round( birthRate * currentPop );

  while ( numberToBeBorn > 0 )
  {
    Agent parent = pop.get( (int)random( pop.size() ) );
    Agent child  = new Agent();

    child.loc    = new PVector( (parent.loc.x + random(-seedRange, seedRange)), (parent.loc.y + random(-seedRange, seedRange) ));

    pop.add( child );
    numberToBeBorn -= 1;
  }
}

//===========================================BORER INFECTION
void infect()
{
  for ( int i = 0; i < pop.size(); i +=1 )
  {
    Agent plant1 = pop.get( i );

    for ( int j = i + 1; j < pop.size(); j += 1 )
    {
      Agent plant2 = pop.get( j );
      float distance = dist( plant1.loc.x, plant1.loc.y, plant2.loc.x, plant2.loc.y);

      if (distance <= spreadDistance && plant1.sick && !plant2.sick)
      {
        //plant1 makes plant2 sick
        if ( prob(infectionProbability) == true) {
          plant2.getSick( minDaysBorer, maxDaysBorer );
        }
      } else if ( distance <= spreadDistance && plant2.sick && !plant1.sick)
      {
        //plant2 makes plant1 sick
        if ( prob( infectionProbability ) == true) { 
          plant1.getSick( minDaysBorer, maxDaysBorer );
        }
      }
    }
  }
}

//============================================================//
boolean prob( float probRate )
{
  if ( random(0.0, 1.0) <= probRate )
  {
    return true;
  } else {
    return false;
  }
}


//============================================================//
void reportStats()
{
  float popSize = pop.size();
  float numSick = 0;

  for ( Agent plant : pop ) { 
    if (plant.sick == true) { 
      numSick +=1;
    }
  }

  float percentSick = (numSick / popSize) * 100;
  println( "Time " + timeCount + " plants " + popSize + " percent sick: " + nf(percentSick, 3, 2) );

  timeCount += 1;
}


//============================================================//
void initializePopulation()
{
  PVector[] clusterCenters = new PVector[numClusters];

  float[] radii = new float[numClusters];

  for (int i = 0; i < numClusters; i++) {
    clusterCenters[i] = new PVector(random(0, width), random(0, height));
    radii[i] = random(radMin, radMax);
    for (int j = 0; j < pointsPerCluster; j++) {
      float randomRadius = random(0, radii[i]);
      float randomAngle = random(0, 2 * PI);
      float x = clusterCenters[i].x + cos(randomAngle) * randomRadius;
      float y = clusterCenters[i].y + sin(randomAngle) * randomRadius;
    Agent plant =  new Agent( x, y );  
    if( prob(initialDensity ) == true ) {plant.getSick ( minDaysBorer, maxDaysBorer );}
      
      pop.add( plant );
    }
  }
}


//============================================================//
void mousePressed()
{
  Agent sickPlant = new Agent();
  sickPlant.getSick( minDaysBorer, maxDaysBorer);
  sickPlant.loc.x = mouseX;
  sickPlant.loc.y = mouseY;

  pop.add( sickPlant);
}


//============================================================//
void keyPressed()
{
  if (key== ' ') {
    initializePopulation();
  }
}

//============================================================//

public void record() {
  {
    recording = !recording;
  }
}

//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017
//  Please cite author and course 
//  when using this library in any 
//  personal or professional project.