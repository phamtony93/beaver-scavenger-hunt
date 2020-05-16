// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'profile_screen.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/menu_drawer.dart';
// Functions
import '../functions/calculate_points.dart';
// Styles
import '../styles/styles_class.dart';

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
            onPressed: () async {
              
              var ds = await Firestore.instance.collection("users").document("${userDetails.uid}").get();
              int incorrectClues = ds.data['incorrectClues'];
              int points = calculatePoints(allLocations, allChallenges, incorrectClues);
              
              print("Navigating to Profile Screen...");
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => 
                  ProfileScreen(
                  userDetails: userDetails, 
                  allChallenges: allChallenges, 
                  allLocations: allLocations,
                  beginTime: beginTime,
                  points: points,
                  )
                )
              );
            }
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
            ListTileWidget(context, '1.  This is a timed hunt - your time begins as soon as you hit the "Start Time & Begin Hunt" button.', Styles.whiteNormalSmall),
            ListTileWidget(context, '2.  There are 10 scavenger hunt clues that need to be answered to complete the hunt - each worth 10 points.', Styles.orangeNormalSmall),
            ListTileWidget(context, '3.  Each correct answer will unlock a new GPS location, which will lead you to your next clue.', Styles.whiteNormalSmall),
            ListTileWidget(context, '4.  In order to receive the next clue, you will need to get within 50 feet of the GPS location.', Styles.orangeNormalSmall),
            ListTileWidget(context, '5.  For each incorrect guess of a clue location, you will lose 5 points - so answer carefully!', Styles.whiteNormalSmall),
            ListTileWidget(context, '6.  Along with the clues, there are 10 challenges to complete - each worth 5 points. You must complete at least 5 challenges to finish the hunt.', Styles.orangeNormalSmall),
            ListTileWidget(context, '7.  You will be able to complete the hunt and stop the timer after your 10th clue is reached, and at least 5 challenges are completed.', Styles.whiteNormalSmall),
            ListTileWidget(context, '8.  Keep track of the time! You will lose 1 point for every minute you take to complete the hunt.', Styles.orangeNormalSmall),
            ListTileWidget(context, '9.  Every team that finishes will win a prize, but the team with the most points will win the grand prize!', Styles.whiteNormalSmall),
            ListTileWidget(context, '10.  You may view rules or previously answered clues at any time.', Styles.orangeNormalSmall),
            ListTileWidget(context, '11.  Good luck and have fun. And GO BEAVS!!', Styles.whiteNormalSmall)
          ]
        )
      )
    );
  }
}

ListTileWidget(BuildContext context, String text, TextStyle style){
  return ListTile(
    title: Card(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          text,
          style: style
        ),
      ),
    ),
  );
}
