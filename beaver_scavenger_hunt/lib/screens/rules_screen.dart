import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hunt Rules'),
      ),
      body: SafeArea(
        child: Text('''
                      1. This is a timed hunt - your time begins as soon as you hit the "Begin Hunt" button
                      2. There are 10 scavenger hunt clues and answers.
                      3. Each correct answer will lead you to a GPS location.
                      4. In order to receive the next clue, you will need to be within x units of each GPS location.
                      5. Along with clues, there are some tasks/challenges to complete.
                      6. After 1 incorrect guess to a clue, 5 minutes will be added to your time for each subsequent incorrect guess - so answer carefully!
                      7. Your time ends as soon as you correctly answer the final question.
                      8. Every team that finishes will win a prize, and the team with the shortest time will win the grand prize.
                      9. You may view rules or previous answered clues at any time.
                      10. Good luck and have fun!''')
      )
    );
  }
}