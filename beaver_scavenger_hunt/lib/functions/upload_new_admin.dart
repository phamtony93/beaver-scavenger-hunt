import 'package:cloud_firestore/cloud_firestore.dart';

void uploadNewAdmin(String uid, String gameCode) async {
  await Firestore.instance.collection('admins').document(uid).setData({'gameID': gameCode});
<<<<<<< HEAD
=======
  await Firestore.instance.collection('games').document(gameCode).setData({});
>>>>>>> seawellj_branch
}