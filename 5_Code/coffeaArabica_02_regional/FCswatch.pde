public class FCswatch
{
      // a class that holds color values for Forest Cover
      // it is an array of color variables accessed by our forest density classification codesFC
      
      color[] FC;
  
      public FCswatch()
      {
           FC = new color[100];
   
           FC[0] = color( 0, 0, 0, 0 );     // 0-9%    forest
           FC[1] = color( 56, 63, 0 );     // 10-19%  forest
           FC[2] = color( 56, 63, 0 );     // 20-29%  forest
           FC[3] = color( 56, 63, 0 );     // 30-39%  forest
           FC[4] = color( 80, 88, 0 );      // 40-49%  forest
           FC[5] = color( 80, 88, 0 );      // 50-59%  forest
           FC[6] = color( 80, 88, 0 );      // 60-69%  forest       
           FC[7] = color( 80, 88, 0 );      // 70-79%  forest       
           FC[8] = color( 124, 122, 47 );   // 80-89%  forest
           FC[9] = color( 124, 122, 47 );   // 90-100% forest 
      };

      color getColor( int FCcode )
      {  
            color defaultColor = color(0,0,0); // enter an invalid code number and
                                               // get K back.
            
            return (FCcode >= 11 && FCcode <= 95)? FC[ FCcode ] : defaultColor;
      }
  
      color[] getSwatch()
      {
          return FC;
      }
  
}