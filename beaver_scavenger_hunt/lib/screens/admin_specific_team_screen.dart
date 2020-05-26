// Packages
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// Screens
import 'admin_teams_list_screen.dart';
// Models
import '../models/challenge_model.dart';
// Styles
import '../styles/styles_class.dart';

class AdminSpecificTeamScreen extends StatefulWidget {

  final UserDetails adminUser;
  final String gameCode;
  final String teamID;
  final List<Challenge> completedChallenges;
  final int whichChallenge;

  AdminSpecificTeamScreen({
    Key key, 
    this.adminUser,
    this.gameCode,
    this.teamID, 
    this.completedChallenges, 
    this.whichChallenge
  }) : super(key: key);

  @override
  _AdminSpecificTeamScreenState createState() => _AdminSpecificTeamScreenState();
}

class _AdminSpecificTeamScreenState extends State<AdminSpecificTeamScreen> with SingleTickerProviderStateMixin{
  
  bool isAccepted;
  bool isRejected;
  double transAmount;
  double rotateAmount;

  VideoPlayerController _videoController;
  Future<void> _initializeVideoPlayerFuture;
  bool isImage = true;
  
  @override
  void initState() {
    super.initState();
    String imgORmp4 = widget.completedChallenges[widget.whichChallenge].photoUrl.substring(widget.completedChallenges[widget.whichChallenge].photoUrl.length - 3, widget.completedChallenges[widget.whichChallenge].photoUrl.length);
    if (imgORmp4 == ".mp4"){
      isImage = false;
      _videoController = VideoPlayerController.file(File(widget.completedChallenges[widget.whichChallenge].photoUrl));
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true);
    }

    transAmount = 0.0;
    rotateAmount = 0.0;
    isAccepted = false;
    isRejected = false;
  }

  void setMyState(bool isRejectedOrAccepted){
    setState(() {
      isRejectedOrAccepted = true;
    });
  }

  void setMyTransState(double tAmount, double rAmount){
    setState(() {
      transAmount = tAmount;
      rotateAmount = rAmount;
    });
  }

  Widget VideoRow(BuildContext context){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(_videoController.value.isPlaying ? 'PAUSE' : 'PLAY'),
      IconButton(icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_circle_filled),
        hoverColor: Colors.green,
        highlightColor: Colors.grey,
        color: Styles.osuOrange,
        iconSize: 30.0,
        tooltip: 'Play/Stop Video',
        onPressed: () {
          setState (() {
            if(_videoController.value.isPlaying) {
              _videoController.pause();
            }
            else {
              _videoController.play();
            }
          });
        }
      ),
    ],
  );
}

  @override
  Widget build (BuildContext context) {
    var screen_height = MediaQuery.of(context).size.height;
    var screen_width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(
                adminUser: widget.adminUser, 
                gameCode: widget.gameCode
              )
            )
          );
          return Future<bool>.value(false);
        },
        child: Scaffold(
        appBar: AppBar(
            title: AppBarTextSpan(context, widget.adminUser),
            centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget> [
              SizedBox(height: screen_height*0.025),
              PhotoDescription(context, widget.completedChallenges[widget.whichChallenge].description),
              SizedBox(height:screen_height*0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  RejectionBar(context, isRejected, widget.completedChallenges, widget.whichChallenge, widget.teamID, setMyState, widget.adminUser, widget.gameCode, screen_height, screen_width),
                  isImage == true ? PhotoSwiperContainer(context, isAccepted, isRejected, transAmount, rotateAmount, widget.whichChallenge, widget.completedChallenges, screen_height, screen_width)
                  : Column(
                    children: <Widget> [
                      VideoSwiperContainer(context, isAccepted, isRejected, transAmount, rotateAmount, widget.whichChallenge, widget.completedChallenges, screen_height, screen_width, _initializeVideoPlayerFuture, _videoController),
                      VideoRow(context)
                    ]
                  ),
                  AcceptanceBar(context, isAccepted, widget.completedChallenges, widget.whichChallenge, widget.teamID, setMyState, widget.adminUser, widget.gameCode, screen_height, screen_width)
                ],
              ), 
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RejectButton(context, widget.whichChallenge, widget.completedChallenges, widget.teamID, setMyTransState, widget.adminUser, widget.gameCode),
                      SizedBox(width: 100),
                      AcceptButton(context, widget.whichChallenge, widget.completedChallenges, widget.teamID, setMyTransState, widget.adminUser, widget.gameCode)
                    ],
                  )
                )
              ),
              SizedBox(height: screen_height*0.01)
            ]
          )
        )
      )
    );
  }
}

Widget PhotoDescription(BuildContext context, String description){
  return Padding(
    padding: EdgeInsets.all(5),
    child: Text(
      "$description",
      style: TextStyle(fontSize: 25),
      textAlign: TextAlign.center,
      ),
  );
}

Widget PhotoSwiperContainer(
  BuildContext context, 
  bool isAccepted, 
  bool isRejected, 
  double transAmount, 
  double rotateAmount, 
  whichChallenge, 
  completedChallenges,
  screen_height, screen_width
){
  print("Checking challenge #${completedChallenges[whichChallenge].number}...");
  return AnimatedContainer(
    duration: Duration(seconds: 1),
    curve: Curves.elasticOut,
    transform: Matrix4.skewY(0)..rotateZ(rotateAmount)..translate(transAmount),
    child: isAccepted == false && isRejected == false ?
    Draggable(
      data: "${completedChallenges[whichChallenge].photoUrl}",
      feedback: SizedBox(
        height: screen_height*0.5, width: screen_width*0.7,
        child: Container(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                completedChallenges[whichChallenge].photoUrl
              ),
            )
          )
        )
      ),
      childWhenDragging: Container(width: screen_width*0.7),
      child: SizedBox(
        height: screen_height*0.5, width: screen_width*0.7,
        child: Container(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                completedChallenges[whichChallenge].photoUrl
              ),
            )
          )
        )
      ),
    ):
    Container(width: screen_width*0.7),
  );
}

Widget VideoSwiperContainer(
  BuildContext context, 
  bool isAccepted, 
  bool isRejected, 
  double transAmount, 
  double rotateAmount, 
  whichChallenge, 
  completedChallenges,
  screen_height, screen_width,
  _initializeVideoPlayerFuture,
  _videoController
){
  print("Checking challenge #${completedChallenges[whichChallenge].number}...");
  return AnimatedContainer(
    duration: Duration(seconds: 1),
    curve: Curves.elasticOut,
    transform: Matrix4.skewY(0)..rotateZ(rotateAmount)..translate(transAmount),
    child: isAccepted == false && isRejected == false ?
    Draggable(
      data: "${completedChallenges[whichChallenge].photoUrl}",
      feedback: SizedBox(
        height: screen_height*0.5, width: screen_width*0.7,
        child: Container(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoController.value.size != null ? _videoController.value.aspectRatio : 2 / 2,
                      child: VideoPlayer(_videoController),
                    );
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            )
          )
        )
      ),
      childWhenDragging: Container(width: screen_width*0.7),
      child: SizedBox(
        height: screen_height*0.5, width: screen_width*0.7,
        child: Container(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoController.value.size != null ? _videoController.value.aspectRatio : 2 / 2,
                      child: VideoPlayer(_videoController),
                    );
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            )
          )
        )
      )
    ):
    Container(width: screen_width*0.7)
  );
}

Widget RejectionBar(
  BuildContext context, 
  bool isRejected, 
  completedChallenges, 
  whichChallenge, 
  teamID, 
  Function(bool isRejectedOrAccepted) setMyState, 
  adminUser, 
  gameCode,
  screen_height,
  screen_width
){
  return Container(
    height: screen_height*0.55,
    width: isRejected ? screen_width*0.7 : screen_width*0.14,
    child:DragTarget(
      builder: (context, List<String> candidateData, rejectedData) {
        return isRejected == false ? 
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:Container(
            child: Icon(Icons.arrow_back, color: Colors.red[200]),
            color:Colors.red[50]
          )
        ) : 
        Container(
          color:Colors.red[200],
          width: screen_width*0.8,
        );
      },
      onWillAccept: (data){
        return true;
      },
      onAccept: (data) async {
        
        print("Challenge ${whichChallenge + 1} denied by admin");
        setMyState(isRejected);
        //Mark challenge as checked, both in object and db
        completedChallenges[whichChallenge].checked = true; 
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
        //get leaderboard document
        var ds = await Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").get();
        //get # of challenges denied
        int deniedChallenges = ds.data['deniedChallenges'];
        //get # of points
        int points = ds.data['totalPoints'];
        //add 1 to # of challenges denied
        print("Adding denied challenge to leaderboard");
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'deniedChallenges': deniedChallenges + 1});
        //subtract 5 points from total score
        print("Subtracting 5 points from $teamID" + "_" + "$gameCode's totalScore in leaderboard");
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'totalPoints': points - 5});

        // if more challenges to check
        if (whichChallenge < completedChallenges.length - 1){
          print("Navigating to same screen, next challenge...");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminSpecificTeamScreen(
                adminUser: adminUser,
                gameCode: gameCode,
                teamID: teamID, 
                completedChallenges: completedChallenges, 
                whichChallenge: whichChallenge + 1
              )
            )
          );
        }
        else{
          print("Navigating to same screen, no more challenges...");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(adminUser: adminUser, gameCode: gameCode)
            )
          );
        }
      },
    ),
  );
}

Widget AcceptanceBar(
  BuildContext context, 
  bool isAccepted, 
  completedChallenges, 
  whichChallenge, 
  teamID, 
  Function(bool isRejectedOrAccepted) setMyState, 
  adminUser, 
  gameCode,
  screen_height,
  screen_width
){
  return Container(
    height: screen_height*0.55,
    width: isAccepted ? screen_width*0.7 : screen_width*0.14,
    child:DragTarget(
      builder: (context, List<String> candidateData, rejectedData) {
        return isAccepted == false ? 
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:Container(
            child: Icon(Icons.arrow_forward, color: Colors.green[200]),
            color:Colors.green[50]
          )
        ) : 
        Container(
          color:Colors.green[200],
          width: screen_width*0.8,
        );
      },
      onWillAccept: (data){
        return true;
      },
      onAccept: (data) async {
        print("Challenge ${whichChallenge + 1} accepted by admin");
        setMyState(isAccepted);
        
        //Mark challenge as checked and confirmed, both in object and db
        completedChallenges[whichChallenge].checked = true;
        completedChallenges[whichChallenge].confirmed = true;
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.confirmed': true});
        
        //update confirmed challenges
        var ds = await Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").get();
        int confirmedChallenges = ds.data['confirmedChallenges'];
        print("Adding confirmed challenge to leaderboard");
        Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'confirmedChallenges': confirmedChallenges + 1});
        
        // if more challenges to check
        if (whichChallenge < completedChallenges.length - 1){
          print("Navigating to same screen, next challenge...");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminSpecificTeamScreen(
                adminUser: adminUser,
                gameCode: gameCode,
                teamID: teamID, 
                completedChallenges: completedChallenges, 
                whichChallenge: whichChallenge + 1
              )
            )
          );
        }
        else{
          print("Navigating to same screen, no more challenges...");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(
                adminUser: adminUser, 
                gameCode: gameCode
              )
            )
          );
        }
      },
    ),
  );
}

Widget RejectButton(
  BuildContext context, 
  whichChallenge, 
  completedChallenges, 
  teamID, 
  Function(double tAmount, double rAmount) setMyTransState, 
  adminUser, 
  gameCode
){
  return RaisedButton(
    child: Text("Reject"),
    color: Colors.red[50],
    onPressed: () async {
      
      print("Challenge ${whichChallenge + 1} denied by admin");
      setMyTransState(-100.0, 0.0);
      //Mark challenge as checked, both in object and db
      completedChallenges[whichChallenge].checked = true; 
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
      //get leaderboard document
      print("Getting leaderboardID: $teamID" + "_" + "$gameCode");
      var ds = await Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").get();
      //get # of challenges denied
      int deniedChallenges = ds.data['deniedChallenges'];
      //get # of points
      int points = ds.data['totalPoints'];
      //add 1 to # of challenges denied
      print("Adding denied challenge to leaderboard");
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'deniedChallenges': deniedChallenges + 1});
      //subtract 5 points from total score
      print("Subtracting 5 points from $teamID" + "_" + "$gameCode's totalScore in leaderboard");
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'totalPoints': points - 5});
      
      print("Navigating to same screen, next challenge...");
      if (whichChallenge < completedChallenges.length - 1){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => AdminSpecificTeamScreen(
              adminUser: adminUser,
              gameCode: gameCode,
              teamID: teamID, 
              completedChallenges: completedChallenges, 
              whichChallenge: whichChallenge + 1
            )
          )
        );
      }
      else{
        print("Navigating to same screen, no more challenges...");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => 
            AdminTeamsListScreen(
              adminUser: adminUser, 
              gameCode: gameCode
            )
          )
        );
      }
      //
    }
  );
}

Widget AcceptButton(
  BuildContext context, 
  whichChallenge, 
  completedChallenges, 
  teamID, 
  Function(double tAmount, double rAmount) setMyTransState, 
  adminUser, 
  gameCode
){
  return RaisedButton(
    child: Text("Accept"),
    color: Colors.green[50],
    onPressed: () async {
      
      print("Challenge ${whichChallenge + 1} accepted by admin");
      setMyTransState(100.0, 0.0);
      //Mark challenge as checked and confirmed, both in object and db
      completedChallenges[whichChallenge].checked = true;
      completedChallenges[whichChallenge].confirmed = true;
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'challenges.${completedChallenges[whichChallenge].number}.confirmed': true});
      
      //update confirmed challenges
      var ds = await Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").get();
      int confirmedChallenges = ds.data['confirmedChallenges'];
      print("Adding confirmed challenge to leaderboard");
      Firestore.instance.collection("leaderboard").document("$teamID" + "_" + "$gameCode").updateData({'confirmedChallenges': confirmedChallenges + 1});
      
      // If more challenges to check
      if (whichChallenge < completedChallenges.length - 1){
        print("Navigating to same screen, next challenge...");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => AdminSpecificTeamScreen(
              teamID: teamID, 
              gameCode: gameCode, 
              completedChallenges: completedChallenges, 
              whichChallenge: whichChallenge + 1, 
              adminUser: adminUser
            )
          )
        );
      }
      else{
        print("Navigating to same screen, no more challenges...");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => AdminTeamsListScreen(
              adminUser: adminUser, 
              gameCode: gameCode
            )
          )
        );
      }
    }
  );
}

Widget AppBarTextSpan(BuildContext context, UserDetails user){
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '${user.userName.toString().substring(0, 1)}', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: '${user.userName.toString().substring(1, user.userName.length)}', 
          style: Styles.orangeNormalDefault
        )
      ],
    ),
  );
}