import java.util.Iterator;

class Erosion {

  PVector     loc;
  int         FChome;
  int         ERhome;

  boolean foundTarget = false;

  Kernel z;
  int kernelSize  =  12;

  boolean active   = true;

  int r = 0;
  int g = 0;
  int b = 255;
  int radius = 10;


//===============================================================  Erosion Zone
  Erosion()
  {
    loc  =  new PVector( random( 0, width ), random( 0, height ) );

    z    =  new Kernel();
    z.isNotTorus();
    z.setNeighborhoodDistance( kernelSize);
  }

 Erosion( float x, float y)
  {
    loc  =  new PVector( x, y );
    z    =  new Kernel();
    z.isNotTorus();
    z.setNeighborhoodDistance( kernelSize);
  }
  
//===============================================================  Set Home
  void setHomeClass( int ERclass )
  {
    ERhome = ERclass;
  }

//===============================================================  Update the Lattice
  void update( Lattice z )
  {
  }

//===============================================================  Draw
  void drawErosion()
  {
      noStroke();
      if ( active == true) 
      {
        //blendModee(ADD);
        fill( 0, 40 );
        rectMode(CENTER);
        rect( loc.x, loc.y, 40, 40 );
      }
      noStroke();
  }
//===============================================================  Remove Dead
    void removeDead()
    {
      Iterator iter = events.iterator();
      Erosion tempEvent;
    
      while( iter.hasNext() )
      {    
        tempEvent = (Erosion)iter.next();
        if( tempEvent.active == true )
        { 
          iter.remove();
        }
      }    
    }
    
//===============================================================  Overlaps with Erosion Zone    
    boolean containsER(PVector z) {
        if (z.x <= loc.x - radius || z.x > loc.x + radius) return false;
        if (z.y <= loc.y - radius || z.y > loc.y + radius) return false;
        return true;
    }
  
}