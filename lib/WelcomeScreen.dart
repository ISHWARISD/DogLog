import 'package:flutter/material.dart';

import 'Input_Pages/UserInputPage1.dart'; // Import UserInputPage1

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserInputPage1()),
            );
          },
          child: Text("Get Started"),
        ),
      ),
    );
  }
}