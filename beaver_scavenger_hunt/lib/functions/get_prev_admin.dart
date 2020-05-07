import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> get_prev_admin(String uid) async {
  print(uid);
  DocumentSnapshot prevAdmin =  await Firestore.instance.collection("admins").document("$uid").get();
  return prevAdmin.data;
}