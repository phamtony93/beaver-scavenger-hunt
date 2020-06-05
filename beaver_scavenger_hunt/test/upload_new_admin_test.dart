import 'package:flutter_test/flutter_test.dart';
import '../lib/functions/upload_new_admin.dart';
import '../lib/models/user_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../lib/models/provider_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
    TestWidgetsFlutterBinding.ensureInitialized();
      // AUTHENTICATE ADMIN USER
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
    
  test('Testing upload_new_admin function', () async {
      //create test vars
      String gameCode = "test_admin_gameCode";
      
      //run function to add database entry
      uploadNewAdmin(user, gameCode);
      
      //get database results
      var ds1 = await Firestore.instance.collection('admins').document(user.uid).get();
      String gameCodeActual = ds1.data['gameID'];
      String uidActual = ds1.documentID;
      var ds2 = await Firestore.instance.collection('games').document(gameCode).get();
      String openOrNotActual = ds2.data['open'];
      
      //assert expected results
      expect(user.uid, uidActual);
      expect(gameCode, gameCodeActual);
      expect(true, openOrNotActual);
  });
}