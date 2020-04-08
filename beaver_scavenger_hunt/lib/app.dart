import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
// import 'screens/rules_screen.dart';

class App extends StatelessWidget {
  static final routes = {
    '/': (context) => LoginScreen(),
    // 'rules_screen': (context) => RulesScreen(),
};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beaver Scavenger Hunt',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.grey,
        )
      ),
      routes: routes,
    );
  }
}

