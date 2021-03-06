// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// Models
import '../models/user_details_model.dart';


void uploadNewUserAndChallenges(UserDetails user, String gameCode) async {

  String json = await rootBundle.loadString("assets/clues_and_challenges.json");
  Map jsonMap = jsonDecode(json);
  jsonMap["uid"] = '${user.uid}';
  jsonMap["email"] = '${user.userEmail}';
  jsonMap["gameCode"] = '$gameCode';
  jsonMap["incorrectClues"] = 0;
  await Firestore.instance.collection('users').document(user.uid).setData(jsonMap);
}