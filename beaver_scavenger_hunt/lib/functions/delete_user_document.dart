
// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

Future<void> deleteUserDocument(UserDetails user) async {
  Firestore.instance.collection('users').document(user.uid).delete();
}