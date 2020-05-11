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
  final String gameID;
  
  AdminTeamsListScreen({Key key, this.adminUser, this.gameID}) : super(key: key);
  
  @override
  _AdminTeamsListScreenState createState() => _AdminTeamsListScreenState();
}

class _AdminTeamsListScreenState extends State<AdminTeamsListScreen> with SingleTickerProviderStateMixin{


  List<dynamic> myUsers;
  
  getUsers() async {
    var doc2 = await Firestore.instance.collection("games").document("${widget.gameID}").get();
    myUsers = doc2.data == null ? null : doc2.data["playerIDs"];
    
    for (int i = 0; i < myUsers.length; i++){
      myUsers[i] = myUsers[i] + "_" + widget.gameID;
    }
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
          title: widget.gameID == null ? Text("Game ID: Loading..."): Text('Game ID: ${widget.gameID}'),
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
                      gameCode: widget.gameID,
                    )
                  )
                );
              },
            )
          ],
        ),
        body: myUsers == null ? 
        Builder(
          builder: (BuildContext scaffoldContext) {
            return Column(
              children: <Widget> [
                SizedBox(height:10),
                Center(
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
                                  "There are no teams currently using game ID: ${widget.gameID}",
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
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: StreamBuilder(
                      stream: Firestore.instance.collection("games").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<DocumentSnapshot> allSnapshots = snapshot.data.documents;
                          for (int i = 0; i < allSnapshots.length; i++){
                            if (allSnapshots[i].documentID == widget.gameID && allSnapshots[i]['open'] == true)
                              return CloseGameButton(context, widget.gameID);
                          }
                          return OpenGameButton(context, widget.gameID);
                        }
                      }
                    ),
                  )
                ),
                SizedBox(height: 10)
              ]
            );
          }
        )
        : 
        StreamBuilder(
          stream: Firestore.instance.collection("users").where("uid", whereIn: myUsers).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:  (context) => AdminSpecificTeamScreen(
                              adminUser: widget.adminUser,
                              gameID: widget.gameID,
                              teamID: document["uid"], 
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
      )
    );
  }
}

Widget CloseGameButton(BuildContext context, String gameID){
  return ClipRRect(
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
            "Close Game",
            style: Styles.whiteBoldDefault
          ),
          onPressed: (){
            //mark game as closed
            print("Closing game: $gameID");
            Firestore.instance.collection('games').document(gameID).updateData({'open': false});
          }
        ),
      )
    )
  );
}

Widget OpenGameButton(BuildContext context, String gameID){
  return ClipRRect(
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
            "Open Game",
            style: Styles.whiteBoldDefault
          ),
          onPressed: (){
            //mark game as closed
            print("Opening game: $gameID");
            Firestore.instance.collection('games').document(gameID).updateData({'open': true});
          }
        ),
      )
    )
  );
}