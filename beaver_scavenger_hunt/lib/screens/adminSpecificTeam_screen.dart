import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/adminTeamsList_screen.dart';
import 'package:swipedetector/swipedetector.dart';

class AdminSpecificTeamScreen extends StatelessWidget {

  final String teamID;
  final List<Challenge> completedChallenges;
  final int whichChallenge;

  AdminSpecificTeamScreen({Key key, this.teamID, this.completedChallenges, this.whichChallenge}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen()));
        },
        child: Scaffold(
        appBar: AppBar(
            title: Text('$teamID'),
            centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget> [
              SizedBox(height: 50),
              Text("${completedChallenges[whichChallenge].description}"),
              SizedBox(height: 50),
              completedChallenges[whichChallenge].completed == true ? 
              SwipeDetector(
                child: SizedBox(
                  height: 300, width: 300,
                  child: Container(
                    color: Colors.orange,
                    child: Center(
                      child: Text("${completedChallenges[whichChallenge].photoURL}"),
                    )
                  )
                ),
                onSwipeRight: (){
                  //YES
                  completedChallenges[whichChallenge].checked = true;
                  completedChallenges[whichChallenge].confirmed = true;
                  Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
                  Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.confirmed': true});
                  if (whichChallenge < completedChallenges.length - 1){
                    Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: teamID, completedChallenges: completedChallenges, whichChallenge: whichChallenge + 1) ));
                  }
                  else{
                    Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen()));
                  }
                },
                onSwipeLeft: (){
                  //NO
                  completedChallenges[whichChallenge].checked = true;
                  Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
                  if (whichChallenge < completedChallenges.length - 1){
                    Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: teamID, completedChallenges: completedChallenges, whichChallenge: whichChallenge + 1) ));
                  }
                  else{
                    Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen()));
                  }
                },
              )
              :
              Text("This clue has not been solved"),
              SizedBox(height: 50), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("No (swipe left)"),
                    
                    onPressed: (){
                      /*
                      completedChallenges[whichChallenge].checked = true;
                      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
                      if (whichChallenge < completedChallenges.length - 1){
                        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: teamID, completedChallenges: completedChallenges, whichChallenge: whichChallenge + 1) ));
                      }
                      else{
                        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen()));
                      }
                      */
                    }
                  ),
                  SizedBox(width: 100),
                  RaisedButton(
                    child: Text("Yes (swipe right)"),
                    onPressed: (){
                      /*
                      completedChallenges[whichChallenge].checked = true;
                      completedChallenges[whichChallenge].confirmed = true;
                      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
                      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.confirmed': true});
                      if (whichChallenge < completedChallenges.length - 1){
                        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: teamID, completedChallenges: completedChallenges, whichChallenge: whichChallenge + 1) ));
                      }
                      else{
                        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen()));
                      }
                      */
                    }
                  ),
                ],
              )
            ]
          )
        )
      )
    );
  }
}