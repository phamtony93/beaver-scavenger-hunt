import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addEndTime(UserDetails userDetails) {
  DateTime endTime = DateTime.now();
  Firestore.instance.collection('users').document(userDetails.uid).updateData({
  'endTime': endTime});
}