// Models
import '../models/clue_location_model.dart';

int completedCluesCount(List<ClueLocation> allLocations) {
    int count = 0;
    for (var index = 0; index < allLocations.length; index++) {
      if (allLocations[index].solved) {
        count += 1;
      }
    }
    return count;
  }