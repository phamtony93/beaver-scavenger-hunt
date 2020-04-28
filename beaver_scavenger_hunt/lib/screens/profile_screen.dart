import 'package:beaver_scavenger_hunt/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  final UserDetails userDetails;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  ProfileScreen({Key key, this.userDetails, this.allChallenges, this.allLocations}) : super(key: key);

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

  void _signOut(BuildContext context) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  int getPrelimPoints() {
    int cluePoints = 10;
    int challengePoints = 5;
    int timerDeduction = -1;

    int cluePointsEarned = cluePoints * completedCluesCount();
    int challengePointsEarned = challengePoints * completedChallengesCount();
    int timerPointsDeducted = 2 * timerDeduction;

    return (cluePointsEarned + challengePointsEarned + timerPointsDeducted);
  }

  @override
  Widget build(BuildContext context) {
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'P', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              TextSpan(text: 'rofile', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)))
            ]
          )
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userDetails.photoUrl),
                radius: 75.0,
              ),
              SizedBox(height: 25.0),
              Text("Name : ${userDetails.userName}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Email : ${userDetails.userEmail}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Clues Completed: ${completedChallengesCount()}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Challenges Completed: ${completedCluesCount()}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Current Time: xx", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Prelimnary Points Eearned: ${getPrelimPoints()}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 25.0),
              RaisedButton(
                child: Text('Sign Out'),
                onPressed: () {
                  _signOut(context);
                },
              )
            ]
          )
        )
      )
    );
  }
}