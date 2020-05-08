// Packages
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

CameraDescription camera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  
 runApp(App());

}

Future<void> getCameras () async {
  final cameras = await availableCameras();
  camera = cameras.first;
}
