// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

Future<Map<String, dynamic>> get_prev_admin(UserDetails userDetails) async {
  DocumentSnapshot prevAdmin =  await Firestore.instance.collection("admins").document("${userDetails.uid}").get();
  return prevAdmin.data;
}