import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/models/UserDetails.dart';
import '../widgets/camera.dart';
import '../models/challenge_model.dart';

class CameraScreen extends StatelessWidget {
  final UserDetails userDetails;
  final int challengeNum;
  final List<Challenge> allChallenges;

  CameraScreen({Key key, this.userDetails, this.challengeNum, this.allChallenges}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Take a Photo/Video'),
          centerTitle: true,
      ),
      body: Camera(userDetails: userDetails, challengeNum: challengeNum, allChallenges: allChallenges)
    );
  }
}