import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addBeginTime(DateTime beginTime, UserDetails userDetails) {
  beginTime = DateTime.now();
  Firestore.instance.collection('users').document(userDetails.uid).updateData({
  'beginTime': beginTime});
}