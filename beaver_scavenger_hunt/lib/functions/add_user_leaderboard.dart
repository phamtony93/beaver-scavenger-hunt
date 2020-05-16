// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// Models
import '../models/challenge_model.dart';
import '../models/user_details_model.dart';


Future<void> addUserLeaderboard(UserDetails user, String time, int points, List<Challenge> allChallenges) async {

  DocumentSnapshot temp =  await Firestore.instance.collection("users").document(user.uid).get();
  String gameID =  temp.data['gameCode'];

  print('gets here');
  String userName = user.userEmail + '_' + gameID;
  print('does not get here');
  print(userName);
  String json = await rootBundle.loadString("assets/challenges.json");
  Map jsonMap = jsonDecode(json);
  jsonMap["totalTime"] = time;
  jsonMap["totalPoints"] = points;
  
  int count = 0;
  for (int i = 0; i < allChallenges.length; i++){
    if (allChallenges[i].completed == true)
    count ++;
  }
  jsonMap["completedChallenges"] = count;
  jsonMap["confirmedChallenges"] = 0;
  jsonMap["deniedChallenges"] = 0;
  jsonMap["uid"] = user.uid;
  
  Firestore.instance.collection('leaderboard').document(userName).setData(jsonMap);

  for (int i = 0; i < 10; i++) {
    await Firestore.instance.collection('leaderboard').document(userName).updateData({
      'challenges.${i+1}.photoUrl': allChallenges[i].photoUrl, 
      'challenges.${i+1}.completed' : allChallenges[i].completed,
    });
  }


}