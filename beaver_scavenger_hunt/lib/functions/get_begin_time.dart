// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

Future getBeginTime(String uid) async {
  DocumentSnapshot user =  await Firestore.instance.collection("users").document(uid).get();
  return user.data['beginTime'];
}