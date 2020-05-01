import 'UserDetails.dart';
import 'package:beaver_scavenger_hunt/models/challenge_model.dart';
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';

class ScreenArguments {
  UserDetails user;
  List<ClueLocation> allLocations;
  List<Challenge> allChallenges;

  ScreenArguments({this.user, this.allChallenges, this.allLocations});
}