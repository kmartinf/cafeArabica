class MultiTargetFinder extends PathFinder{
  
        // MultiTargetFinder has all of the functions of PathFinder with a few new tricks
        // It can read in an ArrayList of costsurfaces (i.e. paths to multiple targets )
        // it spends a certain amount of time at a target before moving on to the next one
        // in a continuous loop...
        
        int currentTarget = 0;       // this holds the number of the current cost surface it is reading
        int timeCounter   = 0;       // this counter is used to calculate how long it has been at a target, once there  
        int timerCutOff   = 30 * 1;  // sit at each target roughly 3 seconds
        
  
//---------------------------------------------------//
        MultiTargetFinder( float x, float y )
        {
              super( x, y );
        };

//---------------------------------------------------//
        void findRoad(  ArrayList<Lattice> costSurfaces )
        {
              // passes the first lattice from the ArrayList to PathFider.findRoad()
              // uses the max() function to get the NON_ROAD value, since NON_ROAD pixels
              // have the maximum "cost" in the cost surface
              
              findRoad( costSurfaces.get(0), (int) costSurfaces.get(0).max() );
        };
        
//---------------------------------------------------//
        void update( ArrayList<Lattice> costSurfaces )
        {
               // currentTarget holds the number of the current cost surface / target path
               // the agent is working on. This is passed to the minimize and check target functions
               // as usual 
               minimize( costSurfaces.get( currentTarget )  );
            checkTarget( costSurfaces.get( currentTarget )  );
            
            // this is the new function that helps an agent step through
            // the various cost surfaces / target paths
            countTimeAtTarget( costSurfaces );  
        };
             
//---------------------------------------------------//
        void countTimeAtTarget( ArrayList<Lattice> csrf )
        {
            // once an agent gets to a target, it stays there for "timerCutOff" number of frames
            // it then updates the cost surface it is following and goes to the next target
            // it cycles through all of the target cost surfaces in the arrayList
          
            if( atTarget == true ) // if it is at its current target, start counting
            {                      // on every frame
                timeCounter += 1;   
            }
            
            if( timeCounter >= timerCutOff )
            {
                // if the counter goes above a threshold (in this case, about 3 seconds)
                // it is time to move on, so... 
                timeCounter = 0;       // reset counter;
                   atTarget = false;   // reset target flag
                
                // cycle through to the next target cost surface.
                // we use the % to make sure the index never gets bigger
                // than the size of the arrayList 
                
                currentTarget = (currentTarget+1) % csrf.size();
                // in the update, currentTarget will now index the next cost surface 
            }
        };
};