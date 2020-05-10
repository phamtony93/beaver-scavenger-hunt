// Packages
import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int addPoints(UserDetails userDetails, int points) {
  Firestore.instance.collection('users').document(userDetails.uid).updateData({
  'points': points});
  return points;
}