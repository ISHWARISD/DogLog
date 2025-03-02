import 'package:flutter/material.dart';

import '../Photopage.dart'; // Import DogPhotoPage
import '../database_helper.dart';

class UserInputPage3 extends StatefulWidget {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String weight;
  final String medicalHistory;

  UserInputPage3({
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.medicalHistory,
  });

  @override
  _UserInputPage3State createState() => _UserInputPage3State();
}

class _UserInputPage3State extends State<UserInputPage3> {
  final _formKey = GlobalKey<FormState>();
  final _vaccinationController = TextEditingController();
  final _vaccinationDateController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  @override
  void dispose() {
    _vaccinationController.dispose();
    _vaccinationDateController.dispose();
    _nextDueDateController.dispose();
    super.dispose();
  }

  Future<void> _saveVaccinationInfo() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'name': widget.name,
        'breed': widget.breed,
        'age': widget.age,
        'gender': widget.gender,
        'weight': widget.weight,
        'medical_history': widget.medicalHistory,
        'vaccination': _vaccinationController.text,
        'vaccination_date': _vaccinationDateController.text,
        'next_due_date': _nextDueDateController.text,
      };
      await DatabaseHelper().insertDogInfo(row);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DogPhotoPage(
            name: widget.name,
            breed: widget.breed,
            age: widget.age,
            gender: widget.gender,
            weight: widget.weight,
            medicalHistory: widget.medicalHistory,
            vaccinationRecords: [
              {
                'name': _vaccinationController.text,
                'date': _vaccinationDateController.text,
              },
            ],
            nextDueDate: _nextDueDateController.text,
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
                      'assets/dog3.jpg',
                      fit: BoxFit.cover,
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
                    // Vaccination field
                    const Text(
                      'Vaccination',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _vaccinationController,
                      decoration: InputDecoration(
                        hintText: "Which Vaccine did they get?",
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
                    const SizedBox(height: 24),
                    
                    // Vaccination Date field
                    const Text(
                      'Vaccination Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _vaccinationDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the date of Vaccination';
                        }
                        final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        if (!dateRegex.hasMatch(value)) {
                          return 'Please enter a valid date (DD/MM/YYYY)';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY",
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
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 24),
                    
                    // Next Due Date field
                    const Text(
                      'Next Due Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nextDueDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the next due date';
                        }
                        final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                        if (!dateRegex.hasMatch(value)) {
                          return 'Please enter a valid date (DD/MM/YYYY)';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "When is the next dose?",
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
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 32),
                    
                    // Skip button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the next page without saving
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DogPhotoPage(
                                name: widget.name,
                                breed: widget.breed,
                                age: widget.age,
                                gender: widget.gender,
                                weight: widget.weight,
                                medicalHistory: widget.medicalHistory,
                                vaccinationRecords: [],
                                nextDueDate: '',
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Save & Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveVaccinationInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00), // Orange button
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