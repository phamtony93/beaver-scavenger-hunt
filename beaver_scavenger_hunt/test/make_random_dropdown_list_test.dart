import 'package:flutter_test/flutter_test.dart';
import '../lib/models/clue_location_model.dart';
import '../lib/functions/make_random_dropdown_list.dart';

void main() async{
    
  test('Testing make_random_dropdown_list function', (){
      //create test vars
      
      String cluePrefix = "Clue_";
      String solutionPrefix = "Solution_";
      //create 10 clue locations
      List<ClueLocation> allLocations = [];
      for (int i = 0; i < 10; i++){
        String clue = cluePrefix + (i+1).toString();
        String solution = solutionPrefix + (i+1).toString();
        ClueLocation newLocation = ClueLocation(i+1, 22.22, 33.33, clue, solution);
        //add each location to list
        allLocations.add(newLocation);
      }
      //empty dropdown list to fill
      List<Map> dropdownDataList = [];

      //run function to create dropdown list (randomized)
      makeRandomDropdownList(allLocations, dropdownDataList);
      
      //assert expected results
      
      //assert list has 10 elements
      expect(dropdownDataList.length, 10);
      
      //assert each element of list matches a clue location
      for (int i = 0; i < 10; i++){
        for (int j = 0; j < allLocations.length; j++){
          //if item matches location, remove location
          if (dropdownDataList[i]["display"] == allLocations[j].solution){
            allLocations.removeAt(j);
          }
          else
            continue;
        }
      }
      //assert all locations were matched (and therefore removed)
      expect(allLocations.length, 0);
  });
}