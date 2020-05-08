// Packages
import 'dart:math';
// Models
import '../models/clue_location_model.dart';

makeRandomDropdownList(allLocations, dropdownDataList)  {
    List<ClueLocation> allLocasCopy = List<ClueLocation>.from(allLocations);
    var rand = Random();
    int randNum;
    int max = 10;
    for (int i = 0; i < 10; i++){
      randNum = rand.nextInt(max);
      Map dropdownItem = {};
      dropdownItem["display"] = allLocasCopy[randNum].solution;
      dropdownItem["value"] = allLocasCopy[randNum].solution;
      dropdownDataList.add(dropdownItem);
      allLocasCopy.removeAt(randNum);
      max--;
    }
  }