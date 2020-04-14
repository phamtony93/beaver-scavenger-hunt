import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'clue_screen.dart';
import '../models/clue_location_model.dart';
import 'rules_screen.dart';

class WelcomeScreen extends StatelessWidget {
  
  UserDetails userDetails;
  Map<String, dynamic> userStuff;

  WelcomeScreen({this.userDetails, this.userStuff});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${userDetails.userName}!'),  //Replace with 'Welcome' and create profile button
        centerTitle: true,
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
              onPressed: (){
                print('Begin!');

                List<ClueLocation> allLocations = [];
                for (int i = 1; i < 11; i++){
                  print(userStuff["clue locations"][i.toString()]["number"]);
                  int myNum = userStuff["clue locations"][i.toString()]["number"];
                  double myLat = userStuff["clue locations"]["${i.toString()}"]["latitude"];
                  double myLong = userStuff["clue locations"]["${i.toString()}"]["longitude"];
                  String myClue = userStuff["clue locations"]["${i.toString()}"]["clue"];
                  String mySol = userStuff["clue locations"]["${i.toString()}"]["solution"];
                  String myURL = null;

                  ClueLocation loca = ClueLocation(myNum, myLat, myLong, myClue, mySol, myURL);
                  loca.available = userStuff["clue locations"]["${i.toString()}"]["available"];
                  loca.solved = userStuff["clue locations"]["${i.toString()}"]["solved"];
                  allLocations.add(loca);
                }

                
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: 0,)));

              }
            ),
          ]
        )
      )
    );
  }
}
