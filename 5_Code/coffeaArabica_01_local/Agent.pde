import java.util.Iterator;

class Agent{

  PVector loc;
  PVector vel;
  
  boolean alive = true;
      int plantGrowth = 0;
      float fatality = 0.7;
      
  boolean sick = false;
  int days = 0;   //days sick
  int r = 0;
  int g = 255;
  int b = 0;
  int a = 50;
  
 
      Agent()
      {
         //random location on screen
         loc = new PVector( random(0,width), random(0,height) );
         //vel = new PVector( 0, 0 );
         
         r = 0;
         g = 255;
         b = 0;
         a = 50;
      }
      
      //for location of child
      Agent( float x, float y)
      {
            loc = new PVector( x , y );
            //vel = new PVector( 0, 0 );
      }
      
      void update()
      {
          if( frameCount%fps == 0 && sick == true)
          {
            days -= 1;
            if(days <= 0){ alive = false; }
          }
      }
 
      
      void drawAgent()
      {
         noStroke();
         
         if(alive == true)
         {
           fill( r, g, b, a );
           //blendMode(ADD);
           ellipse( loc.x, loc.y, 8, 8 );
           
           
           //add a little sick halo
           if( sick == true)
           {
             noFill();
             stroke(255, 0, 0, 100);
             ellipse(loc.x, loc.y, spreadDistance, spreadDistance);
           }
         }
         growPlant();
      }
      
      void growPlant()
      {
          if( plantGrowth <= 18 )
          {
              float radius = plantGrowth;
              //float alpha  = map(plantGrowth, 0, 48, 255, 0 );
              
              fill( r, g, b, a );
              ellipse( loc.x, loc.y, radius, radius ); 
              
              plantGrowth += 1;
          }
      }
      
      void removeDead()
{
    Iterator iter = pop.iterator();
    Agent tempAgent;
    
    while( iter.hasNext() )
    {    
        tempAgent = (Agent)iter.next();
        if( tempAgent.alive == false )
        { 
          iter.remove();
        }
    }

}
      
      void getSick(int minDay, int maxDay)
      {
          sick = true;
          days = (int)random( minDay, maxDay );
          
          r = 255;
          g = 0;
          b = 0;
          a = 30;
      }
      
      
}// end Agent class
 


//====================================================//
//====================================================//

void removeDead( ArrayList population )
{
    Iterator iter = population.iterator();
    Agent tempAgent;
    
    while( iter.hasNext() ){    
        tempAgent = (Agent)iter.next();
        if( tempAgent.alive == false ){
            iter.remove();
        }
    }
};
//====================================================//

//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017
//  Please cite author and course 
//  when using this library in any 
//  personal or professional project.