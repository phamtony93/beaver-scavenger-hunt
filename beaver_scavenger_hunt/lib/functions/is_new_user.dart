// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

Future<bool> is_new_user(UserDetails userDetails) async {
  DocumentSnapshot prevUser =  await Firestore.instance.collection("users").document(userDetails.uid).get();
  if (prevUser.data != null){
    print("user:${userDetails.uid} found");
    return false;
  }
  else{
    print("no previous user found");
    return true;
  }
}

