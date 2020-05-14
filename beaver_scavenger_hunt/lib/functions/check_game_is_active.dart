// Packages
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkAdminGameIsActive(UserDetails user) async {
  DocumentSnapshot document = await Firestore.instance.collection('admins').document('${user.uid}').get();
  if (document.data == null) {
    return false;
  } else {
    return true;
  }
}