// Packages
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';
import 'package:flutter/material.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Widgets
import '../widgets/camera.dart';
// Styles
import '../styles/styles_class.dart';

class CameraScreen extends StatelessWidget {
  final UserDetails userDetails;
  final int challengeNum;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  final int whichLocation;
  final DateTime beginTime;

  CameraScreen({Key key, this.userDetails, this.challengeNum, this.allChallenges, this.allLocations, this.whichLocation, this.beginTime}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
     appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'T', style: Styles.whiteBoldDefault),
                TextSpan(text: 'ake a ', style: Styles.orangeNormalDefault),
                TextSpan(text: 'P', style: Styles.whiteBoldDefault),
                TextSpan(text: 'hoto/', style: Styles.orangeNormalDefault),
                TextSpan(text: 'V', style: Styles.whiteBoldDefault),
                TextSpan(text: 'ideo', style: Styles.orangeNormalDefault),
              ]
            )
          ),
          centerTitle: true,
        ),
      body: Camera(
        userDetails: userDetails, 
        challengeNum: challengeNum, 
        allChallenges: allChallenges, 
        allLocations: allLocations, 
        whichLocation: whichLocation, 
        beginTime: beginTime
      )
    );
  }
}