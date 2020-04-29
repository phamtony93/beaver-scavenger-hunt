import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/rules_screen.dart';  

class App extends StatelessWidget {

  static final routes = {
    '/': (context) => LoginScreen(),
    '/challenge_screen': (context) => ChallengeScreen(),
    '/rules_screen': (context) => RulesScreen(),
};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beaver Scavenger Hunt',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
        )
      ),
      routes: routes,

    );
  }
}