import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/models/UserDetails.dart';
import '../widgets/camera_review.dart';
import '../models/challenge_model.dart';

class CameraReviewScreen extends StatelessWidget {
   final String path;
   final bool isImage;
   final String fileName;
   final int challengeNum;
   final UserDetails userDetails;
   final List<Challenge> allChallenges;

  CameraReviewScreen({Key key, this.path, this.isImage, this.fileName, this.userDetails, this.challengeNum, this.allChallenges}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Review Photo/Video'),
          centerTitle: true,
      ),
      body: CameraReview(path: path, isImage: isImage, fileName: fileName, userDetails: userDetails, challengeNum: challengeNum, allChallenges:allChallenges),
    );
  }
}