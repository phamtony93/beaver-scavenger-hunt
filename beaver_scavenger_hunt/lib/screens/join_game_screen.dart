import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beaver_scavenger_hunt/models/clue_location_model.dart';
import 'package:beaver_scavenger_hunt/models/challenge_model.dart';
import 'package:beaver_scavenger_hunt/screens/welcome_screen.dart';
import '../models/user_details_model.dart';
import '../widgets/control_button.dart';

class JoinGameScreen extends StatefulWidget {
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;

  JoinGameScreen({this.userDetails, this.allLocations, this.allChallenges});

  @override
  _JoinGameScreen createState() => _JoinGameScreen();
}

class _JoinGameScreen extends State<JoinGameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String gameCode;

  void addPlayerToGame(String playerID, String gameID) async {
    Firestore.instance.collection("users").document("$playerID").updateData({'gameID': '$gameCode'});
    Firestore.instance.collection('games').document("$gameID").updateData({'playerIDs': FieldValue.arrayUnion([playerID])});
  }

  String _validateGameCode(String gameCode) {
    //validate whether gamecode is in db
    if (gameCode.isEmpty) {
      return 'Please enter your 4 digit code';
    }
    if (gameCode.length != 4) {
      return 'Please enter your 4 digit code';
    }
    return null;
  }

  void submitForm(formKey) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      addPlayerToGame(widget.userDetails.uid, gameCode);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(userDetails: widget.userDetails, allLocations: widget.allLocations, allChallenges: widget.allChallenges)
        )
      );
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Game'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .10,
            ),
            Center(
              child: Container(
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Input code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)), 
                    ),
                  ),
                  // maxLength: 6,
                  validator: (value) => _validateGameCode(value),
                  onSaved: (value) {
                    gameCode = value;
                  },
                ),
              ),
            ),
            RaisedButton(
              child: Text('Join'),
              onPressed: () => submitForm(_formKey)
            )
          ]
        )
      )
    );
  }
}
