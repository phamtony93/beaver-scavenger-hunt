// Packages
import 'package:flutter/material.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Widgets
import '../widgets/camera.dart';

class CameraScreen extends StatelessWidget {
  final UserDetails userDetails;
  final int challengeNum;
  final List<Challenge> allChallenges;

  CameraScreen({Key key, this.userDetails, this.challengeNum, this.allChallenges}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
     appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'T', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'ake a ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
                TextSpan(text: 'P', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'hoto/', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
                TextSpan(text: 'V', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'ideo', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
              ]
            )
          ),
          centerTitle: true,
        ),
      body: Camera(userDetails: userDetails, challengeNum: challengeNum, allChallenges: allChallenges)
    );
  }
}