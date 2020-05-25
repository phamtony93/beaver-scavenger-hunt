import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beaver_scavenger_hunt/functions/is_new_user.dart';
import 'package:beaver_scavenger_hunt/functions/upload_new_user_and_challenges.dart';
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

  test('Check function determines user is new', () {
    Future<bool> isNew = is_new_user(testUser);
    isNew.then((value) => expect(value, true));
  });

  //Add user
  String gameCode = 'gameTest123';
  uploadNewUserAndChallenges(testUser, gameCode);

  //Check user exists
  test('Check user exists', () {
    Future<DocumentSnapshot> user = Firestore.instance.collection('users').document(testUser.uid).get();
    user.then((value) => expect(value.data['uid'], testUser.uid));
  });

  test('Check function determines user is not new', () {
    Future<bool> isNew = is_new_user(testUser);
    isNew.then((value) => expect(value, false));
  });

  //Delete user
  Firestore.instance.collection('users').document(testUser.uid).delete();

  test('Check user deleted', () {
    Future<DocumentSnapshot> user = Firestore.instance.collection('users').document(testUser.uid).get();
    user.then((value) => expect(value.data, null));
  });
}