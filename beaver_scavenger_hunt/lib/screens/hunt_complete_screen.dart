import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';

class HuntCompleteScreen extends StatelessWidget {
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;

   HuntCompleteScreen({Key key, this.userDetails, this.allLocations, this.allChallenges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Hunt Complete'),
          centerTitle: true,
      ),
      //body: completedCluesCount() == 10 ? complete () : notComplete()
      body: complete()
    );
  }

  int completedChallengesCount() {
    int count = 0;
    for (var index = 0; index < allChallenges.length; index++) {
      if (allChallenges[index].solved) {
        count +=1;
      }
    }
    return count;
  }

  int completedCluesCount() {
    int count = 0;
    for (var index = 0; index < allLocations.length; index++) {
      if (allLocations[index].solved) {
        count += 1;
      }
    }
    return count;
  }

  Widget complete() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, 
      children: <Widget>[
        Text('Hunt Complete'),
        Text("Clues Completed: ${completedCluesCount()}", style: TextStyle(fontSize: 24),),
        SizedBox(height: 15.0),
        //Text("Challenges Completed: ${completedChallengesCount()}", style: TextStyle(fontSize: 24),),
        SizedBox(height: 15.0),
      ],);
  }

  Widget notComplete() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, 
      children: <Widget>[
        Text('Hunt Not Complete Yet'),
        Text("Clues Completed: ${completedCluesCount()}", style: TextStyle(fontSize: 24),),
        SizedBox(height: 15.0),
        //Text("Challenges Completed: ${completedChallengesCount()}", style: TextStyle(fontSize: 24),),
        SizedBox(height: 15.0),
      ],);
  }
}