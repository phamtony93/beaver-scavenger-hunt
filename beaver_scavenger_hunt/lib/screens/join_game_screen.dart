// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'welcome_screen.dart';
// Models
import '../models/user_details_model.dart';
// Styles
import '../styles/styles_class.dart';

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
  String _validateGameCode(String gameCode, List<String> possibleGameCodes) {
    print("Validating game code...");
    //validate whether gamecode is in db
    bool isValid = false; 
    for (int i = 0; i < possibleGameCodes.length; i++){
      if (gameCode == possibleGameCodes[i]){
        isValid = true;
      }
    }
    if (isValid == false){
      print("Game code invalid");
      return 'That is not a valid game code.\n(Reminder: Game codes are case-sensitive)';
    }
    if (gameCode.isEmpty) {
      print("Game code invalid");
      return 'Please enter your 4 digit code';
    }
    if (gameCode.length != 4) {
      print("Game code invalid");
      return 'Please enter your 4 digit code';
    }
    print("Game code validated");
    return null;
  }

  //Submit GameCode Form Function
  void _submitForm(formKey)  async {
    if (formKey.currentState.validate()) {
      //save currentState
      formKey.currentState.save();
      
      //Navigate to Welcome screen (with user details and game code)
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
        title: AppBarTextSpan(context),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("games").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<DocumentSnapshot> allSnapshots = snapshot.data.documents;
              List<String> allGameCodes = [];
              for (int i = 0; i < allSnapshots.length; i++){
                if (allSnapshots[i]['open'] == true){
                  allGameCodes.add(allSnapshots[i].documentID);
                }
              }
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .10,
                    ),
                    Text(
                      "Game Code",
                      style: Styles.blackBoldDefault,
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
                          //Call _validateGameCode Function (above)
                          validator: (value) => _validateGameCode(value, allGameCodes),
                          onSaved: (value) {
                            gameCode = value;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
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
                                  "Join",
                                  style: Styles.whiteBoldDefault
                                ),
                                onPressed: (){
                                  _submitForm(_formKey);
                                }
                              ),
                            )
                          )
                        )
                      )
                    ),
                    SizedBox(height: 10)
                  ]
                )
              );
            }
          }
        )
    );
  }
}

Widget AppBarTextSpan(BuildContext context){
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'J', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'oin ', 
          style: Styles.orangeNormalDefault
        ),
        TextSpan(
          text: 'G', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'ame', 
          style: Styles.orangeNormalDefault
        ),
      ],
    ),
  );
}
