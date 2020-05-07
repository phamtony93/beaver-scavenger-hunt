import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> is_new_admin(String adminID) async {
  DocumentSnapshot prevAdmin =  await Firestore.instance.collection("admins").document(adminID).get();
  if (prevAdmin.data != null){
    print("Admin:$adminID found");
    return false;
  }
  else{
    print("no previous admin found");
    return true;
  }
}