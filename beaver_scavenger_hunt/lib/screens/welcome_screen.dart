// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'clue_screen.dart';
import 'rules_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/challenge_model.dart';
import '../models/user_details_model.dart';
// Functions
import '../functions/add_begin_time.dart';
import '../functions/get_prev_user.dart';
import '../functions/upload_new_user_and_challenges.dart';
// Styles
import '../styles/styles_class.dart';


class WelcomeScreen extends StatelessWidget {
  
  UserDetails userDetails;
  final String gameCode;
  DateTime beginTime;
   
  //Gets user details and game code from join game screen
  WelcomeScreen({this.userDetails, this.gameCode});

  //adds user's uid to "games" collection in db
  void addPlayerToGame(String gameID) async {
    Firestore.instance.collection('games').document("$gameCode").updateData({'playerIDs': FieldValue.arrayUnion([userDetails.userEmail])});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${userDetails.userName}!'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: 275,
                width: 275,
                image: AssetImage('assets/images/osu_logo.png'),
                fit: BoxFit.fill,
              ),
              Text('Scavenger', style: TextStyle(fontSize: 50)),
              Text('Hunt', style: TextStyle(fontSize: 50)),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: <Widget> [
                      ClipRRect(
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
                              'Hunt Rules',
                              style: Styles.whiteBoldSmall
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RulesScreen())
                              );
                            }
                          ),
                        )
                      )
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
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
                              'Start Timer & Begin Hunt',
                              style: Styles.whiteBoldSmall
                            ),
                            onPressed: () async {
                              
                              //MAKE NEW USER
                              Map<String, dynamic> newUser;
                              print("Adding new user to db...");
                              
                              // ADD NEW USER INFO TO DB 
                              //(clues & challenges from JSON, uid, emailAddress)
                              uploadNewUserAndChallenges(userDetails, gameCode);

                              //retrieve user info from db
                              
                              //newUser = await get_prev_user(userDetails.uid);
                              newUser = await get_prev_user(userDetails.userEmail);

                              //get clue locations and challenges from db
                              Map<String, dynamic> allClueLocationsMap = newUser['clue locations'];
                              Map<String, dynamic> allChallengesMap = newUser['challenges'];

                              //create clueLocation object(s) from json map
                              List<ClueLocation> allLocations = [];
                              for (int i = 1; i < 11; i++){
                                ClueLocation loca = ClueLocation.fromJson(allClueLocationsMap["$i"]);
                                allLocations.add(loca);
                              }
                              
                              //create challenge object(s) from json map
                              List<Challenge> allChallenges = [];
                              for (int i = 1; i < 11; i++){
                                Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
                                allChallenges.add(chall);
                              }
                              
                              //add player's gameCode to "games" collection in db (above)
                              print("Adding new player uid to 'games' collection in db...");
                              addPlayerToGame(gameCode);
                              
                              // add timestamp (now) to database, and store it
                              // here as beginTime
                              print("Adding beginTime to player's data in db...");
                              beginTime = addBeginTime(userDetails);
                              
                              print('Hunt and Timer Started!');
                              print("Navigating to Clue Screen...");
                              
                              //Go to clue screen
                              // (pass allLocations and 0 index as starting location,
                              // and user details)
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => ClueScreen(
                                    allLocations: allLocations, 
                                    whichLocation: 0, 
                                    allChallenges: allChallenges, 
                                    userDetails: userDetails, 
                                    beginTime: beginTime
                                  )
                                )
                              );
                            }
                          ),
                        )
                      )
                    ),
                  ]
                ),
              )
            ),
          ]
        )
      )
    );
  }
}
