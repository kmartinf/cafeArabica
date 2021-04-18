//PROJECT:         Coffea Arabica in Ethiopia
//AUTHORL:         Aaron Hill & Martin Fernandez
//CLASS:           GSD 6349 Mapping II : Geosimulation
//CRITIC:          Professor Robert Gerard Pietrusko
//DATE:            November 15th, 2017
//KEYBOARD:        Coffee / Plant / Ethiopia / Growth / Production / Distribution / Climate Change / Borer 


//================================  :Libraries
import      controlP5.*;                                           // library for controllers
//================================  Forest Cover Lattice
ASCgrid     FC;                                                    // forest cover ASCII grid from ArcMap
FCswatch    fcColors;                                              // class of swatch colors
Lattice     FClat;   
PImage      forestCoverRaster;                                      // forest cover lattice

//================================  Elevation Lattice
PImage      demRaster;                                             // raster of elevation map
Lattice     DEMlat;                                                // elevation lattice

//================================  Roads Lattice
PImage      roadsRaster;                                             // raster of roads
Lattice     RDlat;    

//================================  Erosion Lattice
PImage      erosionRaster;                                             // raster of erosion zone
Lattice     ERlat;    

//================================  Time
int fps = 30;                                                      // frame rate variable

//================================  Environmental Parameters
int Habitat3        = 3;
int Habitat4        = 4;
int Habitat5        = 5;
int Habitat6        = 6;
int Habitat7        = 7;

int rangeElevation  = 30;
int elevLow         = 0;
int elevHigh        = 100;

//================================  Coffee Plant Parameters
ArrayList <Plant> arabica;
int arabicaPopSize          =  1500;
int currentArabicaPop       =  0;
int seedRange               =  10;

//================================  Plantation Parameters
ArrayList <Plantation> estates;
int estatePopSize    =  12;
int currentEstatePop =  0;
int relocationRange  =  50; 

//================================  Erosion Parameters
ArrayList <Erosion> events;
int eventPopSize    =  10;
int currentEventPop =  0; 

//================================  Census
float birthRate     = 0.05;
float deathRate     = 0.1;

//================================  Annotations
PFont       font;
boolean     mouseOverText             = false;
boolean     forestElevationVisible    = true;
boolean     erosionRasterVisible      = false;
boolean     recording                 = true;
ControlP5   cp1;


/////////////////////////////////////////////////////////////////////////////////  SETUP
void setup()
{
  size( 600, 600 );                                        
  frameRate( fps );  

  font = createFont("AktivGrotesk-LightItalic-30.vlw", 30, true);

  //===============================================================  Forest Cover Lattice
  fcColors = new FCswatch();                                     // initializes forest cover ascii grid
  FC = new ASCgrid( "forestcover_update.asc" );                         // and forest cover swatch color class
  FC.fitToScreen();                                              // fits the ascii grid to the screen
  FC.updateImage( fcColors.getSwatch() );                        // and updates it with colors from swatch

  FClat = new Lattice( FC.w, FC.h );                             // creates new lattice with dimensions from forest cover ascii grid
  fillLattice( FClat, FC );                                      // fill this lattice with values from the ascii grid

  forestCoverRaster = loadImage( "back_demForestRoads3.jpg" );

  //===============================================================  DEM Lattice
  demRaster = loadImage( "regional-dem.png" );                   // loads raster image of DEM
  int w = demRaster.width;                                       // locally define w according to raster width
  int h = demRaster.height;                                      // locally define h according to raster height

  DEMlat = new Lattice(FC.w, FC.h);                              // create new lattice w/ same dims as FClat

  for (int x = 0; x < FC.w; x++ ) {                             
    for (int y = 0; y < FC.h; y++ ) {
      int pixelX = (int) map(x, 0, FC.w, 0, w );                 // rescale raster image width to dims of FClat
      int pixelY = (int) map(y, 0, FC.h, 0, h );                 // rescale raster image height to dims of FClat
      color c = demRaster.get( pixelX, pixelY );                 // get pixel values from scaled raster
      DEMlat.put( x, y, red(c));                                 // put these values in DEMlat
    }
  }

  //===============================================================  Roads Lattice
  roadsRaster = loadImage( "roads_major.png" );
  int wRD = roadsRaster.width;
  int hRD = roadsRaster.height;

  RDlat = new Lattice(FC.w, FC.h);

  for (int x = 0; x < FC.w; x++ ) {                             
    for (int y = 0; y < FC.h; y++ ) {
      int pixelX = (int) map(x, 0, FC.w, 0, wRD );
      int pixelY = (int) map(y, 0, FC.h, 0, hRD );
      color c = roadsRaster.get( pixelX, pixelY );
      RDlat.put( x, y, red(c));
    }
  }

  //===============================================================  Erosion Lattice
  erosionRaster = loadImage( "erosion_05.jpg" );
  int wER = erosionRaster.width;
  int hER = erosionRaster.height;

  ERlat = new Lattice(FC.w, FC.h);

  for (int x = 0; x < FC.w; x++ ) {                             
    for (int y = 0; y < FC.h; y++ ) {
      int pixelX = (int) map(x, 0, FC.w, 0, wER );
      int pixelY = (int) map(y, 0, FC.h, 0, hER );
      color c = erosionRaster.get( pixelX, pixelY );
      ERlat.put( x, y, red(c));
    }
  }

  //===============================================================  Initialize Arabica Population
  initializePopulation();
  println("arabica created");

  //===============================================================  Construct Plantations
  constructPlantations();
  println("plantation created");

  //===============================================================  Cause Erosion Events
  causeErosionEvents();
  println("erosion events created");  

  initializeControl();
  println("setup done");
}


/////////////////////////////////////////////////////////////////////////////////  DRAW
void draw()
{
  background(0);

  //===============================================================  Draw Lattices
  image( DEMlat.getPImage(), 0, 0 );   

  //===============================================================  Draw Image
  if ( forestElevationVisible ) { image( forestCoverRaster, 0, 0 ); }
 
  if ( erosionRasterVisible ) { image( erosionRaster, 0, 0 ); }

  //===============================================================  Draw Plant Agents
  for ( Plant plant : arabica )
  {
    plant.update( FClat, estates, events);
    plant.drawAgent();
    plant.checkElevation( demRaster );

  }

  //===============================================================  Draw Plantation estates
  for ( Plantation estate : estates )
  {
    estate.update( FClat );
    estate.drawPlantation();
    estate.checkElevation( demRaster );
  }

  if ( frameCount % fps == 0 )
  {
    currentArabicaPop = arabica.size();
    currentEstatePop = estates.size();
    removeDeadPlants(arabica);
    removeDefunctEstates(estates);
    reproduction();
  }

  //===============================================================  Draw Erosion events
 if (frameCount % (fps * 5) == 0) { 
    for ( Erosion event : events )
    {
      event.update( ERlat );
      event.drawErosion();
    }
  }

  //===============================================================  Draw Other Stuff
  yearCounter();
  forestMarker();
  recordOutput();
  

};
  /////////////////////////////////////////////////////////////////////////////////  DEATH (RANDOM, BY RATE)
  void deaths()
  {
    int numberToDie = round( deathRate * currentArabicaPop );

    while ( numberToDie > 0 )
    {
      arabica.remove(0);
      numberToDie -= 1;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////  
  void yearCounter()
  {
    rangeElevation = frameCount/fps;

    if (rangeElevation > 100) { 
      rangeElevation = 100;
    }

    textFont(font, 30);
    fill(255);
    text((int)map(rangeElevation, elevLow, (elevHigh), 2016, 2080), 500, 30);
  }

  /////////////////////////////////////////////////////////////////////////////////  
  void forestMarker()
  {
    if ( mouseOverText )
    {
      int FCcode = (int) FClat.get(mouseX, mouseY );
      fill(255, 0, 0, 255);
      textSize(10);
      if ( FCcode == 3 || FCcode == 3 || FCcode == 4) { 
        text( "SEMI-FOREST", mouseX+5, mouseY-5 );
      }
      if ( FCcode == 5 || FCcode == 6 || FCcode == 7) { 
        text( "FOREST", mouseX+5, mouseY-5 );
      }
      if ( FCcode == 8 || FCcode == 9 ) { 
        text( "DENSE FOREST", mouseX+5, mouseY-5 );
      }

      //text(FCcode, mouseX+5, mouseY-5 );
    }
  }

  /////////////////////////////////////////////////////////////////////////////////  KEY PRESSED
  void keyPressed()
  {
    if ( key == 't' ) { 
      mouseOverText = !mouseOverText;
    }
    if ( key == 'r' ) { 
      forestElevationVisible = !forestElevationVisible;
    }
    if ( key == 'e' ) { 
      erosionRasterVisible = !erosionRasterVisible;
    }
  }
  /////////////////////////////////////////////////////////////////////////////////  MOUSE PRESSED
  void mousePressed()
  {
    int x = mouseX;
    int y = mouseY;

    Plantation estate = new Plantation( x, y );

    estate.drawPlantation();
    estates.add( estate );
  }

  /////////////////////////////////////////////////////////////////////////////////  FILL LATTICE
  void fillLattice( Lattice latIn, ASCgrid FCin )
  {
    for ( int x = 0; x < FCin.w; x += 1 ) {
      for ( int y = 0; y < FCin.h; y += 1 ) {

        float value = FCin.get(x, y);
        latIn.put(x, y, value  );
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////////  INITIATE ARABICA POPULATION
  void initializePopulation()
  {
    arabica = new ArrayList <Plant>();

    while ( arabica.size() < arabicaPopSize)
    {
      int x = (int) random( FClat.w );
      int y = (int) random( FClat.h );

      int val = (int) FClat.get( x, y );

      Plant plant = new Plant( x, y ); 

      if ( val == Habitat3 ||
        val == Habitat4 ||
        val == Habitat5 ||
        val == Habitat6 ||
        val == Habitat7)
      {
        plant.drawAgent();
        plant.setHomeClass( val );
        arabica.add( plant );
      }
    }
    return;
  }

  /////////////////////////////////////////////////////////////////////////////////  PLANT REPRODUCTION
  void reproduction()
  {

    int numberToBeBorn                = round( birthRate * currentArabicaPop );
    while (true)
    {
      Plant parent        = arabica.get( (int)random( arabica.size() ) );
      Plant child         = new Plant();

      for (int i = 0; i < parent.fertility; i++) {
        child.loc           = new PVector( (parent.loc.x + random(-seedRange, seedRange)), (parent.loc.y + random(-seedRange, seedRange) ));
        arabica.add             ( child );
        numberToBeBorn      -= 1;
        if (numberToBeBorn <= 0) return;
      }
    }
  };

  /////////////////////////////////////////////////////////////////////////////////  REMOVE ARABICA DEAD
  void removeDeadPlants( ArrayList population )
  {
    Iterator iter = population.iterator();
    Plant tempAgent;

    while ( iter.hasNext() ) {    
      tempAgent = (Plant)iter.next();
      if ( tempAgent.alive == false ) {
        iter.remove();
      }
    }
  };

  /////////////////////////////////////////////////////////////////////////////////  CONSTRUCT PLANTATIONS
  void constructPlantations()
  {
    estates = new ArrayList <Plantation>();

    println("constructing plantation");
    while ( estates.size() < estatePopSize)
    {
      int x = (int) random( RDlat.w );
      int y = (int) random( RDlat.h );

      int valRD = (int) RDlat.get( x, y );
      int valFC = (int) FClat.get( x, y );

      Plantation estate = new Plantation( x, y ); 

      if ( (valRD == 255) && 
        (valFC == Habitat3 ||
        valFC == Habitat4 ||
        valFC == Habitat5 ||
        valFC == Habitat6 ||
        valFC == Habitat7) )
      {
        estate.drawPlantation();
        estate.setHomeClass( valRD );
        estates.add( estate );
      }
    }
    return;
  }

  /////////////////////////////////////////////////////////////////////////////////  PLANTATION RELOCATION
  void relocation()
  {
    int numberToBeBorn                = round( birthRate * currentArabicaPop );
    while (true)
    {
      Plantation heritage        = estates.get( (int)random( estates.size() ) );
      Plantation heir         = new Plantation();

      for (int i = 0; i < 7; i++) {
        heir.loc           = new PVector( (heritage.loc.x + random(-relocationRange, relocationRange)), (heritage.loc.y + random(-relocationRange, relocationRange) ));
        estates.add             ( heir );
        numberToBeBorn      -= 1;
        if (numberToBeBorn <= 0) return;
      }
    }
  };

  /////////////////////////////////////////////////////////////////////////////////  REMOVE DEFUNCT ESTATES
  void removeDefunctEstates( ArrayList plantation )
  {
    Iterator iter = plantation.iterator();
    Plantation tempEstate;

    while ( iter.hasNext() ) {    
      tempEstate = (Plantation)iter.next();
      if ( tempEstate.alive == false ) {
        iter.remove();
      }
    }
  };

  /////////////////////////////////////////////////////////////////////////////////  CAUSE EROSION EVENTS
  void causeErosionEvents()
  {
    events = new ArrayList <Erosion>();

    println("causing erosion");
    while ( events.size() < eventPopSize)
    {
      int x = (int) random( ERlat.w );
      int y = (int) random( ERlat.h );

      int valER = (int) ERlat.get( x, y );

      Erosion event = new Erosion( x, y ); 

      if ( valER == 255 )
      {
        event.drawErosion();
        event.setHomeClass( valER );
        events.add( event );
      }
    }
    return;
  }




  /////////////////////////////////////////////////////////////////////////////////  RECORD
  void recordOutput()
  {
    if  (recording) 
    {
      saveFrame("output/"+01+"/cel_#####.png");
      fill (255, 0, 0);
    } else 
    {
      fill(0, 255, 0);
    } 
    ellipse(width/2, height-25, 20, 20);
  };    

  void record()
  {
    {
      recording = !recording;
    }
  };

  void initializeControl()
  {
    cp1 = new ControlP5 (this); 
    cp1.addButton("record").setPosition(500, 570).setValue(0).setSize(75, 15);
  }
  /////////////////////////////////////////////////////////////////////////////////  PROPS TO BOBBY
  //  Kernel, Lattice, and ASCgrid code by:
  //  Professor Robert Gerard Pietrusko
  //  <rpietrusko@gsd.harvard.edu>
  //  Havard University Graduate School of Design