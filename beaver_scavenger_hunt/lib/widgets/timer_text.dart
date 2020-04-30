import 'package:flutter/material.dart';
import 'dart:async';

class TimerText extends StatefulWidget {
  final Stopwatch stopWatch;
  final bool onScreen;

   TimerText({Key key, this.stopWatch, this.onScreen}) : super(key: key);


  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer timer;
  
  @override
  Widget build(BuildContext context) {
    return Text((widget.stopWatch.elapsed.inHours).toString().padLeft(2, '0') + 
        ':' + (widget.stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + 
        ':' + (widget.stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0'),
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