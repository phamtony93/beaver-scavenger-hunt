// Packages
import 'package:flutter/material.dart';
import 'dart:math';
// Screens
import 'admin_teams_list_screen.dart';
// Functions
import '../functions/upload_new_admin.dart';
// Models
import '../models/user_details_model.dart';
// Styles
import '../styles/styles_class.dart';


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
        title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'C', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'reate ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
                TextSpan(text: 'G', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'ame', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)))
              ]
            )
          ),
        centerTitle: true,
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
                      "Open Game",
                      style: Styles.whiteBoldDefault
                    ),
                    onPressed: (){
                      uploadNewAdmin(widget.user, gameCode);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminTeamsListScreen(adminUser: widget.user, gameID: gameCode,)
                        )
                      );
                    }
                  ),
                )
              )
            )
          ]
        ),
      ),
    );
  }
}
