import 'package:flutter/material.dart';
//import '../widgets/camera.dart';
import '../functions/upload_media.dart';
import '../models/media.dart';
import '../screens/login_screen.dart';

class VideoUploading extends StatefulWidget {
  final path;
  final fileName;

  VideoUploading({Key key, this.path, this.fileName}) : super(key: key);

  @override
  _VideoUploadingState createState() => _VideoUploadingState();
}

class _VideoUploadingState extends State<VideoUploading> {
  Future _uploadVideoFuture;
  Media video = Media();
  
  @override
  void initState() {
    _uploadVideoFuture = uploadVideo();
    super.initState();
  }
  
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Uploading...'),
          centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        waiting(),
      ],),
    );
  }

  Widget waiting() {
    return FutureBuilder(
      future: _uploadVideoFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          print('should not see this');
          return Center(child: Text('Done Uploading'));
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  uploadVideo()  {
    uploadMedia(widget.path, widget.fileName).then((String url) {
      video.setURL(url);
      print(video.getURL());
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text('Video Uploaded'))
      // );
     Navigator.of(context).push(MaterialPageRoute(builder:  (context) => LoginScreen() ));
    });
  }

  
}