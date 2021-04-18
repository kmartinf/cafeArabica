import java.util.Iterator;

class Plantation {

  PVector     loc;
  int         FChome;
  int         RDhome;

  boolean foundTarget = false;

  Kernel e;
  int kernelSize  =  12;

  boolean alive   = true;

  int r = 0;
  int g = 0;
  int b = 255;
  int radius = 15;


//===============================================================  Parent estate
  Plantation()
  {
    loc  =  new PVector( random( 0, width ), random( 0, height ) );

    e    =  new Kernel();
    e.isNotTorus();
    e.setNeighborhoodDistance( kernelSize);
  }

//===============================================================  Child estate      
  Plantation( float x, float y)
  {
    loc  =  new PVector( x, y );
    e    =  new Kernel();
    e.isNotTorus();
    e.setNeighborhoodDistance( kernelSize);
  }

//===============================================================  Set Home
  void setHomeClass( int RDclass )
  {
    RDhome = RDclass;
  }

//===============================================================  Update the Lattice
  void update( Lattice l )
  {
  }

//===============================================================  Kill Plants by Elevation
  float deathProbability( float deathValue )
  {
    if ( deathValue > (100 + (rangeElevation) ) ) return 0.8;
    if ( deathValue < (10 + rangeElevation ) ) return 0.8;
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
  void drawPlantation()
  {
      noStroke();
      if ( alive == true) 
      {
        //blendMode(ADD);
        fill(255, 0, 255);
        rectMode(CENTER);
        rect( loc.x, loc.y, 2, 20 );
        rect( loc.x, loc.y, 20 , 2 );
        //noFill();
        //strokeWeight(1);
        //stroke(255, 0, 255);
        fill(255, 0, 255, 40);
        ellipse( loc.x, loc.y, 30 + radius, 30 + radius );
      }
      noStroke();
  }
//===============================================================  Remove Dead
    void removeDead()
    {
      Iterator iter = estates.iterator();
      Plantation tempEstate;
    
      while( iter.hasNext() )
      {    
        tempEstate = (Plantation)iter.next();
        if( tempEstate.alive == false )
        { 
          iter.remove();
        }
      }    
    }
    
    
    boolean contains(PVector l) {
        if (l.x <= loc.x - radius || l.x > loc.x + radius) return false;
        if (l.y <= loc.y - radius || l.y > loc.y + radius) return false;
        return true;
    }
  
}