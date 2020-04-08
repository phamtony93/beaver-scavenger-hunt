import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Take a Photo/Video'),
          centerTitle: true,
      ),
      body: camBody()

    );
  }

  Widget camBody () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text('Take Photo or Video'),
        Placeholder(),
        Row(children: <Widget>[
          IconButton(icon: Icon(Icons.camera_alt),
            onPressed: null
          ),
          IconButton(icon: Icon(Icons.videocam),
            onPressed: null
          ),
        ],)
      ],

    );
  }
}