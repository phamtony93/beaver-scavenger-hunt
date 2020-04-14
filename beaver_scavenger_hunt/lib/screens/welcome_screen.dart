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

                //create clueLocation object(s) from json map
                List<ClueLocation> allLocations = [];
                for (int i = 1; i < 11; i++){
                  ClueLocation loca = ClueLocation.fromJson(allClueLocationsMap["$i"]);
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
