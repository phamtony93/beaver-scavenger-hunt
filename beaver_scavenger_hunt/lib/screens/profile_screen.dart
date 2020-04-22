import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import '../models/clue_location_model.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  final UserDetails userDetails;
  int whichLocation;

  ProfileScreen({Key key, this.userDetails, this.whichLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
    return Scaffold(
      appBar: AppBar(
        title: Text(userDetails.userName),
      ),
      body: 
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userDetails.photoUrl),
                radius: 75.0,
              ),
              SizedBox(height: 20.0),
              Text(
                "Name : ${userDetails.userName}"
              ),
              Text(
                "Email : ${userDetails.userEmail}"
              ),
              Text(
                "Clues Solved: ${whichLocation + 1}"
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text('Sign Out'),
                onPressed: () => print('hello'),
              )
            ]
          )
        )
      )
    );
  }
}