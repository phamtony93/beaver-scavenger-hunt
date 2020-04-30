// This is a test package for the ClueLocation Model.

import 'package:flutter_test/flutter_test.dart';
import '../lib/models/clue_location_model.dart';

void main() {
  test('Testing correct ClueLocation model creation', (){

      //create test vars
      int test_number = 10;
      double test_latitude = 11.11;
      double test_longitude = -22.22;
      String test_clue = "test_clue";
      String test_solution = "test_solution";
      String test_photoURL = "test_photoUrl";

      //create clue location using test vars
      final test_clue_location = ClueLocation(test_number, test_latitude, test_longitude, test_clue, test_solution, test_photoURL);

      //assert expected results
      expect(test_clue_location.number, test_number);
      expect(test_clue_location.latitude, test_latitude);
      expect(test_clue_location.longitude, test_longitude);
      expect(test_clue_location.clue, test_clue);
      expect(test_clue_location.solution, test_solution);
      expect(test_clue_location.photoURL, test_photoURL);
      expect(test_clue_location.available, false);
      expect(test_clue_location.solved, false);
      expect(test_clue_location.found, false);
  });

  test('Testing ClueLocation to-and-from json', (){
      
      //create test vars
      int test_number = 10;
      double test_latitude = 11.11;
      double test_longitude = -22.22;
      String test_clue = "test_clue";
      String test_solution = "test_solution";
      String test_photoURL = "test_photoUrl";

      //create clue location using test vars
      final test_clue_location1 = ClueLocation(test_number, test_latitude, test_longitude, test_clue, test_solution, test_photoURL);

      //create new clue location by encoding to json, then decoding back into clue location
      final test_clue_location2 = ClueLocation.fromJson(test_clue_location1.toJson());
      
      //assert expected results
      expect(test_clue_location2.number, test_number);
      expect(test_clue_location2.latitude, test_latitude);
      expect(test_clue_location2.longitude, test_longitude);
      expect(test_clue_location2.clue, test_clue);
      expect(test_clue_location2.solution, false);
      expect(test_clue_location2.photoURL, false);
      expect(test_clue_location2.available, false);
      expect(test_clue_location2.solved, false);
      expect(test_clue_location2.found, false);
  });
}