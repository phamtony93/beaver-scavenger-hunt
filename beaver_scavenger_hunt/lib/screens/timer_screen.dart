import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Timer Testing'),
          centerTitle: true,
      ),
      body: timer()
    );
  }

  Widget timer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This screen is for testing the timer'),
          Text('00:00:00')
        ]
      ),
    );
  }
}