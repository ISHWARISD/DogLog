import 'package:flutter/material.dart';

import '../AboutMe.dart';
import '../VetCare.dart';
import 'Diet_Nutrition.dart'; // Import the Diet_Nutrition page
import 'Fun.dart';
import 'Health_Hygiene.dart';
import 'MedicalCare.dart';
import 'Rulebook.dart';

class GuidancePage extends StatelessWidget {
  GuidancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB74D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with Paw Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pets,
                        size: 24,
                        color: Colors.black87,
                      ),
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
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Because every Dog deserves Best!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Titles
                const Text(
                  'Where Do You Need Guidance?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick a Topic to Explore!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Dog Image
                Image.asset(
                  'assets/dogsearch.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // Grid of Topics
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7, // Keeping the same aspect ratio
                  ),
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    return _buildTopicCard(
                      context, // Pass context for navigation
                      title: _topics[index]['title']!,
                      imagePath: _topics[index]['imagePath']!,
                      onTap: () {
                        // Add navigation based on the topic
                        if (_topics[index]['title'] == 'Diet & Nutrition') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DietNutritionPage(),
                            ),
                          );
                        } else if (_topics[index]['title'] == 'Health & Hygiene') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HealthHygienePage(),
                            ),
                          );
                        } else if (_topics[index]['title'] == 'Vaccination & Medical Care') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicalCarePage(),
                            ),
                          );
                        } else if (_topics[index]['title'] == 'Fun & Socialization') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FunPage(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 30), // More spacing to avoid bottom overflow

                // Bottom Navigation
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFFFB74D),
                  child: Row(
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutMePage()),
                          );
                        },
                        child: _buildNavItem(Icons.pets, 'About Me'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> _topics = [
    {
      'title': 'Diet & Nutrition',
      'imagePath': 'assets/dogfood.jpg',
    },
    {
      'title': 'Health & Hygiene',
      'imagePath': 'assets/doghygiene.jpg',
    },
    {
      'title': 'Vaccination & Medical Care',
      'imagePath': 'assets/dogvaccination.jpg',
    },
    {
      'title': 'Fun & Socialization',
      'imagePath': 'assets/dogfun.jpg',
    },
  ];

  Widget _buildTopicCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Larger image taking most of the card space
            Expanded(
              flex: 7, // Allocate 70% of space to image
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Title in a simple container at the bottom
            Expanded(
              flex: 3, // Allocate 30% of space to title
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0), // Light orange background
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
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