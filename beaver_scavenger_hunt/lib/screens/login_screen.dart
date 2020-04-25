import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
//import 'camera_screen.dart';
import 'clue_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:beaver_scavenger_hunt/functions/new_user_challeges.dart';
import 'package:beaver_scavenger_hunt/functions/is_new_user.dart';
import 'package:beaver_scavenger_hunt/functions/get_prev_user.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'package:beaver_scavenger_hunt/classes/ProviderDetails.dart';
// import 'profile_screen.dart';
import 'welcome_screen.dart';

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

  Future<AuthResult> _signIn(BuildContext context) async {
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

    UserDetails details = UserDetails(
      userDetails.user.providerId,
      userDetails.user.uid,
      userDetails.user.displayName,
      userDetails.user.photoUrl,
      userDetails.user.email,
      // providerData
    );

    Navigator.pushReplacement(context,
    MaterialPageRoute(
      builder: (context) => WelcomeScreen(userDetails: details),
    ));

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
              SizedBox(height: 60),
              Image(
                height: 275,
                width: 275,
                image: AssetImage('assets/images/osu_logo.png')),
              Text('Scavenger', style: TextStyle(fontSize: 60)),
              Text('Hunt', style: TextStyle(fontSize: 60)),
              SizedBox(
                height: 75,
              ),
              RaisedButton(
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
                        child: Text('Login With Google')
                      )
                    ]
                  ),
                ),
                onPressed: () => _signIn(context),
              ),
              RaisedButton(
                child: Text('Temp Login'),
                onPressed: ()  async {
                  UserDetails user = UserDetails(
                    'providerDetails',
                    'uid129',
                    'tester1',
                    'photoURL',
                    'tester1@gmail.com'
                  );
            
                  bool isNewUser = await is_new_user(user.uid);
                  if (isNewUser) {
                    print("Adding new user");
                    uploadNewUserAndChallenges(user.uid);
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

                  if(isNewUser){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(userDetails: user, allLocations: allLocations, allChallengesMap: allChallengesMap)
                      )
                    );
                  }
                  else{
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ClueScreen(userDetails: user, allLocations: allLocations, whichLocation: which,)
                      )
                    );
                  }

                },
              ),
            ]
          )
        )
      )
    );
  }
}
