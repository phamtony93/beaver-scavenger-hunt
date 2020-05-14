// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'camera_screen.dart';
import 'profile_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/calculate_points.dart';
// Widgets
import '../widgets/menu_drawer.dart';

class ChallengeScreen extends StatefulWidget {
  
  final List<Challenge> allChallenges;
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final int whichLocation;
  final DateTime beginTime;


  ChallengeScreen({Key key, this.allChallenges, this.userDetails, this.allLocations, this.whichLocation, this.beginTime}) : super(key: key);
  
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

  Widget cameraIconOrPhoto(bool isCompleted, String photoUrl, int index) {
    if (isCompleted && (photoUrl != null)) {
      // if it's a video don't show preview
      if (index == 3 || index == 4 || index == 8) {
        return Icon(Icons.check, size: 35, color: Colors.grey);
      }
      else {
        return Image.network(photoUrl);
      }
    } else {
      // return Icon(
      //   Icons.photo_camera,
      //   size: 35,
      // );
      if (index == 3 || index == 4 || index == 8) { 
        return IconButton(icon: Icon(Icons.videocam, size: 35),
          color: Colors.orange,
              tooltip: 'Take Video',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:  (context) => CameraScreen(
                      userDetails: widget.userDetails, 
                      challengeNum: index, 
                      allChallenges: widget.allChallenges,
                      allLocations: widget.allLocations,
                      whichLocation: widget.whichLocation,
                      beginTime: widget.beginTime
                    )
                  )
                );
              }
      );
      }
      else {
        return IconButton(icon: Icon(Icons.photo_camera, size: 35),
          color: Colors.orange,
              tooltip: 'Take Photo',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:  (context) => CameraScreen(
                      userDetails: widget.userDetails, 
                      challengeNum: index, 
                      allChallenges: widget.allChallenges,
                      allLocations: widget.allLocations,
                      whichLocation: widget.whichLocation,
                      beginTime: widget.beginTime
                    )
                  )
                );
              }
      );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              TextSpan(text: 'hallenges', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
            ]
          )
        ),
        centerTitle: true,leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Menu",
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              
              var ds = await Firestore.instance.collection("users").document("${widget.userDetails.uid}").get();
              int incorrectClues = ds.data['incorrectClues'];
              int points = calculatePoints(widget.allLocations, widget.allChallenges, incorrectClues);
              
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => 
                  ProfileScreen(
                    userDetails: widget.userDetails, 
                    allChallenges: widget.allChallenges, 
                    allLocations: widget.allLocations,
                    beginTime: widget.beginTime,
                    points: points,
                  )
                )
              );
            }
          )
        ],
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          return MenuDrawer(
            context, 
            widget.allLocations, 
            widget.whichLocation, 
            widget.allChallenges, 
            widget.userDetails,
            widget.beginTime
          );
        }
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").document(widget.userDetails.uid).snapshots(),
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
                  leading: isChallengeCompleted(document["completed"]),
                  title: Text(document["description"]),
                  trailing: cameraIconOrPhoto(document["completed"], document["photoUrl"], index),
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