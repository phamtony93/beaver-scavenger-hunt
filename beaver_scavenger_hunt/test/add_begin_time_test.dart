// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Functions
import '../lib/functions/add_begin_time.dart';

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

    
Future getBeginTime(UserDetails userDetails) async {
  DocumentSnapshot user =  await Firestore.instance.collection("users").document(userDetails.uid).get();
  return user.data['beginTime'];
}

  test('Add Begin Time to DB', () async {
      DateTime time = addBeginTime(user);
      var retrievedTime = await getBeginTime(user);
      var diff = time.difference(retrievedTime.toDate());
      expect(diff.inHours, 0);
      expect(diff.inMinutes, 0);
      expect(diff.inSeconds, 0);
  });
  
}
