import 'dart:io';

import 'package:flutter/material.dart';

import 'Rulebook/Rulebook.dart'; // Import Rulebook page
import 'VetCare.dart'; // Import VetCare page
import 'database_helper.dart'; // Import DatabaseHelper

class AboutMePage extends StatefulWidget {
  final Map<String, dynamic>? dogProfile;
  final String? email;
  
  const AboutMePage({Key? key, this.dogProfile, this.email}) : super(key: key);

  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  Map<String, dynamic>? dogInfo;

  @override
  void initState() {
    super.initState();
    _fetchDogInfo();
  }

  Future<void> _fetchDogInfo() async {
    try {
      Map<String, dynamic>? info = await DatabaseHelper().getLatestDogInfo();
      setState(() {
        dogInfo = info;
      });
    } catch (e) {
      debugPrint('Error fetching dog info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dogInfo == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFB900),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                'Hi, ${dogInfo?['name'] ?? 'Your Dog'}..',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Dog photo
              if (dogInfo?['image_file'] != null && File(dogInfo!['image_file']).existsSync())
                Center(
                  child: Image.file(
                    File(dogInfo!['image_file']),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Center(
                  child: const Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 16),

              // Info cards row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Breed', dogInfo?['breed'] ?? 'Unknown'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard('Age', dogInfo?['age'] ?? 'Unknown'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Weight', '${dogInfo?['weight'] ?? 'Unknown'} kg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard('Gender', dogInfo?['gender'] ?? 'Unknown'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Medical History
              _buildExpandableCard(
                'Medical History',
                Text(dogInfo?['medical_history'] ?? 'No medical history available'),
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
                        MaterialPageRoute(builder: (context) => const RulebookPage()),
                      );
                    },
                    child: _buildNavItem(Icons.book, 'Rule Book'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VetCarePage()),
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