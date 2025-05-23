import 'package:flutter/material.dart';

import 'WelcomeScreen.dart';
import 'auth/login_page.dart';
import 'auth/signup_page.dart';
import 'performance_page.dart'; // <-- ADD THIS

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doggo App',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/performance': (context) => PerformancePage(), // <-- ADD THIS
      },
    );
  }
}
