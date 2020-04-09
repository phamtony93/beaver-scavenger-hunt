import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  final UserDetails userDetails;
  ProfileScreen({Key key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
    return Scaffold(
      appBar: AppBar(
        title: Text(userDetails.userName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userDetails.photoUrl),
              radius: 50.0,
            ),
            SizedBox(height: 10.0),
            Text(
              "Name : " + userDetails.userName
            ),
            Text(
              "Email : " + userDetails.userEmail
            ),
            Text(
              "Provider Details: " + userDetails.providerDetails
            ),
          ]
        )
      )
    );
  }
}