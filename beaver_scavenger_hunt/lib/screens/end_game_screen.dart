// Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'login_screen.dart';
// Functions
import '../functions/add_points.dart';
import '../functions/calculate_points.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Widgets
import '../widgets/control_button.dart';
// Styles
import '../styles/styles_class.dart';

class EndGameScreen extends StatelessWidget {
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final DateTime beginTime;
  // final DateTime endTime;
  final String time;
  final int totalPoints;

  EndGameScreen({Key key, this.userDetails, this.allLocations, this.allChallenges, this.whichLocation, this.beginTime, this.totalPoints, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackPress(),
        child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'E', 
                    style: Styles.whiteBoldDefault
                  ),
                  TextSpan(
                    text: 'nd ', 
                    style: Styles.orangeNormalDefault
                  ),
                  TextSpan(
                    text: 'G', 
                    style: Styles.whiteBoldDefault
                  ),
                  TextSpan(
                    text: 'ame', 
                    style: Styles.orangeNormalDefault
                  ),
                ],
              ),
            ),
          centerTitle: true,
        ),
        body: summary(context),
      ),
    );
  }

  Widget summary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: <Widget>[
            SizedBox(height: 25.0),
            Text('Your Final Time and Score', style: Styles.blackBoldDefault),
            SizedBox(height: 25.0),
            Text('Finish Time:', style: Styles.orangeBoldDefault),
            Text(time, style: Styles.blackNormalDefault, textAlign: TextAlign.center,),
            SizedBox(height: 15.0),
            Text('Points:', style: Styles.orangeBoldDefault,),
            Text(totalPoints.toString(), style: Styles.blackNormalDefault, textAlign: TextAlign.center,),
            SizedBox(height: 25.0),
            Text('If you would like to play again,', textAlign: TextAlign.center),
            Text('sign out and join a new game.', textAlign: TextAlign.center),
            SizedBox(height: 20.0),
            ControlButton(
                  context: context,
                  text: 'Sign Out',
                  onPressFunction: _signOut,),
            SizedBox(height: 25.0),
            Text("LEADERBOARD", style: Styles.blackBoldDefault),
            Text('Ranking/Team/Points'),
            SizedBox(height: 15.0),
            Expanded(child:leaderboard()),
          ],
      )),
    );
  }

  // Widget getTime()  {
  //   Duration difference;
  //   difference = endTime.difference(beginTime);

  //   return Text((difference.inHours).toString().padLeft(2, '0') + 
  //       ':' + (difference.inMinutes%60).toString().padLeft(2, '0') + 
  //       ':' + (difference.inSeconds%60).toString().padLeft(2, '0'),
  //       style: Styles.blackNormalDefault, textAlign: TextAlign.center,);
  // }

  // Widget points() {
  //   totalPoints = calculatePoints(allLocations, allChallenges);
  //   addPoints(userDetails, totalPoints);
  //   return Text(
  //     totalPoints.toString(), 
  //     style: Styles.blackNormalDefault,
  //     textAlign: TextAlign.center,);
  // }

  void _signOut(BuildContext context) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Widget leaderboard() {
    return StreamBuilder(
        stream: Firestore.instance.collection("leaderboard").orderBy('totalPoints', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data.documents.length == 0) {
            return CircularProgressIndicator();
          } 
          else {
            List<DocumentSnapshot> allSnapshots = snapshot.data.documents;
          return 
          ListView.builder(
            itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data.documents[index];
                return ListTile(
                  dense: true,
                  leading: Text((index+1).toString(), style: TextStyle(fontSize: 16)),
                  title: Text(allSnapshots[index].documentID),
                  trailing: Text(doc['totalPoints'].toString(), style: Styles.blackBoldSmall),
                );
              },
            );
          }
        }
      );
  }

   Future<bool> _onBackPress() {
    return Future<bool>.value(false);
  }

}