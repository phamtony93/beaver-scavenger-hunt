// Functions
import '../functions/completed_clues_count.dart';
import '../functions/completed_challenges_count.dart';
// Models
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';

int calculatePoints(List<ClueLocation> allLocations, List<Challenge> allChallenges) {
    int cluePoints = 10;
    int challengePoints = 5;
    int timerDeduction = -1;

    int cluePointsEarned = cluePoints * completedCluesCount(allLocations);
    int challengePointsEarned = challengePoints * completedChallengesCount(allChallenges);
    int timerPointsDeducted = 2 * timerDeduction;

    return (cluePointsEarned + challengePointsEarned + timerPointsDeducted);
  }