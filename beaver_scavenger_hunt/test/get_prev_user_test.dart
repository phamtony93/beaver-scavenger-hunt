import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beaver_scavenger_hunt/functions/get_prev_user.dart';
import 'package:beaver_scavenger_hunt/functions/upload_new_user_and_challenges.dart';
import 'package:beaver_scavenger_hunt/functions/delete_user_document.dart';
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';

void main() {
   TestWidgetsFlutterBinding.ensureInitialized();

   UserDetails testUser = UserDetails(
      'test',
      'userTest123',
      'usernameTest123',
      'photoTest123',
      'emailTest123'
  ); 

  //Check user does not exist
  test('Check user does not exist', () {
    Future<DocumentSnapshot> user = Firestore.instance.collection('users').document(testUser.uid).get();
    user.then((value) => expect(value.data, null));
  });

  //Add user
  String gameCode = 'gameTest123';
  uploadNewUserAndChallenges(testUser, gameCode);

  //Get user
  test('Check function retrieves user data', () {
    Future<Map<String, dynamic>> user = get_prev_user(testUser);
    user.then((value) => expect(value['uid'], testUser.uid));
  });

  //Delete user
  deleteUserDocument(testUser);

  test('Check user deleted', () {
    Future<DocumentSnapshot> user = Firestore.instance.collection('users').document(testUser.uid).get();
    user.then((value) => expect(value.data, null));
  });
}