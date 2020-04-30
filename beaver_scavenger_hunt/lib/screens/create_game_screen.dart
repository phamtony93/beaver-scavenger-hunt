import 'dart:math';
import 'package:flutter/material.dart';


class CreateGameScreen extends StatefulWidget {
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
                child: Text('${getRandomCode()}', style: TextStyle(fontSize: 50),),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Start Game', style: TextStyle(fontSize: 20)),
              onPressed: () => print('start game'),
            )
          ]
        ),
      ),
    );
  }
}