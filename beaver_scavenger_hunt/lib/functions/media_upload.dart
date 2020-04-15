import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadMedia(String path) async {
  StorageReference storageReference = 
  FirebaseStorage.instance.ref().child(path);
  StorageUploadTask uploadTask = storageReference.putFile(File(path));
  await uploadTask.onComplete;
  return await storageReference.getDownloadURL();
}