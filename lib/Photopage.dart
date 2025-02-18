import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'AboutMe.dart'; // Import AboutMe page

class DogPhotoPage extends StatefulWidget {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String weight;
  final String medicalHistory;
  final List<Map<String, String>> vaccinationRecords;
  final String nextDueDate;

  const DogPhotoPage({
    Key? key,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.medicalHistory,
    required this.vaccinationRecords,
    required this.nextDueDate,
  }) : super(key: key);

  @override
  State<DogPhotoPage> createState() => _DogPhotoPageState();
}

class _DogPhotoPageState extends State<DogPhotoPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pawfile Setup - Photo'),
        backgroundColor: Color(0xFFFFB300), // Set the same background color as WelcomeScreen
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display area for sample or picked image
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB900), // Yellow background
              ),
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/dog4.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
            
            // Photo upload section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo text and icon
                  Row(
                    children: [
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.upload_file,
                            size: 24,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Subtitle text
                  Text(
                    "Let's See That Cute Face!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Save & Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutMePage(
                              name: widget.name,
                              breed: widget.breed,
                              age: widget.age,
                              gender: widget.gender,
                              weight: widget.weight,
                              medicalHistory: widget.medicalHistory,
                            ),
                          ),
                        );
                      },
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
          ],
        ),
      ),
    );
  }
}