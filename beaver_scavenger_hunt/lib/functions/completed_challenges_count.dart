// Models
import '../models/challenge_model.dart';

int completedChallengesCount(List<Challenge> allChallenges) {
    int count = 0;
    for (var index = 0; index < allChallenges.length; index++) {
      if (allChallenges[index].completed) {
        count +=1;
      }
    }
    return count;
  }