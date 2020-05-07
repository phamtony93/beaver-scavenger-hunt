import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../models/clue_location_model.dart';
import 'clue_screen.dart';
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
import '../screens/adminTeamsList_screen.dart';
import '../models/challenge_model.dart';
import 'welcome_screen.dart';
import '../functions/get_begin_time.dart';
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

  Future<AuthResult> _signIn(BuildContext context, bool userOrAdmin) async {
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
    Map<String, dynamic> prevAdmin;
    bool isNewUser;
    bool isNewAdmin;
    
    //Is new user or admin
    if (userOrAdmin == true){
      isNewUser = await is_new_user(user.uid);
      if (isNewUser) {
        print("Adding new user");
        uploadNewUserAndChallenges(user);
      }
    }
    else{
      isNewAdmin = await is_new_admin(user.uid);
      if (isNewAdmin) {
        print("Adding new admin");
        
        // ADD THIS FUNCTION
        
        //String randGameID = generateRandomGameId();
        uploadNewAdmin(user, "123b");
      }
    }
    
    //get user or admin info
    if (userOrAdmin == true){
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
            builder: (context) => WelcomeScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges)
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
    }
    else{
      //retrieve previousAdmin info
      prevAdmin = await get_prev_admin(user.uid);
      String gameID = prevAdmin["gameID"];
      Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => AdminTeamsListScreen(adminUser: user, gameID: gameID,)
          )
        );
    }

    return userDetails;
 
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color.fromRGBO(255,117, 26, 1),
                  height: 80, width: 200,
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RaisedButton(
                      color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/images/google_logo.png'), height: 30,),
                          Text(
                            'oogle Login',
                            style: Styles.whiteNormalSmall,
                            )
                        ]
                      ),
                      onPressed: () => _signIn(context, true),
                    ),
                  )
                )
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
                        builder: (context) => WelcomeScreen(userDetails: user, allLocations: allLocations, allChallenges: allChallenges,)
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color.fromRGBO(255,117, 26, 1),
                  height: 80, width: 200,
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RaisedButton(
                      color: Colors.black,
                      child: Text(
                        "Admin Login",
                        style: Styles.whiteNormalSmall
                      ),
                      onPressed: () => _signIn(context, false),
                    ),
                  )
                )
              ),
            ]
          )
        )
      )
    );
  }
}
