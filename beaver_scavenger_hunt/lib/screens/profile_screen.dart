// Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Screens
import 'login_screen.dart';
// Functions
import '../functions/completed_clues_count.dart';
import '../functions/completed_challenges_count.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/timer_text.dart';
import '../widgets/control_button.dart';
import '../widgets/points_text.dart';
// Styles
import '../styles/styles_class.dart';

class ProfileScreen extends StatefulWidget {
  final UserDetails userDetails;
  final List<Challenge> allChallenges;
  final List<ClueLocation> allLocations;
  final DateTime beginTime;
  final int points;

  ProfileScreen({
    Key key, 
    this.userDetails, 
    this.allChallenges, 
    this.allLocations, 
    this.beginTime, 
    this.points
  }) : super(key: key);

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
  }

  void stopStopWatch() {
    setState((){
      stopWatch.stop();
    });
  }

  // Function for signing user out of account
  void _signOut(BuildContext context) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<bool> _onBackPress() {
    setState( () {
      onScreen = false;
      stopStopWatch();
    });
    //Navigator.pop(context);
    return Future<bool>.value(true);
  }

  //get difference between current time and begin time
  Duration getTime()  {
    DateTime formattedBeginTime;
    Duration difference;
    final currTime = DateTime.now();
    if (widget.beginTime is! DateTime) {
      formattedBeginTime = DateTime.parse(widget.beginTime.toString());
      difference = currTime.difference(formattedBeginTime);
    }
    else {
      difference = currTime.difference(widget.beginTime);
    }
    return difference;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPress(),
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTextSpan(context),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .05
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userDetails.photoUrl),
                  radius: 75.0,
                ),
                SizedBox(height: 25.0),
                widget.userDetails != null ? 
                Text("Name : ${widget.userDetails.userName}", style: TextStyle(fontSize: 24),)
                : Text("User load error"),
                SizedBox(height: 15.0),
                widget.allLocations != null ? 
                Text("Email : ${widget.userDetails.userEmail}", style: TextStyle(fontSize: 24),)
                : Text("User load error"),
                SizedBox(height: 15.0),
                widget.allLocations != null ? 
                Text("Clues Completed: ${completedCluesCount(widget.allLocations)}", style: TextStyle(fontSize: 24),)
                : Text("Clue load error"),
                SizedBox(height: 15.0),
                widget.allChallenges != null ? 
                Text("Challenges Completed: ${completedChallengesCount(widget.allChallenges)}", style: TextStyle(fontSize: 24),)
                : Text("Challenge load error"),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Time Elapsed: ", style: TextStyle(fontSize: 24),),
                    
                    widget.beginTime != null && widget.points != null ? 
                    TimerText(stopWatch: stopWatch, onScreen: onScreen, difference: getTime())
                    : Text("Loading..."),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Total Points: ", style: TextStyle(fontSize: 24),),
                    
                    widget.beginTime != null && widget.points != null ? PointsText(points: widget.points, stopWatch: stopWatch, onScreen: onScreen, difference: getTime())
                    : Text("Loading..."),
                  ],
                ),
                SizedBox(height: 25.0),
                ControlButton(
                  context: context,
                  text: 'Sign-Out',
                  style: Styles.whiteNormalDefault,
                  onPressFunction: _signOut,)
              ]
            )
          )
        )
      ),
    );
  }
}
 // Test span for app bar
Widget AppBarTextSpan(BuildContext context){
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: 'P', style: Styles.whiteBoldDefault),
        TextSpan(text: 'layer', style: Styles.orangeNormalDefault),
        TextSpan(text: ' P', style: Styles.whiteBoldDefault),
        TextSpan(text: 'rofile', style: Styles.orangeNormalDefault)
      ]
    )
  );
}