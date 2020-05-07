import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../models/clue_location_model.dart';
import 'clue_screen.dart';
import 'join_game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../functions/upload_new_user_challeges.dart';
import '../functions/upload_new_admin.dart';
import '../functions/is_new_user.dart';
import '../functions/is_new_admin.dart';
import '../functions/get_prev_user.dart';
import '../functions/get_prev_admin.dart';
import '../models/user_details_model.dart';
import '../models/provider_details_model.dart';
<<<<<<< HEAD
import '../screens/adminTeamsList_screen.dart';
=======
import '../screens/admin_teams_list_screen.dart';
>>>>>>> seawellj_branch
import 'package:beaver_scavenger_hunt/screens/create_game_screen.dart';
import '../models/challenge_model.dart';
import 'welcome_screen.dart';
import '../functions/get_begin_time.dart';
import '../styles/styles_class.dart';
import '../widgets/control_button.dart';

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

  Future<AuthResult> _signInAsPlayer(BuildContext context) async {
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

    UserDetails user = UserDetails(
      userDetails.user.providerId,
      userDetails.user.uid, //123
      userDetails.user.displayName,
      userDetails.user.photoUrl,
      userDetails.user.email,
      // providerData
    );

    Map<String, dynamic> prevUser;

    bool isNewUser = await is_new_user(user.uid);
    if (isNewUser) {
      print("Adding new user");
      uploadNewUserAndChallenges(user);
    }

    //retrieve previousUser info
    prevUser = await get_prev_user(user.uid);
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
      allLocations.add(loca);
    }

    //create challenge object(s) from json map
    List<Challenge> allChallenges = [];
    for (int i = 1; i < 11; i++){
      Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
      allChallenges.add(chall);
    }  

    if(isNewUser){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => JoinGameScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges)
        )
      );
    }
    else{
      Timestamp begin = await getBeginTime(user.uid);
      DateTime beginTime = DateTime.parse(begin.toDate().toString());
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => ClueScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges, whichLocation: which, beginTime: beginTime)
        )
      );
    }
    return userDetails;
  }

   Future<AuthResult> _signInAsAdmin(BuildContext context) async {
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

    UserDetails user = UserDetails(
      userDetails.user.providerId,
      userDetails.user.uid, //123
      userDetails.user.displayName,
      userDetails.user.photoUrl,
      userDetails.user.email,
      // providerData
    );

    // Map<String, dynamic> prevUser;

    String adminGameCode = await is_new_admin(user.uid);
    if (adminGameCode == 'newAdmin') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGameScreen(user: user)
        )
      );
    } else {
      user.gameID = adminGameCode;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminTeamsListScreen(adminUser: user, gameID: adminGameCode,)
        )
      );
    }

    // //retrieve previousUser info
    // prevUser = await get_prev_user(user.uid);
    // Map<String, dynamic> allClueLocationsMap = prevUser['clue locations'];
    // Map<String, dynamic> allChallengesMap = prevUser['challenges'];

    // //create clueLocation object(s) from json map
    // List<ClueLocation> allLocations = [];
    // int which = 0;
    // for (int i = 1; i < 11; i++){
    //   ClueLocation loca = ClueLocation.fromJson(allClueLocationsMap["$i"]);
    //   if (loca.available == true && loca.solved == false){
    //     which = i-1;
    //   }
    //   allLocations.add(loca);
    // }

    // if(isNewUser){
    //   Navigator.push(
    //     context, 
    //     MaterialPageRoute(
    //       builder: (context) => JoinGameScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges)
    //     )
    //   );
    // }
    // else{
    //   Timestamp begin = await getBeginTime(user.uid);
    //   DateTime beginTime = DateTime.parse(begin.toDate().toString());
    //   Navigator.push(
    //     context, 
    //     MaterialPageRoute(
    //       builder: (context) => ClueScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges, whichLocation: which, beginTime: beginTime)
    //     )
    //   );
    // }
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
    Map<String, dynamic> prevUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: 275,
                width: 275,
                image: AssetImage('assets/images/osu_logo.png')),
              Text('Scavenger', style: TextStyle(fontSize: 60)),
              Text('Hunt', style: TextStyle(fontSize: 60)),
              SizedBox(
                height: 50,
              ),
              // googleSignInButton(context),
              ControlButton(
                context: context,
                text: 'Login as Player',
                onPressFunction: _signInAsPlayer,
                imageLogo: 'assets/images/google_logo.png',
              ),
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
            
                  bool isNewUser = await is_new_user(user.uid);
                  if (isNewUser) {
                    print("Adding new user");
                    uploadNewUserAndChallenges(user);
                  }

                  //retrieve previousUser info
                  prevUser = await get_prev_user(user.uid);
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
                    allLocations.add(loca);
                  }

                  //create challenge object(s) from json map
                  List<Challenge> allChallenges = [];
                  for (int i = 1; i < 11; i++){
                    Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
                    allChallenges.add(chall);
                  }  

                  if(isNewUser){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => JoinGameScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges,)
                      )
                    );
                  }
                  else{
                    Timestamp begin = await getBeginTime(user.uid);
                    DateTime beginTime = DateTime.parse(begin.toDate().toString());
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ClueScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges, whichLocation: which, beginTime: beginTime)
                      )
                    );
                  }
                },
              ),
              ControlButton(
                context: context, 
                text: 'Login as Admin', 
                onPressFunction: _signInAsAdmin, 
                imageLogo: 'assets/images/google_logo.png'
              ),
              // RaisedButton(
              //   child: Text("Login as Admin"),
              //   onPressed: () => _signInAsAdmin(context)
              // ),
              RaisedButton(
                child: Text('Join Game'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGameScreen())),
              )
            ]
          )
        )
      )
    );
  }
}
