// Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Screens
import 'login_screen.dart';
// Functions
import '../functions/calculate_points.dart';
import '../functions/completed_clues_count.dart';
import '../functions/completed_challenges_count.dart';
// Models
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
import '../models/clue_location_model.dart';
// Widgets
import '../widgets/timer_text.dart';
import '../widgets/control_button.dart';
// Styles
import '../styles/styles_class.dart';

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

  void _signOut(BuildContext context) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                Text("Clues Completed: ${completedCluesCount(widget.allLocations)}", style: TextStyle(fontSize: 24),),
                SizedBox(height: 15.0),
                Text("Challenges Completed: ${completedChallengesCount(widget.allChallenges)}", style: TextStyle(fontSize: 24),),
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
                Text("Preliminary Points Earned: ${calculatePoints(widget.allLocations, widget.allChallenges)}", style: TextStyle(fontSize: 24),),
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