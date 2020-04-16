import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


void uploadNewUserAndChallenges(String uid) async {

  String json = await rootBundle.loadString("assets/clues_and_challenges.json");
  Map jsonMap = jsonDecode(json);
  Firestore.instance.collection('users').document(uid).setData(jsonMap);
}