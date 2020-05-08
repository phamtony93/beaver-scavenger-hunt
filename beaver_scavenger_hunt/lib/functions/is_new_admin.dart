// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> is_new_admin(String uid) async {
  DocumentSnapshot prevUser =  await Firestore.instance.collection("admins").document(uid).get();
  if (prevUser.data != null){
    print("user:$uid found");
    return prevUser.data['gameID'];
  }
  else{
    print("no previous user found");
    return 'newAdmin';
  }
}

