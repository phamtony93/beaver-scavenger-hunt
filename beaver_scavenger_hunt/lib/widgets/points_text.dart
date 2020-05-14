// Packages
import 'package:flutter/material.dart';
import 'dart:async';

class PointsText extends StatefulWidget {
  final int points;
  final Stopwatch stopWatch;
  final bool onScreen;
  final Duration difference;
  //final UserDetails userDetails;

   PointsText({Key key, this.points, this.stopWatch, this.onScreen, this.difference}) : super(key: key);


  @override
  _PointsTextState createState() => _PointsTextState();
}

class _PointsTextState extends State<PointsText> {
  Timer timer;
 
  @override
  Widget build(BuildContext context) {
    return Text((((((widget.stopWatch.elapsed.inSeconds) + (widget.difference.inSeconds))/60).floor()*-1) + widget.points).toString(),
        style: TextStyle(fontSize: 24));
  }

  _PointsTextState() {
    timer = Timer.periodic(Duration(seconds:1), runningTimer);
  }

  void runningTimer(Timer timer) {
    if(widget.stopWatch.isRunning && widget.onScreen == true){
      //startTimer();
      setState((){});
    }
  }
  

}