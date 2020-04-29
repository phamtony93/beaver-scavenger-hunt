import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/adminSpecificTeam_screen.dart';
import '../screens/login_screen.dart';
import '../models/challenge_model.dart';

class AdminTeamsListScreen extends StatelessWidget {


  @override
  Widget build (BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => LoginScreen()));
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Teams'),
            centerTitle: true,
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  int checked = 0;
                  int confirmed = 0;
                  int completed = 0;
                  for (int i = 1; i < snapshot.data.documents[index]["challenges"].length + 1; i++){
                    if (snapshot.data.documents[index]["challenges"]["$i"]["checked"] == true){
                      checked++;
                    }
                    if (snapshot.data.documents[index]["challenges"]["$i"]["confirmed"] == true){
                      confirmed++;
                    }
                    if (snapshot.data.documents[index]["challenges"]["$i"]["completed"] == true){
                      completed++;
                    }
                  }
                  var document = snapshot.data.documents[index];
                  int needToCheck = completed - checked;
                  return ListTile(
                    leading: completed == 0 ? Text("") 
                    : checked == 10 ? Icon(Icons.check_circle, color: confirmed < checked ? Colors.red : Colors.green) 
                    : needToCheck > 0 ? Icon(Icons.add_circle)
                    : Icon(Icons.check),
                    title: Text("${document["uid"]}"),
                    trailing: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: '$checked/$completed checked\n', style: TextStyle(color: confirmed == 10 ? Colors.green : Colors.black)),
                TextSpan(text: '$confirmed confirmed\n', style: TextStyle(color: confirmed == 10 ? Colors.green: Colors.black)),
                TextSpan(text: '${checked - confirmed} denied', style: TextStyle(color: checked - confirmed > 0 ? Colors.red : Colors.green))
              ],
            ),
          ),
                    onTap: (){
                      Map<String, dynamic> allChallengesMap = document['challenges'];

                      //create challenge object(s) from json map
                      List<Challenge> completedChallenges = [];
                      for (int i = 1; i < 11; i++){
                        Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
                        //if challenge is completed but unchecked
                        if (chall.completed == true && chall.checked == false){
                          //add it to list
                          completedChallenges.add(chall);
                        }
                      }
                      //push to specific team -> pass challenge object
                      if(checked == 10){
                        final snackBar = SnackBar(
                          content: Text(
                            "This team has already been checked",
                            textAlign: TextAlign.center
                          )
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      else if (completedChallenges.length < 1){
                        final snackBar = SnackBar(
                          content: Text(
                            "There are no more completed challenges to check at this time",
                            textAlign: TextAlign.center
                          )
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      else{
                        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: document["uid"], completedChallenges: completedChallenges, whichChallenge: 0) ));
                      }
                    },
                  );
                },
              );
            }
          }
        )
      )
    );
  }
}