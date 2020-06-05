import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beaver_scavenger_hunt/functions/check_game_is_active.dart';
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

   UserDetails user = UserDetails(
      'test',
      'adminTest123',
      'usernameTest123',
      'photoTest123',
      'emailTest123'
  ); 

  test('Check admin does not exist', () {
    Future<DocumentSnapshot> admin = Firestore.instance.collection('admin').document(user.uid).get();
    admin.then((value) {
      expect(value.data, null);
    });
  });

  //Add gameTest123
  String gameCode = 'gameTest123';
  Firestore.instance.collection('admin').document(user.uid).setData({'gameID': gameCode});

  test('Check admin game is active', () {
    Future<bool> isActive = checkAdminGameIsActive(user);
    isActive.then((value) => expect(value, true));
  });

  //Remove admin and end game
  Firestore.instance.collection('admins').document(user.uid).delete();

  test('Check admin game is not active', () {
    Future<bool> isActive = checkAdminGameIsActive(user);
    isActive.then((value) => expect(value, false));
  });

   test('Check admin deleted', () {
    Future<DocumentSnapshot> admin = Firestore.instance.collection('admin').document(user.uid).get();
    admin.then((value) {
      expect(value.data, null);
    });
  }); 

}