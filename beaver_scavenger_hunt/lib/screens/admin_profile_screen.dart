// Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Screens
import 'login_screen.dart';
// Functions
import '../functions/calculate_points.dart';
import '../functions/completed_clues_count.dart';
import '../functions/completed_challenges_count.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/timer_text.dart';
import '../widgets/control_button.dart';

class AdminProfileScreen extends StatefulWidget {
  final UserDetails userDetails;
  final String gameCode;

  AdminProfileScreen({Key key, this.userDetails, this.gameCode}) : super(key: key);

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {

  void _signOut(BuildContext context) {
    //close game
    print("Closing game: ${widget.gameCode}");
    Firestore.instance.collection('games').document(widget.gameCode).updateData({'open': false});
    //remove admin from "admins" collection
    print("Removing admin: ${widget.userDetails.uid} from 'admins' collection");
    Firestore.instance.collection('admins').document(widget.userDetails.uid).delete();
    //log-out
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    //navigate back to login screen
    print("Navigating to login screen...");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
              Text("Name : ${widget.userDetails.userName}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Text("Email : ${widget.userDetails.userEmail}", style: TextStyle(fontSize: 24),),
              SizedBox(height: 15.0),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ControlButton(
                    context: context,
                    text: 'Sign Out',
                    onPressFunction: _signOut,)
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