// Packages
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'admin_specific_team_screen.dart';
import 'admin_profile_screen.dart';
import 'login_screen.dart';
// Models
import '../models/challenge_model.dart';
// Styles
import '../Styles/styles_class.dart';

class AdminTeamsListScreen extends StatefulWidget {
  
  final UserDetails adminUser;
  final String gameCode;
  
  AdminTeamsListScreen({Key key, this.adminUser, this.gameCode}) : super(key: key);
  
  @override
  _AdminTeamsListScreenState createState() => _AdminTeamsListScreenState();
}

class _AdminTeamsListScreenState extends State<AdminTeamsListScreen> with SingleTickerProviderStateMixin{


  List<dynamic> myUsers;
  
  // This function gets all userIDs associated with
  // this admin's gameCode
  getUsers() async {
    var doc1 = await Firestore.instance.collection("games").document("${widget.gameCode}").get();
    myUsers = doc1.data == null ? null : doc1.data["playerIDs"];
    print("From game: ${widget.gameCode} grabbed users: $myUsers");
  }
  
  @override
  void initState() {
    super.initState();
    getUsers(); 
  }

  @override
  Widget build (BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => LoginScreen()
          )
        );
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.gameCode == null ? 
          Text("Game ID: Loading...")
          : 
          AppBarTextSpan(context, widget.gameCode),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () { 
                //Naviage to Profile Screen (with userDetails,
                // allChallenges, allLocations, and beginTime)
                print("Navigating to Profile Screen...");
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                    AdminProfileScreen(
                      userDetails: widget.adminUser,
                      gameCode: widget.gameCode,
                    )
                  )
                );
              },
            )
          ],
        ),
        // If users have not yet been obtained from function
        body: myUsers == null ? 
        // Display "Check for Teams" button, which sets State
        Builder(
          builder: (BuildContext scaffoldContext) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color.fromRGBO(255,117, 26, 1),
                  height: 80, width: 300,
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RaisedButton(
                      color: Colors.black,
                      child: Text(
                        "Check for teams",
                        style: Styles.whiteBoldDefault
                      ),
                      onPressed: (){
                        if (myUsers == null){
                          final snackBar = SnackBar(
                            content: Text(
                              "There are no teams currently using game ID: ${widget.gameCode}",
                              textAlign: TextAlign.center
                            )
                          );
                          Scaffold.of(scaffoldContext).showSnackBar(snackBar);
                        }
                        else{
                          setState(() {
                          //
                          });
                        }
                      }
                    ),
                  )
                )
              ),
            );
          }
        )
        :
        // Once myUsers have been retreived
        // Display list of myUsers 
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.7,
            child:StreamBuilder(
              stream: Firestore.instance.collection("leaderboard").where("uid", whereIn: myUsers).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print(snapshot.data.documents.length);
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
                        : checked == 10 ? Icon(Icons.check_circle, 
                        color: confirmed < checked ? 
                        Colors.red : Colors.green) 
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
                              TextSpan(
                                text: '$checked/$completed checked\n', 
                                style: TextStyle(
                                  color: confirmed == 10 ? 
                                  Colors.green : Colors.black
                                )
                              ),
                              TextSpan(
                                text: '$confirmed confirmed\n', 
                                style: TextStyle(
                                  color: confirmed == 10 ? 
                                  Colors.green: Colors.black
                                )
                              ),
                              TextSpan(
                                text: '${checked - confirmed} denied', 
                                style: TextStyle(
                                  color: checked - confirmed > 0 ? 
                                  Colors.red : Colors.green
                                )
                              )
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
                            print("Navigating to Admin Specific Team Screen...");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:  (context) => AdminSpecificTeamScreen(
                                  adminUser: widget.adminUser,
                                  gameCode: widget.gameCode,
                                  teamID: document.documentID.substring(0, document.documentID.length - 5), 
                                  completedChallenges: completedChallenges, 
                                  whichChallenge: 0
                                )
                              )
                            );
                          }
                        },
                      );
                    },
                  );
                }
              }
            )
          ),
        ),
      ),
    );
  }
}

Widget AppBarTextSpan(BuildContext context, String gameCode){
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'G', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'ame', 
          style: Styles.orangeNormalDefault
        ),
        TextSpan(
          text: ' I', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'D: ', 
          style: Styles.orangeNormalDefault
        ),
        TextSpan(
          text: '$gameCode', 
          style: Styles.whiteBoldDefault
        ),
      ],
    ),
  );
}