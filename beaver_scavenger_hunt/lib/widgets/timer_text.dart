// Packages
import 'package:flutter/material.dart';
import 'dart:async';

class TimerText extends StatefulWidget {
  final Stopwatch stopWatch;
  final bool onScreen;
  final Duration difference;
  //final UserDetails userDetails;

   TimerText({Key key, this.stopWatch, this.onScreen, this.difference}) : super(key: key);


  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer timer;
 
  @override
  Widget build(BuildContext context) {  
    
    return Text((((widget.stopWatch.elapsed.inSeconds) + (widget.difference.inSeconds))/3600).floor().toString().padLeft(2, '0') + 
        ':' + ((((widget.stopWatch.elapsed.inSeconds) + (widget.difference.inSeconds))/60).floor()%60).toString().padLeft(2, '0') + 
        ':' + (((widget.stopWatch.elapsed.inSeconds) + (widget.difference.inSeconds))%60).toString().padLeft(2, '0'),
        style: TextStyle(fontSize: 24));
  }

  _TimerTextState() {
    timer = Timer.periodic(Duration(seconds:1), runningTimer);
  }

  void runningTimer(Timer timer) {
    if(widget.stopWatch.isRunning && widget.onScreen == true){
      //startTimer();
      setState((){});
    }
  }
  

}