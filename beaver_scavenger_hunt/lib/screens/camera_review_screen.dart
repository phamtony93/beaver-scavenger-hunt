import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import '../widgets/camera_review.dart';

class CameraReviewScreen extends StatelessWidget {
   final String path;
   final bool isImage;
   final String fileName;
   final int challengeNum;
   final UserDetails userDetails;

  CameraReviewScreen({Key key, this.path, this.isImage, this.fileName, this.userDetails, this.challengeNum}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Review Photo/Video'),
          centerTitle: true,
      ),
      body: CameraReview(path: path, isImage: isImage, fileName: fileName, userDetails: userDetails, challengeNum: challengeNum),
    );
  }
}