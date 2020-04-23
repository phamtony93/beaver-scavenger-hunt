import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import '../functions/upload_media.dart';
import '../models/media.dart';
import '../screens/login_screen.dart';
import '../screens/video_uploading.dart';

class CameraReview extends StatefulWidget {
  final String path;
  final bool isImage;
  final String fileName;
  final int challengeNum;
  final String userid;

  CameraReview({Key key, this.path, this.isImage, this.fileName, this.userid, this.challengeNum}) : super(key: key);

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
    if(!widget.isImage) {
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            child: IconButton(icon: Icon(Icons.file_upload),
              // splashColor: Colors.purple,
              hoverColor: Colors.green,
              // focusColor: Colors.blue,
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
                  //uploadVideo();
                  Navigator.of(context).push(MaterialPageRoute(builder:  (context) => VideoUploading(path: widget.path, fileName: widget.fileName) ));
              }
            }
          ),),
          SizedBox(height:20),
    ]);
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
    if(_videoController.value.initialized) {
      print('true');
    }
    else {
      print('false');
    }

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
            color: Colors.orange,
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
        SnackBar(content: Text('Photo Saved to Phone'))
      );
    });
  }

  void uploadPhoto() {
    //print(widget.fileName);
    uploadMedia(widget.path, widget.fileName).then((String url) {
      photo.setURL(url);
      print(photo.getURL());
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Photo Uploaded'))
      );
      Navigator.of(context).push(MaterialPageRoute(builder:  (context) => LoginScreen() ));
    });
  }

  void saveVideo() {
    GallerySaver.saveVideo(widget.path, albumName: 'Beavers').then((bool success) {
      print('Video saved to phone');
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text('Video Saved to Phone'))
      // );
    });
  }

  // void uploadVideo() async {
  //   Scaffold.of(context).showSnackBar(
  //       SnackBar(content: Text('Video Uploading, Please Wait ...'))
  //     );
  //   uploadMedia(widget.path, widget.fileName).then((String url) {
  //     video.setURL(url);
  //     print(video.getURL());
  //     Scaffold.of(context).showSnackBar(
  //       SnackBar(content: Text('Video Uploaded'))
  //     );
  //    Navigator.of(context).push(MaterialPageRoute(builder:  (context) => LoginScreen() ));
  //   });
  // }



  // Widget waitForUpload() {
  //   //_uploadVideoFuture
  //   return FutureBuilder(
  //     future: _uploadVideoFuture,
  //     builder: (context, snapshot) {
  //       if(snapshot.connectionState == ConnectionState.done) {
  //         print('and in here');
  //         return Center(child: Text('all done'));
  //       }
  //       else {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }


}