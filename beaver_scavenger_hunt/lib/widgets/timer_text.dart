import 'package:flutter/material.dart';
import 'dart:async';

class TimerText extends StatefulWidget {
  final Stopwatch stopWatch;

   TimerText({Key key, this.stopWatch}) : super(key: key);


  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer timer;
  
  @override
  Widget build(BuildContext context) {
    return Text((widget.stopWatch.elapsed.inHours).toString().padLeft(2, '0') + 
        ':' + (widget.stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + 
        ':' + (widget.stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0'));
  }

  _TimerTextState() {
    timer = Timer.periodic(Duration(seconds:1), runningTimer);
  }

  void runningTimer(Timer timer) {
    if(widget.stopWatch.isRunning){
      //startTimer();
      setState((){});
    }
    //setState( () {
      // so i will need to get the current time, subtract the time started, add to elapsed time
      // when begin hunt is pressed, a field is entered in the database with current time
    //   timerDisplay = (widget.stopWatch.elapsed.inHours + 2).toString().padLeft(2, '0') + 
    //     ':' + (widget.stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + 
    //     ':' + (widget.stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0');
    // });
  }

}