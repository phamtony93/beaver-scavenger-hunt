// Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Screens
import 'login_screen.dart';
// Functions
import '../functions/check_game_is_active.dart';
// Models
import '../models/user_details_model.dart';
// Widgets
import '../widgets/control_button.dart';
import '../widgets/open_game_button.dart';
import '../widgets/close_game_button.dart';
// Styles
import '../styles/styles_class.dart';

class AdminProfileScreen extends StatefulWidget {
  final UserDetails userDetails;
  final String gameCode;

  AdminProfileScreen({Key key, this.userDetails, this.gameCode}) : super(key: key);

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {

  void _endGame(BuildContext context) {
    print("Closing game: ${widget.gameCode}");
    Firestore.instance.collection('games').document(widget.gameCode).updateData({'open': false});
    //remove admin from "admins" collection
    print("Removing: ${widget.userDetails.uid} from 'admins' collection");
    Firestore.instance.collection('admins').document(widget.userDetails.uid).delete();
  }

  void _signOut(BuildContext context) {
    // //close game
    // print("Closing game: ${widget.gameCode}");
    // Firestore.instance.collection('games').document(widget.gameCode).updateData({'open': false});
    // //remove admin from "admins" collection
    // print("Removing admin: ${widget.userDetails.uid} from 'admins' collection");
    // Firestore.instance.collection('admins').document(widget.userDetails.uid).delete();
    //log-out
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    //navigate back to login screen
    print("Navigating to login screen...");
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => LoginScreen()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'A', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              TextSpan(text: 'dmin ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
              TextSpan(text: 'P', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              TextSpan(text: 'rofile', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)))
            ]
          )
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userDetails.photoUrl),
                radius: 75.0,
              ),
              SizedBox(height: 25.0),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Name: ', 
                      style: Styles.orangeBoldSmall
                    ),
                    TextSpan(
                      text: '${widget.userDetails.userName}', 
                      style: Styles.blackNormalDefault
                    )
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Email: ', 
                      style: Styles.orangeBoldSmall
                    ),
                    TextSpan(
                      text: '${widget.userDetails.userEmail}', 
                      style: Styles.blackNormalSmall
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StreamBuilder(
                        stream: Firestore.instance.collection("games").snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } 
                          else {
                            List<DocumentSnapshot> allSnapshots = snapshot.data.documents;
                            for (int i = 0; i < allSnapshots.length; i++){
                              if (allSnapshots[i].documentID == widget.gameCode && allSnapshots[i]['open'] == true)
                                return CloseGameButton(context, widget.gameCode, widget.userDetails);
                            }
                            return OpenGameButton(context, widget.gameCode, widget.userDetails);
                          }
                        }
                      ),
                      SizedBox(height: 15,),
                      Builder(
                        builder: (BuildContext cntx){
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
                                    "End Game",
                                    style: Styles.whiteNormalDefault
                                  ),
                                  onPressed: () async {
                                    bool gameIsActive = await checkAdminGameIsActive(widget.userDetails);
                                    if (gameIsActive == false) {
                                      final snackBar = SnackBar(
                                        content: Text('Game has already ended.', textAlign: TextAlign.center,)
                                      );
                                      Scaffold.of(cntx).showSnackBar(snackBar);
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text('Game: ${widget.gameCode} ended.', textAlign: TextAlign.center,)
                                      );
                                      Scaffold.of(cntx).showSnackBar(snackBar);
                                      _endGame(cntx);
                                    }
                                  }
                                ),
                              )
                            )
                          );
                        }
                      ),
                      SizedBox(height: 15,),
                      ControlButton(
                        context: context,
                        text: 'Sign Out',
                        style: Styles.whiteNormalDefault,
                        onPressFunction: _signOut
                      ),
                    ]
                  ) 
                )
              ),
              SizedBox(height: 10.0),
            ]
          )
        )
      )
    );
  }
}
