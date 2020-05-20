// Packages
import 'package:flutter/material.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/camera_review.dart';
// Styles
import '../styles/styles_class.dart';

class CameraReviewScreen extends StatelessWidget {
   final String path;
   final bool isImage;
   final String fileName;
   final int challengeNum;
   final UserDetails userDetails;
   final List<Challenge> allChallenges;
   final List<ClueLocation> allLocations;
   final int whichLocation;
   final DateTime beginTime;


  CameraReviewScreen({Key key, this.path, this.isImage, this.fileName, this.userDetails, this.challengeNum, this.allLocations, this.whichLocation, this.beginTime, this.allChallenges}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'R', style: Styles.whiteBoldDefault),
                TextSpan(text: 'eview ', style: Styles.orangeNormalDefault),
                TextSpan(text: 'P', style: Styles.whiteBoldDefault),
                TextSpan(text: 'hoto/', style: Styles.orangeNormalDefault),
                TextSpan(text: 'V', style: Styles.whiteBoldDefault),
                TextSpan(text: 'ideo', style: Styles.orangeNormalDefault),
              ]
            )
          ),
          centerTitle: true,
        ),
      body: CameraReview(
        path: path, 
        isImage: isImage, 
        fileName: fileName, 
        userDetails: userDetails, 
        allLocations: allLocations, 
        whichLocation: whichLocation, 
        challengeNum: challengeNum, 
        allChallenges: allChallenges,
        beginTime: beginTime
      ),
    );
  }
}