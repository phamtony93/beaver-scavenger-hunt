import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreen createState() => _ChallengeScreen();
}

class _ChallengeScreen extends State<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
      )
      // body: StreamBuilder(
      //   stream: ,
      // )
    );
  }
}