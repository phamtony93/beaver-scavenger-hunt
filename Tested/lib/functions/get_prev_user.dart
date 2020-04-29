import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> get_prev_user(String uid) async {
  DocumentSnapshot prevUser =  await Firestore.instance.collection("users").document(uid).get();
  return prevUser.data;
}