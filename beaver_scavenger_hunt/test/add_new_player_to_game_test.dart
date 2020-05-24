import 'package:beaver_scavenger_hunt/functions/add_player_to_game.dart';
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';


//Assert that player does not exist in database

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  UserDetails user = UserDetails(
      'test',
      'uidTest123',
      'usernameTest123',
      'photoTest123',
      'emailTest123'
  );

  test('Test uidTest123 user does not exist', () async {
      DocumentSnapshot player = await Firestore.instance.collection('users').document('uidTest123').get();
      expect(player.data, null);
  });

  addPlayerToGame('testCode123', user);

  test('TestuidTest123 user exists', () async {
    DocumentSnapshot player2 = await Firestore.instance.collection('users').document(user.uid).get();
    expect(player2.data['uid'], user.uid);
  });

}
