// This is a test package for the Challenge Model.

import 'package:flutter_test/flutter_test.dart';
import '../lib/models/challenge_model.dart';

void main() {
  test('Testing correct Challenge creation', (){

      //create test vars
      int test_number = 10;
      bool test_completed = true;
      String test_description = "test_description_1";
      String test_photoUrl = "test_url";

      //create challenge using test vars
      final test_challenge = Challenge(test_number, test_completed, test_description, test_photoUrl);

      //assert expected results
      expect(test_challenge.number, test_number);
      expect(test_challenge.completed, test_completed);
      expect(test_challenge.description, test_description);
      expect(test_challenge.photoUrl, test_photoUrl);
      expect(test_challenge.confirmed, false);
      expect(test_challenge.checked, false);

  });

  test('Testing Challenge to-and-from json', (){
      
      //create test vars
      int test_number = 10;
      bool test_completed = true;
      String test_description = "test_description_1";
      String test_photoUrl = "test_url";

      //create challenge using test vars
      final Challenge test_challenge1 = Challenge(test_number, test_completed, test_description, test_photoUrl);

      //create new challenge by encoding to json, then decoding back into challenge
      final Challenge test_challenge2 = Challenge.fromJson(test_challenge1.toJson());
      
      //assert expected results
      expect(test_challenge2.number, test_number);
      expect(test_challenge2.completed, test_completed);
      expect(test_challenge2.description, test_description);
      expect(test_challenge2.photoUrl, test_photoUrl);
      expect(test_challenge2.confirmed, false);
      expect(test_challenge2.checked, false);

  });
}