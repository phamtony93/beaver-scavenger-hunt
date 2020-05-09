// Packages
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screens
import 'admin_teams_list_screen.dart';
// Models
import '../models/challenge_model.dart';

class AdminSpecificTeamScreen extends StatefulWidget {

  final UserDetails adminUser;
  final String gameID;
  final String teamID;
  final List<Challenge> completedChallenges;
  final int whichChallenge;

  AdminSpecificTeamScreen({
    Key key, 
    this.adminUser,
    this.gameID,
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
  
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build (BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(adminUser: widget.adminUser, gameID: widget.gameID,)
            )
          );
          return Future<bool>.value(false);
        },
        child: Scaffold(
        appBar: AppBar(
            title: Text('${widget.teamID}'),
            centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget> [
              SizedBox(height: 30),
              PhotoDescription(context, widget.completedChallenges[widget.whichChallenge].description),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  RejectionBar(context, isRejected, widget.completedChallenges, widget.whichChallenge, widget.teamID, setMyState, widget.adminUser, widget.gameID),
                  PhotoSwiperContainer(context, isAccepted, isRejected, transAmount, rotateAmount, widget.whichChallenge, widget.completedChallenges),
                  AcceptanceBar(context, isAccepted, widget.completedChallenges, widget.whichChallenge, widget.teamID, setMyState, widget.adminUser, widget.gameID)
                ],
              ),
              SizedBox(height: 20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RejectButton(context, widget.whichChallenge, widget.completedChallenges, widget.teamID, setMyTransState, widget.adminUser, widget.gameID),
                  SizedBox(width: 100),
                  AcceptButton(context, widget.whichChallenge, widget.completedChallenges, widget.teamID, setMyTransState, widget.adminUser, widget.gameID)
                ],
              )
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
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
      ),
  );
}

Widget PhotoSwiperContainer(BuildContext context, bool isAccepted, bool isRejected, double transAmount, double rotateAmount, whichChallenge, completedChallenges){
  return AnimatedContainer(
    duration: Duration(seconds: 1),
    curve: Curves.elasticOut,
    transform: Matrix4.skewY(0)..rotateZ(rotateAmount)..translate(transAmount),
    child: isAccepted == false && isRejected == false ?
    Draggable(
      data: "${completedChallenges[whichChallenge].photoUrl}",
      feedback: SizedBox(
        height: 300, width: 300,
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
      childWhenDragging: Container(width:300),
      child: SizedBox(
        height: 300, width: 300,
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
    Container(width: 50),
  );
}

Widget RejectionBar(BuildContext context, bool isRejected, completedChallenges, whichChallenge, teamID, Function(bool isRejectedOrAccepted) setMyState, adminUser, gameID){
  return Container(
    height: 350,
    width: isRejected ? 300 : 50,
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
          width: 400,
        );
      },
      onWillAccept: (data){
        return true;
      },
      onAccept: (data){
        setMyState(isRejected);
        completedChallenges[whichChallenge].checked = true;
        Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
        if (whichChallenge < completedChallenges.length - 1){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminSpecificTeamScreen(
                adminUser: adminUser,
                gameID: gameID,
                teamID: teamID, 
                completedChallenges: completedChallenges, 
                whichChallenge: whichChallenge + 1
              )
            )
          );
        }
        else{
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(adminUser: adminUser, gameID: gameID)
            )
          );
        }
      },
    ),
  );
}

Widget AcceptanceBar(BuildContext context, bool isAccepted, completedChallenges, whichChallenge, teamID, Function(bool isRejectedOrAccepted) setMyState, adminUser, gameID){
  return Container(
    height: 350,
    width: isAccepted ? 300 : 50,
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
          width: 400,
        );
      },
      onWillAccept: (data){
        return true;
      },
      onAccept: (data){
        setMyState(isAccepted);
        completedChallenges[whichChallenge].checked = true;
        Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
        if (whichChallenge < completedChallenges.length - 1){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminSpecificTeamScreen(
                adminUser: adminUser,
                gameID: gameID,
                teamID: teamID, 
                completedChallenges: completedChallenges, 
                whichChallenge: whichChallenge + 1
              )
            )
          );
        }
        else{
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:  (context) => AdminTeamsListScreen(adminUser: adminUser, gameID: gameID,)
            )
          );
        }
      },
    ),
  );
}

Widget RejectButton(BuildContext context, whichChallenge, completedChallenges, teamID, Function(double tAmount, double rAmount) setMyTransState, adminUser, gameID){
  return RaisedButton(
    child: Text("Reject"),
    color: Colors.red[50],
    onPressed: (){
      //
      setMyTransState(-100.0, 0.0);
      completedChallenges[whichChallenge].checked = true;
      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
      if (whichChallenge < completedChallenges.length - 1){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:  (context) => AdminSpecificTeamScreen(
              adminUser: adminUser,
              gameID: gameID,
              teamID: teamID, 
              completedChallenges: completedChallenges, 
              whichChallenge: whichChallenge + 1
            )
          )
        );
      }
      else{
        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen(adminUser: adminUser, gameID: gameID)));
      }
      //
    }
  );
}

Widget AcceptButton(BuildContext context, whichChallenge, completedChallenges, teamID, Function(double tAmount, double rAmount) setMyTransState, adminUser, gameID){
  return RaisedButton(
    child: Text("Accept"),
    color: Colors.green[50],
    onPressed: (){
      setMyTransState(100.0, 0.0);
      completedChallenges[whichChallenge].checked = true;
      completedChallenges[whichChallenge].confirmed = true;
      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.checked': true});
      Firestore.instance.collection("users").document("$teamID").updateData({'challenges.${completedChallenges[whichChallenge].number}.confirmed': true});
      if (whichChallenge < completedChallenges.length - 1){
        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminSpecificTeamScreen(teamID: teamID, gameID: gameID, completedChallenges: completedChallenges, whichChallenge: whichChallenge + 1, adminUser: adminUser,) ));
      }
      else{
        Navigator.of(context).push(MaterialPageRoute(builder:  (context) => AdminTeamsListScreen(adminUser: adminUser, gameID: gameID)));
      }
    }
  );
}