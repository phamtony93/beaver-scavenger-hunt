import 'package:flutter/material.dart';
import '../widgets/camera.dart';

class CameraScreen extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Take a Photo/Video'),
          centerTitle: true,
      ),
      body: Camera(),
    );
  }
}