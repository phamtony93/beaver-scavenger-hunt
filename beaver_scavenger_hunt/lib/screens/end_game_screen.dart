// Packages
import 'package:flutter/material.dart';
// Screens
import 'profile_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Widgets
import '../widgets/menu_drawer.dart';
// Styles
import '../styles/styles_class.dart';

class EndGameScreen extends StatelessWidget {
  final UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final DateTime beginTime;
  final DateTime endTime;

  EndGameScreen({Key key, this.userDetails, this.allLocations, this.allChallenges, this.whichLocation, this.beginTime, this.endTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'E', 
                  style: Styles.whiteBoldDefault
                ),
                TextSpan(
                  text: 'nd ', 
                  style: Styles.orangeNormalDefault
                ),
                TextSpan(
                  text: 'G', 
                  style: Styles.whiteBoldDefault
                ),
                TextSpan(
                  text: 'ame', 
                  style: Styles.orangeNormalDefault
                ),
              ],
            ),
          ),
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
      body: summary(),
    );
  }

  Widget summary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            SizedBox(height: 25.0),
            Text('Your Final Time and Score', style: Styles.blackNormalDefault, textAlign: TextAlign.center,),
            SizedBox(height: 25.0),
            Text('Finish Time:', style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            getTime(),
            SizedBox(height: 15.0),
            Text('Points:', style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
            points(),
            SizedBox(height: 25.0),
            Text("LEADERBOARD", style: Styles.blackBoldDefault, textAlign: TextAlign.center,),
            Text('add leaderboard here...')
          ],
      )),
    );
  }

  Widget getTime()  {
    Duration difference;
    difference = endTime.difference(beginTime);

    return Text((difference.inHours).toString().padLeft(2, '0') + 
        ':' + (difference.inMinutes%60).toString().padLeft(2, '0') + 
        ':' + (difference.inSeconds%60).toString().padLeft(2, '0'),
        style: TextStyle(fontSize: 24), textAlign: TextAlign.center,);
  }

int completedChallengesCount() {
    int count = 0;
    for (var index = 0; index < allChallenges.length; index++) {
      if (allChallenges[index].completed) {
        count +=1;
      }
    }
    return count;
  }

  int completedCluesCount() {
    int count = 0;
    for (var index = 0; index < allLocations.length; index++) {
      if (allLocations[index].solved) {
        count += 1;
      }
    }
    return count;
  }

  Widget points() {
    int cluePoints = 10;
    int challengePoints = 5;
    int timerDeduction = -1;

    int cluePointsEarned = cluePoints * completedCluesCount();
    int challengePointsEarned = challengePoints * completedChallengesCount();
    int timerPointsDeducted = 2 * timerDeduction;

    return Text((cluePointsEarned + challengePointsEarned + timerPointsDeducted).toString(), textAlign: TextAlign.center,);
  }

}