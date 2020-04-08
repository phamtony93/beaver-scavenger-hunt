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
            onPressed: null
          ),
          Container(
            width: 2,
            height:30,
            color: Colors.orange,
            margin: EdgeInsets.only(right: 12.0, left: 8.0),
          ),
          Text('VIDEO'),
          IconButton(icon: Icon(Icons.videocam),
            iconSize: 30.0,
            color: Colors.orange,
            tooltip: 'Take Video',
            onPressed: null
          ),
          IconButton(icon: Icon(Icons.stop),
            iconSize: 30.0,
            color: Colors.orange,
            tooltip: 'Stop Video',
            onPressed: null
          ),
        ],)
      ],

    );
  }
}