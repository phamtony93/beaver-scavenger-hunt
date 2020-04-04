import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class App extends StatelessWidget {
  static final routes = {
    '/': (context) => LoginScreen()
};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beaver Scavenger Hunt',
      routes: routes,
    );
  }
}

