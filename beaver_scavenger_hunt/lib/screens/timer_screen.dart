import 'package:flutter/material.dart';
//import 'dart:async';
import '../widgets/timer_text.dart';
import 'timer_screen2.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool onScreen = true;
  //String timerDisplay = '01:10:23';
  var stopWatch = Stopwatch();

  void startStopWatch() {
    setState((){
      stopWatch.start();
    });
    //startTimer();
  }

  void stopStopWatch() {
    setState((){
      stopWatch.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Timer Testing'),
          centerTitle: true,
      ),
      body: timerCount()
    );
  }

  Widget timerCount() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This screen is for testing the timer'),
          TimerText(stopWatch: stopWatch, onScreen: onScreen),
          RaisedButton(child: Text('this code will go on the begin hunt btn'),
          onPressed:() {
            startStopWatch();
          }),
          RaisedButton(child: Text('stop'),
          onPressed:() {
            stopStopWatch();
          }),
          RaisedButton(child: Text('stop numbers changing'),
          onPressed:() {
            setState( () {
              onScreen = false;
            });
          }),
          RaisedButton(child: Text('start number changing'),
          onPressed:() {
            setState( () {
              onScreen = true;
            });
          }),
          RaisedButton(child: Text('next screen'),
          onPressed:() {
            Navigator.of(context).push(MaterialPageRoute(builder:  (context) => TimerScreen2(stopWatch: stopWatch) ));
          }),
          //TimerText(stopwatch: stopWatch),
        ]
      ),
    );
  }

  // void startTimer() {
  //   Timer(Duration(seconds:1), runningTimer);
  // }

  // void runningTimer() {
  //   if(stopWatch.isRunning){
  //     startTimer();
  //   }
  //   setState( () {
  //     // so i will need to get the current time, subtract the time started, add to elapsed time
  //     // when begin hunt is pressed, a field is entered in the database with current time
  //     timerDisplay = (stopWatch.elapsed.inHours + 2).toString().padLeft(2, '0') + 
  //       ':' + (stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + 
  //       ':' + (stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0');
  //   });
  // }


}