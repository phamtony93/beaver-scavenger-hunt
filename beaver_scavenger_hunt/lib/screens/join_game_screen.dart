// Packages
import 'package:beaver_scavenger_hunt/widgets/control_button.dart';
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
  List<String> allUserIds = [];

  @override
  void initState(){
    super.initState();
    getAllUserIds();
  }

  void getAllUserIds() async {
    var ds = await Firestore.instance.collection("games").getDocuments();
    for (int i = 0; i < ds.documents.length; i++){
      if (ds.documents[i]['open'] == true)
      allUserIds.add(ds.documents[i].documentID);
    }
  }

  bool isGameCodeValid(String gameCode){
    for (int i = 0; i < allUserIds.length; i++){
      if (gameCode == allUserIds[i]){
        return true;
      }
    }
    return false;
  }

  //Validate Game Code Function
  String _validateGameCode(String gameCode) {
    print("Validating game code...");
    //validate whether gamecode is in db
    if (!isGameCodeValid(gameCode)){
      print("Game code invalid");
      return 'That is not a valid game code.\n(Game codes are case-sensitive)';
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
      body: Form(
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
                  // maxLength: 6,
                  //Call _validateGameCode Function (above)
                  validator: (value) => _validateGameCode(value),
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
