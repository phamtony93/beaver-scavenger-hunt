import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_details_model.dart';


void uploadNewAdmin(UserDetails user, String gameID) async {

  Map<String, String> jsonMap;
  //jsonMap["gameID"] = '$gameID';
  Firestore.instance.collection('admins').document(user.uid).setData({"gameID":gameID});
}