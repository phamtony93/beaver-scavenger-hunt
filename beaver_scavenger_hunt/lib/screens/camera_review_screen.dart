import 'package:flutter/material.dart';
import '../models/user_details_model.dart';
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
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'R', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'eview ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
                TextSpan(text: 'P', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'hoto/', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
                TextSpan(text: 'V', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'ideo', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
              ]
            )
          ),
          centerTitle: true,
        ),
      body: CameraReview(path: path, isImage: isImage, fileName: fileName, userDetails: userDetails, challengeNum: challengeNum, allChallenges:allChallenges),
    );
  }
}