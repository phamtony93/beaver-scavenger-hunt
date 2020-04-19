import 'package:flutter/material.dart';
import '../widgets/camera_review.dart';

class CameraReviewScreen extends StatelessWidget {
   final path;
   final isImage;
   final fileName;

  CameraReviewScreen({Key key, this.path, this.isImage, this.fileName}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Review Photo/Video'),
          centerTitle: true,
      ),
      body: CameraReview(path: path, isImage: isImage, fileName: fileName),
    );
  }
}