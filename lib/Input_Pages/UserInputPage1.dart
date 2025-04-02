import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'UserInputPage2.dart'; // Import UserInputPage2

class UserInputPage1 extends StatefulWidget {
  final String email; // Accept email as a parameter

  UserInputPage1({required this.email}); // Constructor to accept email

  @override
  _UserInputPage1State createState() => _UserInputPage1State();
}

class _UserInputPage1State extends State<UserInputPage1> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveDogInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create the data to be saved
        Map<String, dynamic> row = {
          'name': _nameController.text,
          'breed': _breedController.text,
          'age': _ageController.text,
          'email': widget.email, // Save the email with the dog info
        };
        
        // Insert data into database
        final dbHelper = DatabaseHelper.instance; // Use singleton instance if available
        await dbHelper.insertDogInfo(row);
        
        // Navigate to the next page after successful database operation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInputPage2(
              name: _nameController.text,
              breed: _breedController.text,
              age: _ageController.text,
            ),
          ),
        );
      } catch (e) {
        // Handle any errors that might occur during database operations
        print('Error saving dog info: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save information. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pawfile Setup'),
        backgroundColor: Color(0xFFFFB300),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Yellow background with dog image
            Container(
              color: const Color(0xFFFFB300),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/dog1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      color: const Color.fromARGB(255, 255, 179, 0).withOpacity(0.5),
                      child: Text(
                        "Your Dog's Story Starts Here!",
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
                    // Name field
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "What's your dog name?",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                    ),
                    const SizedBox(height: 24),

                    // Breed field
                    const Text(
                      'Breed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _breedController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s breed';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Tell Us About Their Breed!",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                    ),
                    const SizedBox(height: 24),

                    // Age field
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dog\'s age';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "How Old Is Your Furry Friend?",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      cursorColor: Color(0xFFFFB300),
                      keyboardType: TextInputType.number,
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