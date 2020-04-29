import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
//import '../functions/media_upload.dart';
import '../models/media.dart';
import '../main.dart';

class Camera extends StatefulWidget {

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String pathImage;
  String pathVideo;
  bool isRecordingVideo = false;
  Media photo = Media();
  Media video = Media();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(camera, ResolutionPreset.medium);
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
        Text('Should the clue text be sent in here??'),
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            child: IconButton(icon: Icon(Icons.camera_alt),
              splashColor: Colors.purple,
              hoverColor: Colors.green,
              focusColor: Colors.blue,
              highlightColor: Colors.grey,
              color: Colors.white,
              tooltip: 'Take Photo',
              iconSize: 30.0,
              onPressed: () async {
                await takePhoto();
                //photo.setURL(await uploadMedia(pathImage) ); implement after merge
              }
            ),
          ),
          Container(
            width: 2,
            height:30,
            color: Colors.orange,
            margin: EdgeInsets.only(right: 12.0, left: 8.0),
          ),
          Text('VIDEO'),
           Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(left:10, right: 10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            child: IconButton(icon: Icon(isRecordingVideo ? Icons.stop : Icons.videocam),
              // splashColor: Colors.purple,
              hoverColor: Colors.green,
              // focusColor: Colors.blue,
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
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 2 / 2, //_controller.value.aspectRatio,
            child: CameraPreview(_controller));
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
      pathImage = p.join((await getApplicationDocumentsDirectory()).path,'${DateTime.now()}.jpg',);
      SystemSound.play(SystemSoundType.click);
      await _controller.takePicture(pathImage);
      print(pathImage);
      if (pathImage != null ) {
        GallerySaver.saveImage(pathImage, albumName: 'Beavers').then((bool success) {
          print('photo success');
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Photo Saved')
            )
          );
        });
      }
    }
    catch (e) {
      print(e);
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
      pathVideo = p.join((await getApplicationDocumentsDirectory()).path,'${DateTime.now()}.mp4',);
      print('starting video');
      await _controller.startVideoRecording(pathVideo);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Recording')
        )
      );
    }
    catch (e) {
      print(e);
    }
  }

  void stopVideo() async{
    setState( () {
        isRecordingVideo = false;
    });
    try {
      print('try to end video');
      await _controller.stopVideoRecording();
      if (pathVideo != null ) {
        GallerySaver.saveVideo(pathVideo, albumName: 'Beavers').then((bool success) {
          print('video success');
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Video Saved')
            )
          );
        });
      }
    }
    catch (e) {
      print(e);
    }
  }

}