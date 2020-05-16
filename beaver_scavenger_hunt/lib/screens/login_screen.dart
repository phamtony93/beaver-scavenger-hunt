// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Screens
import 'clue_screen.dart';
import 'join_game_screen.dart';
import 'admin_teams_list_screen.dart';
import 'create_game_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/provider_details_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/is_new_user.dart';
import '../functions/is_new_admin.dart';
import '../functions/get_prev_user.dart';
import '../functions/get_begin_time.dart';
import '../functions/calculate_points.dart';
//Widgets
import '../widgets/control_button.dart';
// Styles
import '../styles/styles_class.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String name;
  String email;
  String photoUrl;

  Future<int> getTotalPoints(UserDetails userDetails, DateTime beginTime, DateTime endTime, allLocations, allChallenges) async {
    
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

  // SIGN IN AS PLAYER FUNCTION:
  Future<AuthResult> _signInAsPlayer(BuildContext context) async {
    
    // AUTHENTICATE PLAYER / USER
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult userDetails = await _firebaseAuth.signInWithCredential(credential);

    ProviderDetails providerInfo = ProviderDetails(userDetails.additionalUserInfo.providerId);

    List<ProviderDetails> providerData = List<ProviderDetails>();
    providerData.add(providerInfo);

    // CREATE USER DETAILS OBJECT
    UserDetails user = UserDetails(
      userDetails.user.providerId,
      userDetails.user.uid, //123
      userDetails.user.displayName,
      userDetails.user.photoUrl,
      userDetails.user.email,
      // providerData
    );

    // DETERMINE IF NEW OR PREV USER

    bool isNewUser = await is_new_user(user);
    
    //IF PREVIOUS USER:
    if (!isNewUser) {
      
      print("Previous User Found");
      print("Retreiving user data from db...");

      //retrieve previousUser info
      Map<String, dynamic> prevUser;
      prevUser = await get_prev_user(user);
      Map<String, dynamic> allClueLocationsMap = prevUser['clue locations'];
      Map<String, dynamic> allChallengesMap = prevUser['challenges'];

      //create clueLocation object(s) from json map
      List<ClueLocation> allLocations = [];
      int which = 0;
      for (int i = 1; i < 11; i++){
        ClueLocation loca = ClueLocation.fromJson(allClueLocationsMap["$i"]);
        if (loca.available == true && loca.solved == false){
          which = i-1;
        }
        if (loca.number == 10 && loca.available == true){
          which = 9;
        }
        allLocations.add(loca);
      }

      //create challenge object(s) from json map
      List<Challenge> allChallenges = [];
      for (int i = 1; i < 11; i++){
        Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
        allChallenges.add(chall);
      }
      print("user data obtained");

      //get beginTime timeStamp from db
      print("Getting startTime from database...");
      Timestamp begin = await getBeginTime(user);
      DateTime beginTime = begin.toDate();
      print("startTime data obtained");
      
      // Navigate to clue screen 
      // (with userDetails, allLocations, allChallenges, whichLocation, and beginTime)
      print("Navigating to Clue Screen ${which + 1}...");
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => ClueScreen(
            userDetails: user, 
            allLocations: allLocations, 
            allChallenges: allChallenges, 
            whichLocation: which, 
            beginTime: beginTime
          )
        )
      );
      
    }
    
    // IF NEW USER
    else{
      
      print("No previous user found.");
      print("Navigating to Join Game Screen");
      //Navigate to Join Game Screen (with user details)
      Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => JoinGameScreen(userDetails: user)
          )
        );
    }  
    //return userDetails to sign-in function
    return userDetails;
  }

  // SIGN IN AS ADMIN FUNCTION
  Future<AuthResult> _signInAsAdmin(BuildContext context) async {
    
    // AUTHENTICATE ADMIN / USER
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult userDetails = await _firebaseAuth.signInWithCredential(credential);
    ProviderDetails providerInfo = ProviderDetails(userDetails.additionalUserInfo.providerId);
    List<ProviderDetails> providerData = List<ProviderDetails>();
    providerData.add(providerInfo);

    // CREATE USER DETAILS OBJECT
    UserDetails user = UserDetails(
      userDetails.user.providerId,
      userDetails.user.uid, //123
      userDetails.user.displayName,
      userDetails.user.photoUrl,
      userDetails.user.email,
      // providerData
    );

    // GET GAME CODE
    String adminGameCode = await is_new_admin(user);
    
    // IF NEW ADMIN
    if (adminGameCode == 'newAdmin') {
      //Navigate to Create Game Screen
      print("Navigating to Create Game Screen...");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGameScreen(user: user)
        )
      );
    } 
    // IF PREV ADMIN
    else {
      user.gameID = adminGameCode;
      //Navigate to Admin Teams List Screen (with user details and game code)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminTeamsListScreen(adminUser: user, gameCode: adminGameCode,)
        )
      );
    }

    //return userDetails object to admin log-in function
    return userDetails;
  }

  Widget googleSignInButton(context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/google_logo.png'), height: 25,),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Login As Player')
            )
          ]
        ),
      ),
      onPressed: () => _signInAsPlayer(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: screen_height*0.45,
                width: screen_width,
                image: AssetImage('assets/images/osu_logo.png')
              ),
              Text(
                'Scavenger\nHunt', 
                style: TextStyle(fontSize: 60),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screen_height*0.05,
              ),
              // googleSignInButton(context),
              ControlButton(
                context: context,
                text: 'Login as Player',
                style: Styles.whiteNormalDefault,
                onPressFunction: _signInAsPlayer,
                imageLogo: 'assets/images/google_logo.png',
              ),
              SizedBox(height: screen_height*0.025),
              ControlButton(
                context: context, 
                text: 'Login as Admin',
                style: Styles.whiteNormalDefault, 
                onPressFunction: _signInAsAdmin, 
                imageLogo: 'assets/images/google_logo.png'
              ),
              //TEMP LOGIN BUTTON
              /*
              RaisedButton(
                child: Text('Temp Login'),
                onPressed: ()  async {
                  UserDetails user = UserDetails(
                    'providerDetails',
                    'uid123',
                    'tester',
                    'photoURL',
                    'tester@gmail.com'
                  );
            
                  // DETERMINE IF NEW OR PREV USER

                  bool isNewUser = await is_new_user(user);
                  
                  //IF PREVIOUS USER:
                  if (!isNewUser) {
                    
                    print("Previous User Found");
                    print("Retreiving user data from db...");

                    //retrieve previousUser info
                    Map<String, dynamic> prevUser;
                    prevUser = await get_prev_user(user);
                    Map<String, dynamic> allClueLocationsMap = prevUser['clue locations'];
                    Map<String, dynamic> allChallengesMap = prevUser['challenges'];

                    //create clueLocation object(s) from json map
                    List<ClueLocation> allLocations = [];
                    int which = 0;
                    for (int i = 1; i < 11; i++){
                      ClueLocation loca = ClueLocation.fromJson(allClueLocationsMap["$i"]);
                      if (loca.available == true && loca.solved == false){
                        which = i-1;
                      }
                      if (loca.number == 10 && loca.available == true){
                        which = 9;
                      }
                      allLocations.add(loca);
                    }

                    //create challenge object(s) from json map
                    List<Challenge> allChallenges = [];
                    for (int i = 1; i < 11; i++){
                      Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
                      allChallenges.add(chall);
                    }

                    //get beginTime timeStamp from db
                    print("Getting startTime from database...");
                    Timestamp begin = await getBeginTime(user);
                    DateTime beginTime = DateTime.parse(begin.toDate().toString());
                    
                    //Navigate to clue screen 
                    // (with userDetails, allLocations, allChallenges, whichLocation, and beginTime)
                    print("user data obtained");
                    //if game complete
                    //navigate to end game screen
                    //else
                    print("Navigating to Clue Screen ${which + 1}...");
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ClueScreen(
                          userDetails: user, 
                          allLocations: allLocations, 
                          allChallenges: allChallenges, 
                          whichLocation: which, 
                          beginTime: beginTime
                        )
                      )
                    );
                  }
                  
                  // IF NEW USER
                  else{
                    
                    print("No previous user found.");
                    print("Navigating to Join Game Screen");
                    //Navigate to Join Game Screen (with user details)
                    Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => JoinGameScreen(userDetails: user)
                        )
                      );
                  }
                },
              )*/
            ]
          )
        )
      )
    );
  }
}
