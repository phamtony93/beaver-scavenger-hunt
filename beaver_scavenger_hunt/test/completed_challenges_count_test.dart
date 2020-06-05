import 'package:flutter_test/flutter_test.dart';
import '../lib/functions/completed_challenges_count.dart';
import '../lib/models/challenge_model.dart';

void main() async{
    
  test('Testing completed_challenges_count function', (){
      
      //create test vars
      int expectedCount = 0;
      
      //create 10 clue locations
      String challengePrefix = "Challenge_";
      List<Challenge> allChallenges = [];
      for (int i = 0; i < 10; i++){
        String challenge = challengePrefix + (i+1).toString();
        Challenge newChallenge = Challenge(i+1, false, challenge, challenge);
        //add each location to list
        allChallenges.add(newChallenge);
      }

      int actualCount;
      // run function to count completed challenges
      actualCount = completedChallengesCount(allChallenges);
      //assert expected results (0 completed)
      expect(actualCount, 0);

      //for each challenge
      for (int j = 0; j < 10; j++){
        //complete challenge and increment expected count
        allChallenges[j].completed = true;
        expectedCount++;
        
        // run function to count completed challenges
        actualCount = completedChallengesCount(allChallenges);
        //assert expected results
        expect(actualCount, expectedCount);
      }
  });
}