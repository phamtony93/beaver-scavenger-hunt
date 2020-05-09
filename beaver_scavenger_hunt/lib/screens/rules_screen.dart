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
              title: Text('1. This is a timed hunt - your time begins as soon as you hit the "Start Time & Begin Hunt" button.'),
            ),
            ListTile(
              title: Text('2. There are 10 scavenger clues that need to be answered to complete the hunt, each worth 10 points.'),
            ),
            ListTile(
              title: Text('3. Each correct answer will unlock a new GPS location which will lead you to your next clue.'),
            ),
            ListTile(
              title: Text('4. In order to receive the next clue, you will need to be within 50 feet of the GPS location.'),
            ),
            ListTile(
              title: Text('5. For each incorrect guess to answering the clues, you will lose 5 points - so answer carefully!'),
            ),            
            ListTile(
              title: Text('6. Along with the clues, there are 10 challenges to complete each worth 5 points. You must complete at least 5 challenges to complete the hunt.'),
            ),
            ListTile(
              title: Text('7. You will be able to complete the game and stop the timer after your 10th clue is answered and have at least 5 challenges completed.'),
            ),
            ListTile(
              title: Text('8. Every team that finishes will win a prize, and the team with the most points will win a grand prize!'),
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