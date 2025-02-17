import 'package:flutter/material.dart';

import 'UserInputPage1.dart'; // Import UserInputPage1

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB300), // Yellow-orange background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            'Welcome\nto\nDogLog!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFFFFC107), // Slightly darker yellow
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                top: -30,
                child: Image.asset(
                  'assets/dog.png',
                  width: 200,
                  height: 300,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Because Every Dog Deserves Best!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInputPage1()), // Navigate to UserInputPage1
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFB300),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Color(0xFFFFB300)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}