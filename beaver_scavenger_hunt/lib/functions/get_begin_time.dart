// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

Future getBeginTime(UserDetails userDetails) async {
  DocumentSnapshot user =  await Firestore.instance.collection("users").document(userDetails.uid).get();
  return user.data['beginTime'];
}