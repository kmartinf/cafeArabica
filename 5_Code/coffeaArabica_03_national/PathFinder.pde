// AGENT CLASS THAT NAVIGATES A COST SURFACE

class PathFinder
{
    Kernel         k;            // each agent has a kernel
    PVector      loc;            // and a location. no velocity this time
    boolean foundRoad = false;   // once the agent is on the road->true
    boolean  atTarget = false;   // once the agent is on the road pixel that is closest to target->true
        int     speed = 3;       // the kernel size is also the agent speed
                                 // if the kernel is bigger, the agent can 
                                 // see further ahead, and jump to the road pixel
                                 // that is closer to the target

 //---------------------------------------------------------------//   
      PathFinder( float x, float y )
      {
          loc = new PVector(x,y);
            k = new Kernel();
            k.setNeighborhoodDistance(speed);
            k.isNotTorus();   
      };
 
//---------------------------------------------------------------//   
      void findRoad( Lattice l, int non_road )
      {
            k.setNeighborhoodDistance(width/2); // just very big
                                                // to find the nearest road point
           
            float minDist = width*2; // just make it big to start
            int   argMinX = 0;
            int   argMinY = 0;
            
            // 1. opens a very big kernel around the agent's location
            // 2. stores neighbors in an ArrayList of PVectors
            // 3. looks through all neighbors and finds the closest one
            //    that has a pixel with the road value in it
            // 4. updates its location to that road pixel
            // 5. sets the boolean that says it has found the road
            // 6. resizes the kernel to a normal range
            
            ArrayList<PVector> pv = k.getPVList(l,loc);
            for( PVector p : pv )
            {
                if( p.z > 0  && p.z != non_road ){ // finds a road pixel
                    float thisDist = dist( loc.x, loc.y, p.x, p.y );
                    
                    if( thisDist < minDist ){ // checks to see if it is the closest so far enountered
                        minDist = thisDist;
                        argMinX = (int)p.x;
                        argMinY = (int)p.y;
                    }
                }
                
            }//end for()

            foundRoad = true;
                  loc = new PVector( argMinX, argMinY );
            k.setNeighborhoodDistance(speed);

      };
     
//---------------------------------------------------------------//
      void update( Lattice l )
      {
            minimize(l);
            checkTarget(l);
      };
//---------------------------------------------------------------//            
      void minimize( Lattice l )
      {
          // look at all of the neighbors in the current kernel 
          // (of size, 'speed' above)
          // find the pixel with the smallest value and move there
          // this is how the cost surface is structured. road pixel
          // values increase as they move away from the target.
          // non-road pixels have the largest value in the lattice
          // therefore, the location on the road that gets an agent
          // closer to the target is always the smallest valued one.
          // ... so move there.
        
          loc = k.getMin(l, loc);
          
      };
//---------------------------------------------------------------//            
      void checkTarget( Lattice l )
      {
          // the closest road pixel to the target always
          // has a value of 1. if the road pixel that the
          // agent is currently sitting on has the value of 1
          // it has arrived at its destination
          // set 'atTarget' == true
        
          PVector test = k.getMin(l, loc);
          if( test.z == 1 ){
              atTarget = true;
          }
      };      
//---------------------------------------------------------------//      
      void drawMe()
      {
          // color the agent red
          noStroke();
          fill(255,255,0,100);
          
          // if it is at the target, color it green
          if(atTarget == true ) {
              fill(0,255,0);
          }

          ellipseMode( CENTER );
          ellipse( loc.x, loc.y, 3, 3 );
          
          // draw a little halo
          //noFill();
          //noStroke();
          //ellipseMode( CENTER );
          //ellipse(loc.x, loc.y, 50, 50);  
      };



}