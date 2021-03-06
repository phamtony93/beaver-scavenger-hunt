// Packages
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
//Screens
import '../screens/video_uploading_screen.dart';
import '../screens/challenge_screen.dart';
// Models
import '../models/user_details_model.dart';
import '../models/media_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/upload_media.dart';
// Styles
import '../styles/styles_class.dart';

class CameraReview extends StatefulWidget {
  final String path;
  final bool isImage;
  final String fileName;
  final int whichLocation;
  final int challengeNum;
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final DateTime beginTime;

  CameraReview({Key key, this.path, this.isImage, this.whichLocation, this.fileName, this.userDetails, this.challengeNum, this.allLocations, this.allChallenges, this.beginTime}) : super(key: key);

  @override
  _CameraReviewState createState() => _CameraReviewState();
}

class _CameraReviewState extends State<CameraReview> {
  Media photo = Media();
  Media video = Media();
  VideoPlayerController _videoController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    print('challenge number:');
    print(widget.challengeNum);
    if(!widget.isImage) {
      print("widgetPath: ${widget.path}");
      _videoController = VideoPlayerController.file(File(widget.path));
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(!widget.isImage) {
      _videoController.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column( 
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height:20),
        Text('Review your photo/video. Go back to retake.'),
        media(widget.isImage),
        videoRow(widget.isImage),
        SizedBox(height:20),
        Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.only(left:10, right: 10),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Styles.osuOrange),
          child: IconButton(icon: Icon(Icons.file_upload),
            hoverColor: Colors.green,
            highlightColor: Colors.grey,
            color: Colors.white,
            tooltip: 'Submit',
            onPressed: ()  {
              if(widget.isImage){
                savePhoto();
                uploadPhoto();
              }
              else {
                saveVideo();
                Navigator.of(context).push(MaterialPageRoute(
                  builder:  (context) => 
                  VideoUploading(
                    path: widget.path, 
                    fileName: widget.fileName, 
                    userDetails: widget.userDetails, 
                    challengeNum: widget.challengeNum, 
                    allChallenges: widget.allChallenges,
                    allLocations: widget.allLocations,
                    whichLocation: widget.whichLocation,
                    beginTime: widget.beginTime,
                  )
                ));
              }
            }
          ),
        ),
        SizedBox(height:20),
      ]
    );
  }

  Widget media(isImage) {
    if(isImage) {
      return Expanded(child: 
          Padding(padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.file(File(widget.path), fit: BoxFit.contain, alignment: Alignment.topCenter,)
          ))
      );
    }
    else {
      return Expanded(child: 
          Padding(padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: previewVideo()
          ))
      );
    }
  }

  Widget previewVideo() {
    /*
    if(_videoController.value.initialized) {
      print('true');
    }
    else {
      print('false');
    }*/
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoController.value.size != null ? _videoController.value.aspectRatio : 2 / 2,
            child: VideoPlayer(_videoController),
          );
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget videoRow(isImage) {
    if(!isImage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_videoController.value.isPlaying ? 'PAUSE' : 'PLAY'),
          IconButton(icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_circle_filled),
            // splashColor: Colors.purple,
            hoverColor: Colors.green,
            // focusColor: Colors.blue,
            highlightColor: Colors.grey,
            color: Styles.osuOrange,
            iconSize: 30.0,
            tooltip: 'Play/Stop Video',
            onPressed: () {
              setState (() {
                if(_videoController.value.isPlaying) {
                  _videoController.pause();
                }
                else {
                  _videoController.play();
                }
              });
            }
          ),
        ],
      );
    }
    else {
      return SizedBox(height:0);
    }
  }

  void savePhoto() {
    GallerySaver.saveImage(widget.path, albumName: 'Beavers').then((bool success) {
      print('Photo saved to phone');
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Photo Saved to Phone', textAlign: TextAlign.center))
      );
    });
  }

  void uploadPhoto() {
    //print(widget.fileName);
    uploadMedia(widget.path, widget.fileName).then((String url) {
      photo.setURL(url);
      print(photo.getURL());
      addURLtoFirebase();
      updateList();
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Photo Uploaded', textAlign: TextAlign.center))
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:  (context) => ChallengeScreen(
            allLocations: widget.allLocations,
            whichLocation: widget.whichLocation,
            allChallenges: widget.allChallenges, 
            userDetails: widget.userDetails,
            beginTime: widget.beginTime,
          )
        )
      );
    });
  }

  void addURLtoFirebase() {
    Firestore.instance.collection('users').document(widget.userDetails.uid).updateData({
      'challenges.${widget.challengeNum+1}.photoUrl': photo.getURL(), 
      'challenges.${widget.challengeNum+1}.completed' : true,
    });
  }

  void updateList() {
    widget.allChallenges[widget.challengeNum].completed = true;
    widget.allChallenges[widget.challengeNum].photoUrl = photo.getURL();
  }

  void saveVideo() {
    GallerySaver.saveVideo(widget.path, albumName: 'Beavers').then((bool success) {
      print('Video saved to phone');
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text('Video Saved to Phone'))
      // );
    });
  }

}