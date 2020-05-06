import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/rules_screen.dart';  
import 'styles/styles_class.dart';

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
      theme: Styles.osuTheme,
      routes: routes,
    );
  }
}
