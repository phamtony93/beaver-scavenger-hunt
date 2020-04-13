import 'package:cloud_firestore/cloud_firestore.dart';

bool isNewUser(String uid) {
  //Does not work right. Seems to return an document reference object even document does not exist?
  var object = Firestore.instance.collection("users").document(uid);
  if (object != null) {
    return false;
  } else {
    return true;
  }
}

