import 'package:flutter_test/flutter_test.dart';
import '../lib/functions/upload_new_user_and_Challenges.dart';
import '../lib/models/user_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../lib/models/provider_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
    
  test('Testing Upload_New_User_And_Challenges function', () async {
      //create test vars
      String jsonExpected = await rootBundle.loadString("assets/clues_and_challenges.json");
      Map jsonMapExpected = jsonDecode(jsonExpected);
      String gameCode = "Test_Game_Code";
      //run function to add database entry
      uploadNewUserAndChallenges(user, gameCode);
      //get database results
      var ds = await Firestore.instance.collection('users').document(user.uid).get();
      Map jsonMapActual = ds.data['clue locations']['challenges'];
      String uidActual = ds.data['uid'];
      String emailActual = ds.data['email'];
      String gameCodeActual = ds.data['gameCode'];
      int incorrectCluesActual = ds.data['incorrectClues'];
      //assert expected results
      expect(jsonMapExpected, jsonMapActual);
      expect(user.uid, uidActual);
      expect(user.userEmail, emailActual);
      expect(gameCode, gameCodeActual);
      expect(0, incorrectCluesActual);
  });

  

}