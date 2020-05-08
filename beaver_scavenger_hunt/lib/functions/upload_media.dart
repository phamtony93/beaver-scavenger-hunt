// Packages
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadMedia(String path,String fileName) async {
  StorageReference storageReference = 
  FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask uploadTask = storageReference.putFile(File(path));
  await uploadTask.onComplete;
  return await storageReference.getDownloadURL();
}