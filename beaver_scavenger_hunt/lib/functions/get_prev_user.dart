// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

Future<Map<String, dynamic>> get_prev_user(UserDetails userDetails) async {
  DocumentSnapshot prevUser =  await Firestore.instance.collection("users").document(userDetails.uid).get();
  return prevUser.data;
}