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
        title:  completedChallengesCount() >= 5 ? titleComplete () : titleNotComplete(),
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
      body: completedChallengesCount() >= 5 ? complete () : notComplete()
    );
  }

  Widget titleNotComplete() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'H', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: 'unt ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
          TextSpan(text: 'N', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: 'ot ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
          TextSpan(text: 'C', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: 'omplete', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
        ]
      )
    );
  }

  Widget titleComplete() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'H', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: 'unt ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
          TextSpan(text: 'C', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: 'omplete', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
        ]
      )
    );
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

  Widget complete() {
     return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25.0),
          Text('Congratulations! Your Hunt is Complete!',  style: Styles.titles,),
          SizedBox(height: 25.0),
          Text("Clues Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedCluesCount()} out of 10", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
          Text("Challenges Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedChallengesCount()} out of 5", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Color.fromRGBO(255,117, 26, 1),
              height: 80, width: 300,
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RaisedButton(
                  color: Colors.black,
                  child: Text('View Leaderboard', style: Styles.whiteBoldDefault),
                    onPressed: () {
                      print('go to leaderboard screen');
                    }
                ),
              ),
            ),
          ),

        ],),
    );
  }

  Widget notComplete() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25.0),
          Text('Sorry, Your Hunt is Not Complete!', style: TextStyle(fontSize: 24),),
          Text('You need to complete 5 challenges', style: TextStyle(fontSize: 18),),
          Text('before the hunt is over.', style: TextStyle(fontSize: 18),),
          SizedBox(height: 25.0),
          Text("Clues Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedCluesCount()} out of 10", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
          Text("Challenges Completed:", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          Text("${completedChallengesCount()} out of 5", style: Styles.orangeNormalDefault, textAlign: TextAlign.center,),
          SizedBox(height: 15.0),
        ],),
    );
  }
}