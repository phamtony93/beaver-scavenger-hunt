import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import '../widgets/camera.dart';

class CameraScreen extends StatelessWidget {
  final UserDetails userDetails;
  final int challengeNum;

  CameraScreen({Key key, this.userDetails, this.challengeNum}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Take a Photo/Video'),
          centerTitle: true,
      ),
      body: Camera(userDetails: userDetails, challengeNum: challengeNum),
    );
  }
}