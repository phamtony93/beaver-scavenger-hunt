import 'package:flutter_test/flutter_test.dart';
import '../lib/functions/completed_clues_count.dart';
import '../lib/models/clue_location_model.dart';

void main() async{
    
  test('Testing completed_clues_count function', (){
      
      //create test vars
      int expectedCount = 0;
      
      //create 10 clue locations
      String cluePrefix = "Clue_";
      String solutionPrefix = "Solution_";
      List<ClueLocation> allLocations = [];
      for (int i = 0; i < 10; i++){
        String clue = cluePrefix + (i+1).toString();
        String solution = solutionPrefix + (i+1).toString();
        ClueLocation newLocation = ClueLocation(i+1, 22.22, 33.33, clue, solution);
        //add each location to list
        allLocations.add(newLocation);
      }

      int actualCount;
      // run function to count solved locations (0 solved)
      actualCount = completedCluesCount(allLocations);
      //assert expected results
      expect(actualCount, 0);

      //for each location
      for (int j = 0; j < 10; j++){
        //solve location and increment expected count
        allLocations[j].solved = true;
        expectedCount++;
        
        // run function to count solved locations
        actualCount = completedCluesCount(allLocations);
        //assert expected results
        expect(actualCount, expectedCount);
      }
  });
}