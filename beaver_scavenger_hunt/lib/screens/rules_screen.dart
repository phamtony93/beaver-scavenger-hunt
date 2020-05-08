// Packages
import 'package:flutter/material.dart';
// Screens
import 'profile_screen.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/menu_drawer.dart';

class RulesScreen extends StatelessWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final beginTime;
  
  RulesScreen({
    Key key, 
    this.allLocations, 
    this.allChallenges, 
    this.whichLocation, 
    this.userDetails, 
    this.beginTime
  }) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'R', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              TextSpan(text: 'ules', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),

            ],
          ),
        ),
        centerTitle: true,
        leading: allChallenges != null ? Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Menu",
            );
          },
        )
        :IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          allChallenges != null ? IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => 
                ProfileScreen(
                userDetails: userDetails, 
                allChallenges: allChallenges, 
                allLocations: allLocations,
                beginTime: beginTime,
                )
              )
            ),
          )
          :Container()
        ],
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          return MenuDrawer(
            context, 
            allLocations, 
            whichLocation, 
            allChallenges, 
            userDetails,
            beginTime
          );
        }
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text('1. This is a timed hunt - your time begins as soon as you hit the "Begin Hunt" button.'),
            ),
            ListTile(
              title: Text('2. There are 10 scavenger hunt clues and answers.'),
            ),
            ListTile(
              title: Text('3. Each correct answer will lead you to a GPS location.'),
            ),
            ListTile(
              title: Text('4. In order to receive the next clue, you will need to be within x units of each GPS location.'),
            ),
            ListTile(
              title: Text('5. Along with clues, there are some tasks/challenges to complete.'),
            ),
            ListTile(
              title: Text('6. After 1 incorrect guess to a clue, 5 minutes will be added to your time for each subsequent incorrect guess - so answer carefully!'),
            ),
            ListTile(
              title: Text('7. Your time ends as soon as you correctly answer the final question.'),
            ),
            ListTile(
              title: Text('8. Every team that finishes will win a prize, and the team with the shortest time will win the grand prize.'),
            ),
            ListTile(
              title: Text('9. You may view rules or previous answered clues at any time.'),
            ),
            ListTile(
              title: Text('10. Good luck and have fun!'),
            ),            
          ]
        )
      )
    );
  }
}