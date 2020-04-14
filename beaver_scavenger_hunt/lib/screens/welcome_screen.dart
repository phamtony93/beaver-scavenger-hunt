import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'clue_screen.dart';
import '../models/clue_location_model.dart';
import 'rules_screen.dart';

class WelcomeScreen extends StatelessWidget {
  
  UserDetails userDetails;
  Map<String, dynamic> allClueLocationsMap;
  Map<String, dynamic> allChallengesMap;

  WelcomeScreen({this.userDetails, this.allClueLocationsMap, this.allChallengesMap});

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

                //create clueLocation object(s) from map
                List<ClueLocation> allLocations = [];
                for (int i = 1; i < 11; i++){
                  
                  int myNum = allClueLocationsMap[i.toString()]["number"];
                  double myLat = allClueLocationsMap["${i.toString()}"]["latitude"];
                  double myLong = allClueLocationsMap["${i.toString()}"]["longitude"];
                  String myClue = allClueLocationsMap["${i.toString()}"]["clue"];
                  String mySol = allClueLocationsMap["${i.toString()}"]["solution"];
                  String myURL = null;

                  ClueLocation loca = ClueLocation(myNum, myLat, myLong, myClue, mySol, myURL);
                  loca.available = allClueLocationsMap["${i.toString()}"]["available"];
                  loca.solved = allClueLocationsMap["${i.toString()}"]["solved"];
                  allLocations.add(loca);
                }
                //Go to clue screen, pass allLocations and 0 index as starting location, and user details
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: 0, userDetails: userDetails,)));

              }
            ),
          ]
        )
      )
    );
  }
}
