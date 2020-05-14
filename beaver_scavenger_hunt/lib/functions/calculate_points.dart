// Functions
import '../functions/completed_clues_count.dart';
import '../functions/completed_challenges_count.dart';
// Models
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';

int calculatePoints(List<ClueLocation> allLocations, List<Challenge> allChallenges, int incorrectClues) {
    int cluePoints = 10;
    int challengePoints = 5;
    int cluePointDeduction = 5;
    print("Calculating challenge and clue points...");
    int cluePointsEarned = cluePoints * completedCluesCount(allLocations);
    print("Points from clues: $cluePointsEarned");
    int challengePointsEarned = challengePoints * completedChallengesCount(allChallenges);
    print("Points from challenges: $challengePointsEarned");
    int cluePointsDeducted = incorrectClues * cluePointDeduction;
    print("Points lost from incorrect clue guesses: $cluePointsDeducted");
    print("Total from challenges and clues: ${cluePointsEarned + challengePointsEarned - cluePointsDeducted}");

    return (cluePointsEarned + challengePointsEarned - cluePointsDeducted);
  }