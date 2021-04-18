//================================  :Libraries
import      controlP5.*;      

//================================  Global variables
Cost        cst;
//Lattice     cc;               // lattice that holds our cost surface, upon which the cars move 
int         ROADVALUE = 255;

//================================  Elevation Lattice
PImage      roadImg;                  
PImage      roadImgPreview;
PImage      elevation;
PImage      road;
PImage      forest;
//ASCgrid     roadASC;          // asc that stores the road. 

//================================  Truck Parameters
ArrayList<MultiTargetFinder> trucks;    
ArrayList<PVector> trainStation;
ArrayList<Lattice>   ccs;                                                

//================================  Annotations
boolean     roadMainVisible           = false;
boolean     roadVisible               = false;
boolean     elevationVisible          = false;
boolean     forestVisible             = false;
boolean     trainStationPreview       = false;
boolean     recording                 = false;
int         folder                    = 01;
ControlP5   cp1;


////////////////////////////////////////////////////////////////////////////// SAVE COST SURFACE PARAMETERS

// 1. to compute the cost surface and save it to a file
//    set the boolean below to 'false.'
// 2. this will write the cost surface to an asc file
// 3. the next time you run the code, set the boolean to 'true'
// 4. your code will now read the cost surface from an asc file
//    and not have to recompute it. 

//boolean readCostFromFile = false;            // boolean to toggle for loading and saving
//String  costFileName = "mycostsurface.asc"; // name of the saved cost surface
//ASCgrid costSurfaceASC;                     // internal asc to save cost surface

// NOTE: if you change the target (by hitting 't' in this case)
// it will recompute the cost surface and that will take as long
// as it usually does. 


/////////////////////////////////////////////////////////////////////////////////  SETUP
void setup()
{
    size(600, 600);
    background(0);
    frameRate(30);
      roadImg = loadImage( "Ethiopia_Road.png" );
     
      roadImgPreview = loadImage( "RoadPreview.jpg" );
      elevation = loadImage("Elevation.jpg");
      road = loadImage("Road.jpg");
      forest = loadImage("Forest.jpg");
                
        trainStation = new ArrayList<PVector>();
        trainStation.add( new PVector( 237, 305 ) );
        trainStation.add( new PVector( 260, 320 ) );
        trainStation.add( new PVector( 280, 310 ) );
        trainStation.add( new PVector( 308, 300 ) );
        trainStation.add( new PVector( 327, 287 ) );
        trainStation.add( new PVector( 356, 275 ) );
        trainStation.add( new PVector( 363, 264 ) );
        trainStation.add( new PVector( 380, 240 ) );


    
//if( readCostFromFile == false ){
  
  
      ////////////////////////////////////////////////////////////////////////
     //           Initialize the Cost Surfaces                             //
    ////////////////////////////////////////////////////////////////////////
    ccs = new ArrayList<Lattice>();
                      
    for( PVector t : trainStation )
    {        
          cst = new Cost( roadImg, ROADVALUE ); 
          cst.moreOptimal = false;
          Lattice l = cst.getCostSurface( t );     // for each target in the ArrayList ... 
          ccs.add( l );                            // pass it a PVector of the target. it will pick the spot on the
    }                                              // road closest to the target and compute paths along to road to
                                                   // get there. Store it in the cost surface ArrayList, ccs.

//}
    
    
    //Create the arrayList that will hold our PathFinder agents
    trucks = new ArrayList<MultiTargetFinder>();                                                
 
 
 
 
 
    // ////////////////////////////////////////////////////////////////////////
    ////           Write the Cost Surface to a File                         //
    //////////////////////////////////////////////////////////////////////////
    //if( readCostFromFile == false )
    //{
    //             costSurfaceASC = new ASCgrid();
    //              costSurfaceASC.copyGridStructure(roadASC);
                  
    //              for( int x = 0; x < costSurfaceASC.w; x++ ){
    //                for( int y = 0; y < costSurfaceASC.h; y++){
    //                      costSurfaceASC.put(x,y, cc.get(x,y) );
    //                }}
    
    //      costSurfaceASC.write( "DATA/"+costFileName );
          
    //}
    
    //////////////////////////////////////////////////////////////////////////
    ////           Read the Cost Surface from a File                        //
    //////////////////////////////////////////////////////////////////////////
    //if( readCostFromFile == true )
    //{
    //                 cst = new Cost( roadASC, ROADVALUE );
    //      costSurfaceASC = new ASCgrid(costFileName);
    //      cc             = new Lattice( costSurfaceASC.w, costSurfaceASC.h );
          
    //      for( int x = 0; x < cc.w; x++ ){
    //        for( int y = 0; y < cc.h; y++){
    //              cc.put( x,y, costSurfaceASC.get(x,y)  );   
    //        }}
    //}  




};

/////////////////////////////////////////////////////////////////////////////////  DRAW
void draw()
{    
       background( 0 );
       image( roadImgPreview, 0, 0 );
       
//===============================================================  Background Preview
if( roadMainVisible )  {image( roadImgPreview, 0, 0 );}
if( elevationVisible ) {image( elevation, 0, 0 );}
if( roadVisible )      {image( road, 0, 0 );}
if( forestVisible )    {image( forest, 0, 0 );}
//===============================================================  Background Preview 
    drawTargets();
       
    for( MultiTargetFinder c : trucks ){
        c.update( ccs );
        c.drawMe();
    }
    
    MultiTargetFinder region1 = new MultiTargetFinder( 111, 392 );
    region1.findRoad(ccs);
    trucks.add(region1);
    
    MultiTargetFinder region2 = new MultiTargetFinder( 117, 418 );
    region2.findRoad(ccs);
    trucks.add(region2);
    
    MultiTargetFinder region3 = new MultiTargetFinder( 120, 308 );
    region3.findRoad(ccs);
    trucks.add(region3);
    
    MultiTargetFinder region4 = new MultiTargetFinder( 152, 350 );
    region4.findRoad(ccs);
    trucks.add(region4);
    
    MultiTargetFinder region5 = new MultiTargetFinder( 198, 339 );
    region5.findRoad(ccs);
    trucks.add(region5);
    
    MultiTargetFinder region6 = new MultiTargetFinder( 215, 430 );
    region6.findRoad(ccs);
    trucks.add(region6);
    
    MultiTargetFinder region7 = new MultiTargetFinder( 238, 379 );
    region7.findRoad(ccs);
    trucks.add(region7);
    
    MultiTargetFinder region8 = new MultiTargetFinder( 335, 320 );
    region8.findRoad(ccs);
    trucks.add(region8);
    
    MultiTargetFinder region9 = new MultiTargetFinder( 143, 441 );
    region9.findRoad(ccs);
    trucks.add(region9);

recordOutput(); 
};
/////////////////////////////////////////////////////////////////////////////////  DRAW TRAIN STATION
void drawTargets()
{
    for( PVector t : trainStation )
    {
      if( trainStationPreview )  
       {
        noFill();
        stroke( 255,0,0 );
        ellipse( t.x, t.y, 20, 20 );
        noStroke();
        fill( 0,255,0 );
        ellipse( t.x, t.y, 4, 4 );
       }
    }
};
/////////////////////////////////////////////////////////////////////////////////  MOUSE PRESSED
void mousePressed()
{ 
   // click the mouse creates a new PathFinder car at the x,y location
   // of the mouse. It then needs to find the road. It does this with a
   // function findRoad(). This function needs the lattice of the cost surface
   // in this case, 'cc'. It also needs to know what cell value in the cost
   // surface lattice corresponds to "non road". This changes within
   // the cost surface is based on the target. Use the dot operator on Cost to get
   // its current "NON_ROAD" variable. 
  
    //MultiTargetFinder car = new MultiTargetFinder( 300, 300 );
    //MultiTargetFinder car = new MultiTargetFinder( mouseX, mouseY );
    //trucks.findRoad(ccs);
    //trucks.add(car);
        

};
/////////////////////////////////////////////////////////////////////////////////  KEY PRESSED
void keyPressed()
{    
    
    if( key == 'w' ){ trainStationPreview =  !trainStationPreview; }
    if( key == 'e' ){ roadMainVisible =  !roadMainVisible; }    
    if( key == 'r' ){ elevationVisible = !elevationVisible; }
    if( key == 't' ){ roadVisible =      !roadVisible; }
    if( key == 'y' ){ forestVisible =    !forestVisible; }
}
/////////////////////////////////////////////////////////////////////////////////  RECORD
void recordOutput()
{
      if  (recording) 
          {
          saveFrame("output/"+folder+"/cel_####.png");
          fill (255,0, 0);
          }
      else 
          {
          fill(0, 255, 0);
          } 
      ellipse(width/2, height-25, 20, 20);    
};    

void record()
{{recording = !recording;}};

void initializeControl()
{
 cp1 = new ControlP5 (this); cp1.addButton("record").setPosition(500,570).setValue(0).setSize(75,15);  
}