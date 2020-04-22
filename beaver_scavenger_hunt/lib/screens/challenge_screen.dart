import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge_model.dart';

class ChallengeScreen extends StatefulWidget {
  
  //final List<Challenge> allChallenges;

  //ChallengeScreen({Key key, this.allChallenges}) : super(key: key);
  
  @override
  _ChallengeScreen createState() => _ChallengeScreen();
}

class _ChallengeScreen extends State<ChallengeScreen> {
  
  Widget isChallengeCompleted(bool isCompleted) {
    if (isCompleted) {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.green,
        size: 35);
    } else {
      return Icon(
        Icons.close,
        color: Colors.red,
        size: 35);
    }
  }

  Widget cameraIconOrPhoto(bool isCompleted, String photoUrl) {
    if (isCompleted && (photoUrl != null)) {
      return Image.network(photoUrl);
    } else {
      return Icon(
        Icons.photo_camera,
        size: 35,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'C', style: TextStyle(fontSize: 30)),
              TextSpan(text: 'ha', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
              TextSpan(text: 'l', style: TextStyle(fontSize: 30)),
              TextSpan(text: 'lenges', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
            ]
          )
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").document("uid123").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.data["challenges"].length == 0 || snapshot.data.data["challenges"].length == null) {
            return CircularProgressIndicator();
          } else {
          return 
          //ListOfChallenges(context, isChallengeCompleted, widget.allChallenges, cameraIconOrPhoto);
          ListView.builder(
            itemCount: snapshot.data.data["challenges"].length,
              itemBuilder: (context, index) {
                var document = snapshot.data.data["challenges"][(index+1).toString()];
                return ListTile(
                  leading: isChallengeCompleted(document["Completed"]),
                  title: Text(document["Description"]),
                  trailing: cameraIconOrPhoto(document["Completed"], document["photoUrl"]),
                );
              },
            );
          }
        }
      )
    );
  }
}
/*
Widget ListOfChallenges(BuildContext context, Widget Function(bool isCompleted) isChallengeCompleted, List<Challenge> allChallenges, Widget Function(bool isCompleted, String photoUrl) cameraIconOrPhoto){
  return ListView.builder(
    itemCount: allChallenges.length,
      itemBuilder: (context, index) {
        print(allChallenges[index].toJson());
        return ListTile(
          leading: isChallengeCompleted(allChallenges[index].completed),
          title: Text(allChallenges[index].description),
          trailing: cameraIconOrPhoto(allChallenges[index].completed, allChallenges[index].photoURL),
        );
      },
    );
}
*/