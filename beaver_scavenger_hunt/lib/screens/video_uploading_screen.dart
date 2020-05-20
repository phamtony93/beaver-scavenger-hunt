// Packages
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'challenge_screen.dart';
// Models
import '../models/user_details_model.dart';
import '../models/media_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/upload_media.dart';
// Styles
import '../styles/styles_class.dart';

class VideoUploading extends StatefulWidget {
  final String path;
  final String fileName;
  final int challengeNum;
  final UserDetails userDetails;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  final int whichLocation;
  final DateTime beginTime;

  VideoUploading({Key key, this.path, this.fileName, this.userDetails, this.challengeNum, this.allChallenges, this.allLocations, this.whichLocation, this.beginTime}) : super(key: key);

  @override
  _VideoUploadingState createState() => _VideoUploadingState();
}

class _VideoUploadingState extends State<VideoUploading> {
  Future _uploadVideoFuture;
  Media video = Media();
  
  @override
  void initState() {
    _uploadVideoFuture = uploadVideo();
    super.initState();
  }
  
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'U', style: Styles.whiteBoldDefault),
                TextSpan(text: 'ploading', style: Styles.orangeNormalDefault),
              ]
            )
          ),
          centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        waiting(),
      ],),
    );
  }

  Widget waiting() {
    return FutureBuilder(
      future: _uploadVideoFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          print('should not see this');
          return Center(child: Text('Done Uploading'));
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  uploadVideo()  {
    uploadMedia(widget.path, widget.fileName).then((String url) {
      video.setURL(url);
      addURLtoFirebase();
      updateList();
      print(video.getURL());
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text('Video Uploaded'))
      // );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder:  (context) => 
          ChallengeScreen(
            allChallenges: widget.allChallenges,
            allLocations: widget.allLocations,
            whichLocation: widget.whichLocation,
            beginTime: widget.beginTime, 
            userDetails: widget.userDetails
          )
      ));
    });
  }

  void addURLtoFirebase() {
    Firestore.instance.collection('users').document(widget.userDetails.uid).updateData({
      'challenges.${widget.challengeNum+1}.photoUrl': video.getURL(), 
      'challenges.${widget.challengeNum+1}.completed' : true,
    });
  }

  void updateList() {
    widget.allChallenges[widget.challengeNum].completed = true;
    widget.allChallenges[widget.challengeNum].photoUrl = video.getURL();
  }

  
}