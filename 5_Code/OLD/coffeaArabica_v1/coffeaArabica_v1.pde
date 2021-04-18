//Martin + Aaron
//COFFEA ARABICA
//v1

int initialPopulationSize = 100;
ArrayList<Agent> population;
int yearCounter = 0;
int framesPerYear = 24;
int currentPopulationSize = 0;
float birthRate = 0.031250;
float deathRate = 0.031250;

float seedDispersion = 0;

void setup()
{
    size(600, 600);
    frameRate( 24 );
    population = new ArrayList<Agent>(); 
    
    for( int i = 0; i < initialPopulationSize; i += 1 )
    {
          population.add(  new Agent()  ); 
    }
    
 

}

void draw()
{
     background( 0 );
     
     for( Agent a : population )
     {
         a.update();
         a.drawAgent();
     }
    
     seedDispersion = random(-10,10);

     if( frameCount % framesPerYear == 0 )
     {
        currentPopulationSize = population.size();
         removeDead();
         births();  
         println( "YEAR: " + yearCounter + "  POP: " + currentPopulationSize);
         yearCounter += 1;
     }
    
    
}

//========================================================//
void deaths()
{
    int numberToDie = round( deathRate * currentPopulationSize );
  
    while( numberToDie > 0 )
    {
        population.remove(0);
        numberToDie -= 1;
    }
    
}

void births()
{
    int numberToBeBorn = round( birthRate * currentPopulationSize );
    
    while( numberToBeBorn > 0 )
    {
          Agent parent = population.get( (int)random( population.size() ) );
          Agent child  = new Agent();
          

          
          child.loc    = new PVector( (parent.loc.x + seedDispersion), (parent.loc.y + seedDispersion ));
          
          population.add( child );
          numberToBeBorn -= 1;
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
