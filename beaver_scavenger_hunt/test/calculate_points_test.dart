// Packages
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:beaver_scavenger_hunt/models/user_details_model.dart';

// Functions
import '../lib/functions/calculate_points.dart';
import '../lib/functions/get_prev_user.dart';

// Models
import '../lib/models/provider_details_model.dart';
import '../lib/models/challenge_model.dart';
import '../lib/models/clue_location_model.dart';
import '../lib/models/user_details_model.dart';

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
    
  test('Calculate Points 1', () async {
    int incorrectClues = 3;
    int actualPoints = calculatePoints(allLocations, allChallenges, incorrectClues);
    int expectedPoints = -15;
    expect(actualPoints, expectedPoints);
  });

  test('Calculate Points 2', () async {
    int incorrectClues = 1;
    allLocations[0].solved = true;
    allLocations[9].solved = true;

    int actualPoints = calculatePoints(allLocations, allChallenges, incorrectClues);
    int expectedPoints = 15;
    expect(actualPoints, expectedPoints);
  });

  test('Calculate Points 3', () async {
    int incorrectClues = 2;
    allLocations[0].solved = true;
    allLocations[9].solved = true;
    allChallenges[0].completed = true;
    allChallenges[1].completed = true;
    allChallenges[2].completed = true;


    int actualPoints = calculatePoints(allLocations, allChallenges, incorrectClues);
    int expectedPoints = 25;
    expect(actualPoints, expectedPoints);
  });
  
}