// Packages
//import 'package:beaver_scavenger_hunt/models/user_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Models
import '../models/user_details_model.dart';

DateTime addBeginTime(UserDetails userDetails) {
  DateTime beginTime = DateTime.now();
  Firestore.instance.collection('users').document(userDetails.uid).updateData({
  'beginTime': beginTime});
  return beginTime;
}