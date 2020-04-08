import 'package:flutter/material.dart';
import 'rules_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/osu_logo.png')),
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