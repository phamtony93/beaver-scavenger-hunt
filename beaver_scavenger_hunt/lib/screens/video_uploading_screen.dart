import 'package:flutter/material.dart';
import '../models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions/upload_media.dart';
import '../models/media_model.dart';
import '../screens/challenge_screen.dart';
import '../models/challenge_model.dart';

class VideoUploading extends StatefulWidget {
  final String path;
  final String fileName;
  final int challengeNum;
  final UserDetails userDetails;
  final List<Challenge> allChallenges;

  VideoUploading({Key key, this.path, this.fileName, this.userDetails, this.challengeNum, this.allChallenges}) : super(key: key);

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
          title: Text('Uploading...'),
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
      Navigator.of(context).push(MaterialPageRoute(builder:  (context) => ChallengeScreen(allChallenges: widget.allChallenges, userDetails: widget.userDetails) ));
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
    widget.allChallenges[widget.challengeNum].solved = true;
    widget.allChallenges[widget.challengeNum].available = false;
  }

  
}