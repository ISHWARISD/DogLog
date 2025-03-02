import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'UserInputPage3.dart'; // Import UserInputPage3

class UserInputPage2 extends StatefulWidget {
  final String name;
  final String breed;
  final String age;

  UserInputPage2({required this.name, required this.breed, required this.age});

  @override
  _UserInputPage2State createState() => _UserInputPage2State();
}

class _UserInputPage2State extends State<UserInputPage2> {
  final _formKey = GlobalKey<FormState>();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  @override
  void dispose() {
    _genderController.dispose();
    _weightController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  Future<void> _saveDogInfo() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'name': widget.name,
        'breed': widget.breed,
        'age': widget.age,
        'gender': _genderController.text,
        'weight': _weightController.text,
        'medical_history': _medicalHistoryController.text,
      };
      await DatabaseHelper().insertDogInfo(row);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInputPage3(
            name: widget.name,
            breed: widget.breed,
            age: widget.age,
            gender: _genderController.text,
            weight: _weightController.text,
            medicalHistory: _medicalHistoryController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pawfile Setup'),
        backgroundColor: Color(0xFFFFB300), // Set the same background color as WelcomeScreen
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Yellow background with dog image
            Container(
              color: const Color(0xFFFFB300),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55, // Increase the height to 55% of screen height
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/dog2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      color: const Color.fromARGB(255, 255, 179, 0).withOpacity(0.5),
                      child: Text(
                        "Your Dog's Story Continues!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender field
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _genderController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s gender';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "What's your dog's gender?",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFFFB300)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                    ),
                    const SizedBox(height: 24),
                    
                    // Weight field
                    const Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _weightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s weight';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "What's your dog's weight?",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFFFB300)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    // Medical History field
                    const Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _medicalHistoryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s medical history';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Any medical history?",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFFFB300)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 32),
                    
                    // Save & Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveDogInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 230, 121, 43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save & Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}