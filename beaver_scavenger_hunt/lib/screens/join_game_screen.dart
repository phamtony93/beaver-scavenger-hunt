// Packages
import 'package:flutter/material.dart';
// Screens
import 'welcome_screen.dart';
// Models
import '../models/user_details_model.dart';

class JoinGameScreen extends StatefulWidget {
  final UserDetails userDetails;

  //gets user details from Login Screen
  JoinGameScreen({this.userDetails});

  @override
  _JoinGameScreen createState() => _JoinGameScreen();
}

class _JoinGameScreen extends State<JoinGameScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey();
  String gameCode;

  //Validate Game Code Function
  String _validateGameCode(String gameCode) {
    print("Validating game code...");
    //validate whether gamecode is in db
    if (gameCode.isEmpty) {
      return 'Please enter your 4 digit code';
    }
    if (gameCode.length != 4) {
      return 'Please enter your 4 digit code';
    }
    return null;
  }

  //Submit GameCode Form Function
  void _submitForm(formKey)  async {
    if (formKey.currentState.validate()) {
      //save currentState
      formKey.currentState.save();
      //Navigate to Welcome screen (with user details and game code)
      
      print("Game Code validated");
      print("Navigating to Welcome Screen...");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(
            userDetails: widget.userDetails, 
            gameCode: gameCode
          )
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
                  //Call _validateGameCode Function (above)
                  validator: (value) => _validateGameCode(value),
                  onSaved: (value) {
                    gameCode = value;
                  },
                ),
              ),
            ),
            RaisedButton(
              child: Text('Join'),
              //Call submitForm Function (above)
              onPressed: () => _submitForm(_formKey)
            )
          ]
        )
      )
    );
  }
}
