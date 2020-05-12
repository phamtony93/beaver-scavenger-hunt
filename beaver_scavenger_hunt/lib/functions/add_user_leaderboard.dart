// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// Models
import '../models/challenge_model.dart';
import '../models/user_details_model.dart';


Future<void> addUserLeaderboard(UserDetails user, String time, int points, List<Challenge> allChallenges) async {
  int num = 1;

  DocumentSnapshot temp =  await Firestore.instance.collection("users").document(user.uid).get();
  String gameID =  temp.data['gameCode'];

  print('gets here');
  String userName = user.userEmail + '_' + gameID;
  print('does not get here');
  print(userName);
  String json = await rootBundle.loadString("assets/clues_and_challenges.json");
  Map jsonMap = jsonDecode(json);
  jsonMap["totalTime"] = time;
  jsonMap["totalPoints"] = points;
  jsonMap["completedChallenges"] = null;
  jsonMap["confirmedChallenges"] = null;
  Firestore.instance.collection('leaderboard').document(userName).setData(jsonMap);

  for (int i = 0; i < 11; i++) {
    Firestore.instance.collection('leaderboard').document(userName).updateData({
      'challenges.$num.photoUrl': allChallenges[num-1].photoUrl, 
      'challenges.$num.completed' : allChallenges[num-1].completed,
    });
  }


}