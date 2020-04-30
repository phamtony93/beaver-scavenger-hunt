import 'package:beaver_scavenger_hunt/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
import '../widgets/timer_text.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final UserDetails userDetails;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  final beginTime;

  ProfileScreen({Key key, this.userDetails, this.allChallenges, this.allLocations, this.beginTime}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool onScreen = true;
  var stopWatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    startStopWatch();
  }

  void startStopWatch() {
    setState((){
      stopWatch.start();
    });
    //startTimer();
  }

  void stopStopWatch() {
    setState((){
      stopWatch.stop();
    });
  }

  int completedChallengesCount() {
    int count = 0;
    for (var index = 0; index < widget.allChallenges.length; index++) {
      if (widget.allChallenges[index].solved) {
        count +=1;
      }
    }
    return count;
  }

  int completedCluesCount() {
    int count = 0;
    for (var index = 0; index < widget.allLocations.length; index++) {
      if (widget.allLocations[index].solved) {
        count += 1;
      }
    }
    return count;
  }

  void _signOut(BuildContext context) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  int getPrelimPoints() {
    int cluePoints = 10;
    int challengePoints = 5;
    int timerDeduction = -1;

    int cluePointsEarned = cluePoints * completedCluesCount();
    int challengePointsEarned = challengePoints * completedChallengesCount();
    int timerPointsDeducted = 2 * timerDeduction;

    return (cluePointsEarned + challengePointsEarned + timerPointsDeducted);
  }

  @override
  Widget build(BuildContext context) {
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
    return WillPopScope(
      onWillPop: () => _onBackPress(),
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'P', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(text: 'rofile', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)))
              ]
            )
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userDetails.photoUrl),
                  radius: 75.0,
                ),
                SizedBox(height: 25.0),
                Text("Name : ${widget.userDetails.userName}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Text("Email : ${widget.userDetails.userEmail}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Text("Clues Completed: ${completedChallengesCount()}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Text("Challenges Completed: ${completedCluesCount()}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Time Elapsed: ", style: TextStyle(fontSize: 24),),
                    TimerText(stopWatch: stopWatch, onScreen: onScreen, difference: getTime()),
                  ],
                ),
                //Text("Current Time: xx", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Text("Prelimnary Points Eearned: ${getPrelimPoints()}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 25.0),
                RaisedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    _signOut(context);
                  },
                )
              ]
            )
          )
        )
      ),
    );
  }

  Future<bool> _onBackPress() {
    setState( () {
      onScreen = false;
      stopStopWatch();
    });
    //Navigator.pop(context);
    return Future<bool>.value(true);
  }

  Duration getTime()  {
    DateTime formattedBeginTime;
    Duration difference;
    final currTime = DateTime.now();
    print(currTime);
    print(widget.beginTime);
    if (widget.beginTime is! DateTime) {
      formattedBeginTime = DateTime.parse(widget.beginTime.toDate().toString());
      print(formattedBeginTime);
      difference = currTime.difference(formattedBeginTime);
    }
    else {
      difference = currTime.difference(widget.beginTime);
    }
    print(difference);
    print(difference.inHours);
    print(difference.inMinutes%60);
    print(difference.inSeconds.remainder(60));
    return difference;
  }

}