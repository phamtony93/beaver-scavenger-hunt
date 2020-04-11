import 'package:cloud_firestore/cloud_firestore.dart';

bool is_new_user(String uid) {
  var object = Firestore.instance.collection("users").getDocuments().then((data) {
    print('data is: ');
    print(data);
  });

  print(object);

  return false;
}

