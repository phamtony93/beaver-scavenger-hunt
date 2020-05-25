// Packages
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

// Functions
import '../lib/functions/add_user_leaderboard.dart';
import '../lib/functions/upload_new_user_and_challenges.dart';
import '../lib/functions/get_prev_user.dart';

// Models
import '../lib/models/user_details_model.dart';
import '../lib/models/provider_details_model.dart';
import '../lib/models/challenge_model.dart';

void main() async{
    TestWidgetsFlutterBinding.ensureInitialized();
      // AUTHENTICATE PLAYER / USER
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

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

    uploadNewUserAndChallenges(user, "ABCD");
    
    //retrieve previousUser info
    Map<String, dynamic> prevUser;
    prevUser = await get_prev_user(user);
    Map<String, dynamic> allClueLocationsMap = prevUser['clue locations'];
    Map<String, dynamic> allChallengesMap = prevUser['challenges'];

    //create challenge object(s) from json map
    List<Challenge> allChallenges = [];
    for (int i = 1; i < 11; i++){
      Challenge chall = Challenge.fromJson(allChallengesMap["$i"]);
      allChallenges.add(chall);
    }

    String userName = user.userEmail + '_' + 'ABCD';

  test('Add User To Leaderboard', () async {
    //create test vars
    allChallenges[3].completed = true;
    allChallenges[3].photoUrl = 'http://www.test.com';
    
    await addUserLeaderboard(user, "02:04:16", 98, allChallenges);

    DocumentSnapshot addedUser =  await Firestore.instance.collection("leaderboard").document(userName).get();

    expect(addedUser.data['totalTime'], "02:04:16");
    expect(addedUser.data['totalPoints'], 98);
    expect(addedUser.data['challenges'][4.toString()]['completed'], true);
    expect(addedUser.data['challenges'][4.toString()]['photoUrl'], 'http://www.test.com');
  });
  
}