import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../functions/upload_media.dart';
import '../models/media.dart';

class CameraReview extends StatefulWidget {
  final path;
  final isImage;
  final fileName;

  CameraReview({Key key, this.path, this.isImage, this.fileName}) : super(key: key);

  @override
  _CameraReviewState createState() => _CameraReviewState();
}

class _CameraReviewState extends State<CameraReview> {
  Media photo = Media();
  Media video = Media();

  @override
  Widget build(BuildContext context) {
    return Column( 
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height:20),
        Text('Review your photo/video. Go back to retake.'),
        media(widget.isImage),
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
                  //print(photo.getURL);
                }
                else {
                  saveVideo();
                  uploadVideo();
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
          )));
    }
    else {
      return Text('it is a video');
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
    });
  }

  void saveVideo() {
    GallerySaver.saveVideo(widget.path, albumName: 'Beavers').then((bool success) {
      print('Video saved to phone');
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Video Saved to Phone'))
      );
    });
  }

  void uploadVideo() async {
    video.setURL(await uploadMedia(widget.path, widget.fileName) ); 
  }
}