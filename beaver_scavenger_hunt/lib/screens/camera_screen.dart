import 'package:flutter/material.dart';
import '../widgets/camera.dart';

class CameraScreen extends StatelessWidget {
  final String userid;
  final int challengeNum;

  CameraScreen({Key key, this.userid, this.challengeNum}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Take a Photo/Video'),
          centerTitle: true,
      ),
      body: Camera(userid: userid, challengeNum: challengeNum),
    );
  }
}