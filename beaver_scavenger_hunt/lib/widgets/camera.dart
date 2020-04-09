import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../main.dart';

class Camera extends StatefulWidget {

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

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
        Text('Should the clue text be sent in here??'),
        Expanded(child: 
          Padding(padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: preview()))
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('PHOTO'),
          IconButton(icon: Icon(Icons.camera_alt, color: Colors.orange),
            //splashColor: Colors.blue,
            //hoverColor: Colors.blue,
            //focusColor: Colors.blue,
            //highlightColor: Colors.blue,
            tooltip: 'Take Photo',
            iconSize: 30.0,
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final path = p.join((await getApplicationDocumentsDirectory()).path,'${DateTime.now()}.jpg',);

                await _controller.takePicture(path);
                print(path);
                if (path != null ) {
                  GallerySaver.saveImage(path, albumName: 'Beavers').then((bool success) {
                    print('success');
                  });
                }
              }
              catch (e) {
                print(e);
              }
            }
          ),
          Container(
            width: 2,
            height:30,
            color: Colors.orange,
            margin: EdgeInsets.only(right: 12.0, left: 8.0),
          ),
          Text('VIDEO'),
          IconButton(icon: Icon(Icons.videocam, color: Colors.orange),
            iconSize: 30.0,
            color: Colors.orange,
            tooltip: 'Take Video',
            onPressed: null
          ),
          IconButton(icon: Icon(Icons.stop, color: Colors.orange),
            iconSize: 30.0,
            color: Colors.orange,
            tooltip: 'Stop Video',
            onPressed: null
          ),
        ],)
      ]);
  }


  Widget preview() {
    return FutureBuilder<void> (
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 1, //_controller.value.aspectRatio,
            child: CameraPreview(_controller));
          // return Center(child: Column(
          //   children: [ Text('all the text here'),
          //     CameraPreview(_controller),
          //   ]
          // ));
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

}