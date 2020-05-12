// Packages
import 'package:flutter/material.dart';
// Screens
import '../screens/challenge_screen.dart';
import '../screens/hunt_complete_screen.dart';
import '../screens/clue_screen.dart';
import '../screens/rules_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';

Widget MenuDrawer(
  BuildContext context, List<ClueLocation> allLocations, 
  int which, List<Challenge> allChallenges, 
  UserDetails userDetails, DateTime beginTime
){
  return GestureDetector(
    onTap: (){
      Navigator.pop(context);
    },
    child:Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 25),
                MyDrawerHeader(context),
                MenuRulesWidget(context, allLocations, 10, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuChallengesWidget(context, allLocations, 11, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 0, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 1, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 2, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 3, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 4, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 5, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 6, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 7, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 8, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuClueWidget(context, allLocations, 9, allChallenges, scaffoldContext, which, userDetails, beginTime),
                MenuHuntCompleteWidget(context, allLocations, 12, allChallenges, scaffoldContext, which, userDetails, beginTime),
              ],
            )
          );
        }
      )
    )
  );
}

Widget MyDrawerHeader(BuildContext context){
  return ListTile(
      title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 55,
          child: Container(
            padding: EdgeInsets.all(5),
            color: Colors.black,
            child: FittedBox(
              child:Text(
                'Menu', 
                style: TextStyle(fontSize: 30, color: Colors.white), 
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
  );
}

MenuRulesWidget(
  BuildContext context, 
  List<ClueLocation> allLocations, 
  int which, List<Challenge> allChallenges, 
  BuildContext scaffoldContext, int current,
  UserDetails userDetails, DateTime beginTime
){
  return ListTile(
    leading: Icon(Icons.list, color: Colors.black),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: FittedBox( 
              child: Text(
                "Rules", 
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ),
    ),
    onTap: () {
      if (which == current){
        Navigator.pop(context);
      }
      else{
        print("Navigating to Rules Screen...");
        Navigator.pop(context);
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => RulesScreen(
              allLocations: allLocations, 
              whichLocation: which, 
              allChallenges: allChallenges, 
              userDetails: userDetails,
              beginTime: beginTime,
            )
          )
        );
      }
    },
  );
}
        
MenuChallengesWidget(
  BuildContext context, 
  List<ClueLocation> allLocations, 
  int which, List<Challenge> allChallenges, 
  BuildContext scaffoldContext, int current,
  UserDetails userDetails, DateTime beginTime
){
  return ListTile(
    leading: Icon(Icons.directions_run, color: Colors.black),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child:FittedBox( 
              child: Text(
                "Challenges", style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        )
    ),
    onTap: () {
      //close drawer
      if (which == current){
        Navigator.pop(context);
      }
      //navigate to challenge screen
      else{
        Navigator.pop(context);
        print("Navigating to Challenge Screen...");
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => 
            ChallengeScreen(
              allChallenges: allChallenges,
              allLocations: allLocations, 
              userDetails: userDetails,
              whichLocation: which,
              beginTime: beginTime,
            )
          )
        );
      }
    },
  );
}

Widget MenuClueWidget(
  BuildContext context, 
  List<ClueLocation> allLocations, 
  int which, List<Challenge> allChallenges, 
  BuildContext scaffoldContext, int current, 
  UserDetails userDetails, DateTime beginTime
){
  return ListTile(
    leading: Icon(
      allLocations[which].solved == true ? 
      Icons.check: Icons.lightbulb_outline, 
      color: allLocations[which].available == true ? 
      Colors.black: Colors.grey
    ),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child:FittedBox( 
              child: Text(
                "Clue ${allLocations[which].number}", 
                style: TextStyle(
                  color: allLocations[which].available == true ? 
                  Colors.white : Colors.grey
                ),
              ),
            ),
          ),
        ),
    ),
    onTap: () {
      //close drawer
      if (allLocations[which].available == true) {
        if (which == current){
          Navigator.pop(context);
        }
        //navigate to clue
        else{
          print("Navigating to Clue Screen...");
          Navigator.pop(context);
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => ClueScreen(
                allLocations: allLocations, 
                whichLocation: which, 
                allChallenges: allChallenges, 
                userDetails: userDetails,
                beginTime: beginTime,
              )
            )
          );
        }
      }
      else{
        final snackBar = SnackBar(
          content: Text(
            "This clue is not yet available",
            textAlign: TextAlign.center
          )
        );
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
      }
    },
  );
}

Widget MenuHuntCompleteWidget(
  BuildContext context, 
  List<ClueLocation> allLocations, 
  int which, List<Challenge> allChallenges, 
  BuildContext scaffoldContext, int current,
  UserDetails userDetails, DateTime beginTime
){
  return ListTile(
    leading: Icon(
      allLocations[9].found == true ? 
      Icons.check: Icons.do_not_disturb, 
      color: allLocations[9].found == true ? 
      Colors.black: Colors.grey
    ),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child:FittedBox( 
              child: Text(
                "Complete Hunt", 
                style: TextStyle(
                  color: allLocations[9].found == true ? 
                  Colors.white : Colors.grey
                ),
              ),
            ),
          ),
        ),
    ),
    onTap: () {
      //close menu drawer
      if (allLocations[9].found == true) {
        if (which == current){
          Navigator.pop(context);
        }
        //navigate to Hunt Complete Screen
        else{
          print("Navigating to Hunt Complete Screen...");
          Navigator.pop(context);
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => HuntCompleteScreen(
                userDetails: userDetails,
                allChallenges: allChallenges,
                allLocations: allLocations,
                whichLocation: which,
                beginTime: beginTime,
              )
            )
          );
        }
      }
      else{
        final snackBar = SnackBar(
          content: Text(
            "This page is available after all clues have been found",
            textAlign: TextAlign.center
          )
        );
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
      }
    },
  );
}