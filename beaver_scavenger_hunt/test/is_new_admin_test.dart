import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:beaver_scavenger_hunt/functions/is_new_admin.dart';
import 'package:beaver_scavenger_hunt/functions/upload_new_admin.dart';

void main() {
   TestWidgetsFlutterBinding.ensureInitialized();

   UserDetails user = UserDetails(
      'test',
      'adminTest123',
      'usernameTest123',
      'photoTest123',
      'emailTest123'
  ); 

  test('Check admin does not exist', () async {
    DocumentSnapshot admin = await Firestore.instance.collection('admins').document(user.uid).get();
    expect(admin.data, null);
  }); 

  test('Check function determines admin is new', () async {
    String isNew = await is_new_admin(user);
    expect(isNew, 'newAdmin');
  });

  //Add admin
  String gameCode = 'gameTest123';
  uploadNewAdmin(user, gameCode);

  test('Check admin exists', () async {
    DocumentSnapshot admin = await Firestore.instance.collection('admins').document(user.uid).get();
    expect(admin.data['gameID'], gameCode);
  });

  test('Check function determines admin is not new', () async {
    String isNew = await is_new_admin(user);
    expect(isNew, gameCode);
  });

  //Delete admin
  Firestore.instance.collection('admin').document(user.uid).delete();

  test('Check admin deleted', () async{
    DocumentSnapshot admin = await Firestore.instance.collection('admin').document(user.uid).get();
    expect(admin.data, null);
  });
}

