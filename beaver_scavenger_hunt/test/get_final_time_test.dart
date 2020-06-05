// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Functions
import '../lib/functions/get_final_time.dart';

// Models
import '../lib/models/user_details_model.dart';
import '../lib/models/provider_details_model.dart';

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

  test('Get Final Time 1', () async {
      DateTime beginTime = DateTime.parse("2020-05-25 12:13:00Z");
      DateTime endTime = DateTime.parse("2020-05-25 20:18:04Z");
      String finalTime = getFinalTime(beginTime, endTime);
      expect(finalTime, "08:05:04");
  });

  test('Get Final Time 2', () async {
      DateTime beginTime = DateTime.parse("2020-05-25 12:13:00Z");
      DateTime endTime = DateTime.parse("2020-05-26 20:18:04Z");
      String finalTime = getFinalTime(beginTime, endTime);
      expect(finalTime, "32:05:04");
  });
  
}