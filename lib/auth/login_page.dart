import 'package:flutter/material.dart';

import '../AboutMe.dart'; // Import the AboutMe page
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;
  
  // Quotes about dogs and their owners
  final List<String> dogQuotes = [
    "When I needed a hand, I found your paw.",
    "Happiness starts with a wet nose and ends with a tail.",
    "The best therapist has fur and four legs.",
    "I look normal but believe me I talk with my Dog, and he talks back."
  ];

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    
    String email = emailController.text;
    String password = passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty"))
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    bool success = await apiService.loginUser(email, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      // Navigate to AboutMe page instead of '/home'
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AboutMePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Check your credentials."))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Select a random quote
    final randomQuote = dogQuotes[DateTime.now().microsecond % dogQuotes.length];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top curved container with image
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Color(0xFFFFB74D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dog and owner image placeholder
                    Positioned(
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 400,
                          height: 300,
                          color: Colors.white.withOpacity(0.3),
                          child: Image.asset(
                            'assets/login.jpg', // Replace with your actual asset
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      child: Text(
                        "Welcome Back!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Quote section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Color(0xFFFFB74D),
                      size: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        randomQuote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Login form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Email field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Color(0xFFFFB74D)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xFFFFB74D)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xFFFFB74D), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFFFFB74D)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    
                    // Password field
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Color(0xFFFFB74D)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xFFFFB74D), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFFFB74D)),
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFFFFB74D)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Login button
                    ElevatedButton(
                      onPressed: isLoading ? null : () => login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB74D),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Color(0xFFFFB74D).withOpacity(0.5),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 30),
                    
                    // Sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFFFFB74D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Dog paw icon at bottom
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Icon(
                          Icons.pets,
                          color: Color(0xFFFFB74D),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}