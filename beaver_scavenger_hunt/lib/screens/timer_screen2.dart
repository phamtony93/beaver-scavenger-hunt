import 'package:flutter/material.dart';
//import 'dart:async';
import '../widgets/timer_text.dart';
//import 'timer_screen.dart';

class TimerScreen2 extends StatefulWidget{
  final Stopwatch stopWatch;

  TimerScreen2({Key key, this.stopWatch}) : super(key: key);

  @override
  _TimerScreen2State createState() => _TimerScreen2State();
}

class _TimerScreen2State extends State<TimerScreen2> {
  bool onScreen = true;

   void startStopWatch() {
    setState((){
      widget.stopWatch.start();
    });
    //startTimer();
  }

  void stopStopWatch() {
    setState((){
      widget.stopWatch.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPress(),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Timer Testing'),
            centerTitle: true,
        ),
        body: test()
      ),
    );
  }

  Widget test() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Text('test'),
        TimerText(stopWatch: widget.stopWatch, onScreen: onScreen),
          RaisedButton(child: Text('this code will go on the begin hunt btn'),
          onPressed:() {
            //startStopWatch();
          }),
          RaisedButton(child: Text('stop'),
          onPressed:() {
            //stopStopWatch();
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
      ]));
  }

  Future<bool> _onBackPress() {
    setState( () {
      onScreen = false;
    });
    //Navigator.pop(context);
    return Future<bool>.value(true);
  }


}