import 'package:flutter/material.dart';

import '../AboutMe.dart';
import '../VetCare.dart';
import 'Rulebook.dart';

class GuidancePage extends StatelessWidget {
  GuidancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB74D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with Paw Icon
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.pets,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                SizedBox(height: 20),

                // Titles
                Text(
                  'Where Do You Need Guidance?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Pick a Topic to Explore!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Dog Image
                Image.asset(
                  'assets/dogsearch.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24),

                // Grid of Topics
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7, // Adjusted for better text visibility
                  ),
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    return _buildTopicCard(
                      title: _topics[index]['title']!,
                      description: _topics[index]['description']!,
                      imagePath: _topics[index]['imagePath']!,
                      onTap: () {},
                    );
                  },
                ),

                SizedBox(height: 30), // More spacing to avoid bottom overflow

                // Bottom Navigation
                Container(
                  padding: EdgeInsets.all(16),
                  color: Color(0xFFFFB74D),
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
      'description': 'Fuel your dog with the right balance of nutrients....',
      'imagePath': 'assets/dogfood.jpg',
    },
    {
      'title': 'Health & Hygiene',
      'description': 'Keep your pup in top shape with proper grooming,...',
      'imagePath': 'assets/doghygiene.jpg',
    },
    {
      'title': 'Vaccination & Medical Care',
      'description': 'Protect your pup with core and non-core vaccinations, ensuring they stay safe from serious diseases.',
      'imagePath': 'assets/dogvaccination.jpg',
    },
    {
      'title': 'Fun & Socialization',
      'description': 'Get your pup out there! Explore dog parks, hikes, and fun activities together.',
      'imagePath': 'assets/dogfun.jpg',
    },
  ];

  Widget _buildTopicCard({
    required String title,
    required String description,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (with fixed height)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 100, // Reduced height to prioritize text
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Text Content
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 3, // Limit to 3 lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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