// Packages
import 'package:beaver_scavenger_hunt/functions/delete_user_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Screens
import 'profile_screen.dart';
import 'end_game_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Widgets
import '../widgets/menu_drawer.dart';
// Functions
import '../functions/add_user_leaderboard.dart';
import '../functions/calculate_points.dart';
import '../functions/completed_challenges_count.dart';
import '../functions/completed_clues_count.dart';
import '../functions/delete_user_document.dart';
import '../functions/get_final_time.dart';
// Styles
import '../styles/styles_class.dart';

class HuntCompleteScreen extends StatelessWidget {
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final DateTime beginTime;

  HuntCompleteScreen({Key key, this.userDetails, this.allLocations, this.allChallenges, this.whichLocation, this.beginTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  completedChallengesCount(allChallenges) >= 5 ? titleComplete () : titleNotComplete(),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Menu",
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              
              //get # of incorrect clues from db 
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
        ],
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          print("begin time: ");
          print (beginTime);
          print (userDetails);
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
      body: completedChallengesCount(allChallenges) >= 5 ? complete (context) : notComplete(context)
    );
  }

  Widget titleNotComplete() {
    print(beginTime);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'H', style: Styles.whiteBoldDefault),
          TextSpan(text: 'unt ', style: Styles.orangeNormalDefault),
          TextSpan(text: 'N', style: Styles.whiteBoldDefault),
          TextSpan(text: 'ot ', style: Styles.orangeNormalDefault),
          TextSpan(text: 'C', style: Styles.whiteBoldDefault),
          TextSpan(text: 'omplete', style: Styles.orangeNormalDefault),
        ]
      )
    );
  }

  Widget titleComplete() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'H', style: Styles.whiteBoldDefault),
          TextSpan(text: 'unt ', style: Styles.orangeNormalDefault),
          TextSpan(text: 'C', style: Styles.whiteBoldDefault),
          TextSpan(text: 'omplete', style: Styles.orangeNormalDefault),
        ]
      )
    );
  }

  // if user completed a minimum of 5 challenges, they can end the game
  Widget complete(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            Text('Congratulations!\nYour Hunt is Complete!', style: Styles.titles, textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            completedChallengesCount(allChallenges) < 10 ? Text('You can complete all 10 challenges to earn more points. Or click End Game to finish now.', textAlign: TextAlign.center,) :
              Text('You have finished all clues and challenges. Click on End Game now.', textAlign: TextAlign.center,),
            SizedBox(height: 25.0),
            Text("Clues Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            Text("${completedCluesCount(allLocations)} out of 10", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            SizedBox(height: 15.0),
            Text("Challenges Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            Text("${completedChallengesCount(allChallenges)} out of 5", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            SizedBox(height: 15.0),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Styles.osuOrange,
                height: 80, width: 300,
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text('End Game', style: Styles.whiteBoldDefault),
                      onPressed: () async{
                        print('End Game');
                        //final endTime = addEndTime(userDetails);
                        final endTime = DateTime.now();
                        final finalTime = getFinalTime(beginTime, endTime);  // calculate final time
                        final finalPts = await getTotalPoints(endTime);  // calculate points
                        await addUserLeaderboard(userDetails, finalTime, finalPts, allChallenges);
                        await deleteUserDocument(userDetails);
                        // copy all challenge data, points, and time to leaderboard
                        Navigator.pop(context);
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => 
                            EndGameScreen(
                              allChallenges: allChallenges,
                              allLocations: allLocations, 
                              userDetails: userDetails,
                              whichLocation: whichLocation,
                              beginTime: beginTime,
                              totalPoints: finalPts,
                              time: finalTime
                            )
                          )
                        );
                        
                      }
                  ),
                ),
              ),
            ),

          ],),
    ),
     );
  }

  // if user hasn't completed a minimum of 5 challenges, they cannot end the game
  Widget notComplete(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25.0),
          Text('Sorry, Your Hunt is Not Complete!', style: TextStyle(fontSize: 24),),
          Text('You need to complete 5 challenges', style: TextStyle(fontSize: 18),),
          Text('before the hunt is over.', style: TextStyle(fontSize: 18),),
          SizedBox(height: 25.0),
          Text("Clues Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedCluesCount(allLocations)} out of 10", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
          Text("Challenges Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedChallengesCount(allChallenges)} out of 5", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
        ],),
    );
  }
  

  Future<int> getTotalPoints(DateTime endTime) async {
    print("Calculating total points...");
    Duration difference;
    difference = endTime.difference(beginTime);
    var ds = await Firestore.instance.collection("users").document("${userDetails.uid}").get();
    int incorrectClues = ds.data['incorrectClues'];
    int pointsNotFromTime = calculatePoints(allLocations, allChallenges, incorrectClues);
    print("calculating time points lost...");
    print("Points lost from ${difference.inMinutes} minutes: ${difference.inMinutes}");  
    int totalPoints = pointsNotFromTime - difference.inMinutes;
    print("total points: $totalPoints");

    return totalPoints;
  }

}