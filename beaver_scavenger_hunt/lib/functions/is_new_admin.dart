// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
//Models
import '../models/user_details_model.dart';

Future<String> is_new_admin(UserDetails userDetails) async {
  DocumentSnapshot prevUser =  await Firestore.instance.collection("admins").document(userDetails.uid).get();
  if (prevUser.data != null){
    print("user:${userDetails.uid} found");
    return prevUser.data['gameID'];
  }
  else{
    print("no previous user found");
    return 'newAdmin';
  }
}

