// Packages
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// Screens
import '../screens/camera_review_screen.dart';
import '../main.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Styles
import '../styles/styles_class.dart';

class Camera extends StatefulWidget {
  final UserDetails userDetails;
  final int challengeNum;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  final int whichLocation;
  final DateTime beginTime;

  Camera({Key key, this.userDetails, this.challengeNum, this.allChallenges, this.allLocations, this.whichLocation, this.beginTime}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String fileName;
  String pathImage;
  String pathVideo;
  bool isRecordingVideo = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Column( children: <Widget>[
        SizedBox(height:20),
        Padding(padding: EdgeInsets.only(left:15, right:15),
        child: Text(widget.allChallenges[widget.challengeNum].description),),
        Expanded(child: 
          Padding(padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: preview()))
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('PHOTO'),
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(left:10, right: 10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Styles.osuOrange),
            child: IconButton(icon: Icon(Icons.camera_alt),
              hoverColor: Colors.green,
              highlightColor: Colors.grey,
              color: Colors.white,
              tooltip: 'Take Photo',
              iconSize: 30.0,
              onPressed: () async {
                await takePhoto();
              }
            ),
          ),
          Container(
            width: 2,
            height:30,
            color: Styles.osuOrange,
            margin: EdgeInsets.only(right: 12.0, left: 8.0),
          ),
          Text('VIDEO'),
           Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(left:10, right: 10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Styles.osuOrange),
            child: IconButton(icon: Icon(isRecordingVideo ? Icons.stop : Icons.videocam),
              hoverColor: Colors.green,
              highlightColor: Colors.grey,
              color: Colors.white,
              tooltip: 'Take Video',
              onPressed: () {
                if(!isRecordingVideo) {
                  takeVideo();
                }
                else {
                  stopVideo();
                }
              }
            ),),
        ],),
        SizedBox(height:40)
      ]);
  }


  Widget preview() {
      return FutureBuilder<void> (
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if(!_controller.value.isInitialized || _controller == null) {
            return Text('Camera Error: Please accept camera permissions.', style: Styles.bold, textAlign: TextAlign.center,);
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            return RotatedBox(
                quarterTurns: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 0,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller)
                ),
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }

  Future<void> takePhoto() async {
    if(!_controller.value.isInitialized) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error')
        )
      );
      return null;
    }

    try {
      await _initializeControllerFuture;
      fileName = '${DateTime.now()}.jpg';
      pathImage = p.join((await getApplicationDocumentsDirectory()).path, fileName);
      await _controller.takePicture(pathImage);
      print(pathImage);
      if (pathImage != null ) {
         Navigator.of(context).push(
           MaterialPageRoute(builder:  (context) => 
           CameraReviewScreen(
             path: pathImage, 
             isImage: true, 
             fileName: fileName, 
             userDetails: widget.userDetails, 
             challengeNum: widget.challengeNum, 
             allChallenges: widget.allChallenges,
             allLocations: widget.allLocations,
             whichLocation: widget.whichLocation,
             beginTime: widget.beginTime
            )
          )
        );
      }
    }
    catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error'))
      );
    }

    setState(() {});
  }

  void takeVideo() async {
    if(!_controller.value.isInitialized) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error')
        )
      );
      return null;
    }

    setState( () {
      isRecordingVideo = true;
    });

    try {
      await _initializeControllerFuture;
      fileName = '${DateTime.now()}.mp4';
      pathVideo = p.join((await getApplicationDocumentsDirectory()).path, fileName);
      print('starting video');
      await _controller.startVideoRecording(pathVideo);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Recording')
        )
      );
    }
    catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error'))
      );
    }
  }

  void stopVideo() async{
    setState( () {
        isRecordingVideo = false;
    });
    try {
      print('try to end video');
      await _controller.stopVideoRecording();
      print('video stopped');
      if (pathVideo != null ) {
        Navigator.of(context).push(
           MaterialPageRoute(builder:  (context) => 
           CameraReviewScreen(
             path: pathVideo, 
             isImage: false, 
             fileName: fileName, 
             userDetails: widget.userDetails, 
             challengeNum: widget.challengeNum, 
             allChallenges: widget.allChallenges,
             allLocations: widget.allLocations,
             whichLocation: widget.whichLocation,
             beginTime: widget.beginTime
            )
          )
        );
      }
    }
    catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error'))
      );
    }
  }

}