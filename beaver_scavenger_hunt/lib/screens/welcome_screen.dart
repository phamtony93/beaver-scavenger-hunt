import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'rules_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final UserDetails userDetails;

  WelcomeScreen({this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userDetails.userEmail}'),  //Replace with 'Welcome' and create profile button
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 275,
              width: 275,
              image: AssetImage('assets/images/osu_logo.png'),
              fit: BoxFit.fill,
            ),
            Text('Scavenger', style: TextStyle(fontSize: 60)),
            Text('Hunt', style: TextStyle(fontSize: 60)),
            SizedBox(
               height: 50,
            ),
            RaisedButton(
              child: Text('Hunt Rules'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RulesScreen())
                );
              }
            ),
            RaisedButton(
              child: Text('Begin Hunt'),
              onPressed: () => print('Begin!'),
            ),
          ]
        )
      )
    );
  }
}