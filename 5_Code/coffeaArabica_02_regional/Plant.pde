import java.util.Iterator;

class Plant {

  PVector     loc;
  PVector     vel;
  float       mag;
  int         FChome;

  boolean foundTarget = false;

  Kernel k;
  int kernelSize  =  12;

  boolean alive   = true;

  int r = 0;
  int g = 255;
  int b = 0;
  int fertility = 7;


//===============================================================  Parent Agent
  Plant()
  {
    loc  =  new PVector( random( 0, width ), random( 0, height ) );
    vel  =  new PVector( 0, 0 );
    mag  =  1;

    k    =  new Kernel();
    k.isNotTorus();
    k.setNeighborhoodDistance( kernelSize);
  }

//===============================================================  Child Agent      
  Plant( float x, float y)
  {
    loc  =  new PVector( x, y );
    vel  =  new PVector( 0, 0 );
    k    =  new Kernel();
    k.isNotTorus();
    k.setNeighborhoodDistance( kernelSize);
  }

//===============================================================  Set Home
  void setHomeClass( int FCclass )
  {
    FChome = FCclass;
  }

//===============================================================  Update the Lattice
  void update( Lattice l, ArrayList <Plantation> estates, ArrayList <Erosion> events)
  {
    for ( Plantation estate : estates ) {
       if (estate.contains(loc)) {
          fertility = 20;
          break;
       }
    }
    
    for ( Erosion event : events ) {
       if (event.containsER(loc)) {
          alive = false;
          break;
       }
    }
    
  }

//===============================================================  Kill Plants by Elevation
  float deathProbability( float deathValue )
  {
    if ( deathValue > (100 + rangeElevation ) || deathValue < (10 + rangeElevation )) return 0.8;
    return 0.0;
  }

//===============================================================  Check Elevation
  void checkElevation( PImage demRaster )
  {
    int pixelValue = demRaster.get( (int)loc.x, (int)loc.y );
    float deathValue = red( pixelValue );

    float deathProbabilityHigh = deathProbability( deathValue );

    if ( random ( 1.0 ) <= deathProbabilityHigh ) { 
      alive = false;
    }
  }

//===============================================================  How It Looks
  void drawAgent()
  {
    
      
      noStroke();
      if ( alive == true) 
      {
        //blendMode(ADD);
        if( fertility == 7 )  {  fill( r, g, b );  }
        if( fertility == 20 ) {  fill( 200, 255, 0);  }
        ellipse( loc.x, loc.y, 3, 3 );
      }
      
  }
//===============================================================  Remove Dead
    void removeDead()
    {
      Iterator iter = arabica.iterator();
      Plant tempAgent;
    
      while( iter.hasNext() )
      {    
        tempAgent = (Plant)iter.next();
        if( tempAgent.alive == false )
        { 
          iter.remove();
        }
      }    
    }
  
}