// Packages
import 'package:flutter/material.dart';
import 'dart:math';
// Screens
import 'admin_teams_list_screen.dart';
// Functions
import '../functions/upload_new_admin.dart';
// Models
import '../models/user_details_model.dart';


class CreateGameScreen extends StatefulWidget {
  final UserDetails user;
  CreateGameScreen({this.user});

  @override
  _CreateGameScreen createState() => _CreateGameScreen();
}

class _CreateGameScreen extends State<CreateGameScreen> {
  String getRandomCode() {
    Random random = Random();
    String validChars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String randomCode = '';
    
    for (var index = 0; index < 4; index++) {
      var randomVal = random.nextInt(validChars.length);
      randomCode = randomCode + validChars[randomVal]; 
    }

    return randomCode;
  }


  @override
  build(BuildContext context) {
    String gameCode = getRandomCode();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text('$gameCode', style: TextStyle(fontSize: 50),),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Start Game', style: TextStyle(fontSize: 20)),
              onPressed: () {
                uploadNewAdmin(widget.user.uid, gameCode);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminTeamsListScreen(adminUser: widget.user, gameID: gameCode,)
                  )
                );
              }
            )
          ]
        ),
      ),
    );
  }
}
