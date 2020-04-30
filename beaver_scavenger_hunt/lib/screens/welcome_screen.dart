import 'package:flutter/material.dart';
import '../models/user_details_model.dart';
import 'clue_screen.dart';
import '../models/clue_location_model.dart';
import '../models/challenge_model.dart';
import 'rules_screen.dart';
import '../functions/add_begin_time.dart';

class WelcomeScreen extends StatelessWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  DateTime beginTime;

  WelcomeScreen({this.userDetails, this.allLocations, this.allChallenges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${userDetails.userName}!'),  //Replace with 'Welcome' and create profile button
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
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
                child: Text('Start Timer & Begin Hunt'),
                onPressed: (){
                  addBeginTime(beginTime, userDetails);
                  print('Hunt Started!');
                  //Go to clue screen, pass allLocations and 0 index as starting location, and user details
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: 0, allChallenges: allChallenges, userDetails: userDetails,beginTime: beginTime)));

                }
              ),
            ]
          )
        )
      )
    );
  }
}
