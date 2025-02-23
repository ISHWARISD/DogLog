import 'dart:io';

import 'package:flutter/material.dart';

import 'Rulebook/Rulebook.dart'; // Import Rulebook page
import 'VetCare.dart'; // Import VetCare page

class AboutMePage extends StatelessWidget {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String weight;
  final String medicalHistory;
  final File? imageFile;

  AboutMePage({
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.medicalHistory,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB900),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and tagline
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.pets, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'DogLog',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Because every Dog deserves Best!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dog name
              Text(
                'Hi, $name..',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Dog photo
              if (imageFile != null)
                Center(
                  child: Image.file(
                    imageFile!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),

              // Info cards row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Breed', breed),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard('Age', age),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Weight', '$weight kg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard('Gender', gender),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Medical History
              _buildExpandableCard(
                'Medical History',
                Text(medicalHistory),
              ),
              const SizedBox(height: 16),

              const Spacer(),

              // Bottom Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RulebookPage()),
                      );
                    },
                    child: _buildNavItem(Icons.book, 'Rule Book'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VetCarePage()),
                      );
                    },
                    child: _buildNavItem(Icons.home, 'Vet Care'),
                  ),
                  _buildNavItem(Icons.pets, 'About Me'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(String title, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}