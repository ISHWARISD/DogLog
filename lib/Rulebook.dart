import 'package:flutter/material.dart';

import 'AboutMe.dart'; // Import AboutMe page
import 'VetCare.dart'; // Import VetCare page

class RulebookPage extends StatelessWidget {
  const RulebookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFFFB74D), // Orange background
        body: SafeArea(
          child: Column(
            children: [
              // Logo and Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.pets, size: 24),
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
                          ),
                        ),
                        Text(
                          'Because every Dog deserves Best!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          'The Ultimate Dog Rule Book',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),

                        // Dog Grid
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown, width: 2),
                            color: Colors.white,
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            children: List.generate(9, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: _getDogBackgroundColor(index),
                                ),
                                child: CustomPaint(
                                  painter: DogIconPainter(index),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Subtitle
                        Text(
                          'A Complete Guide to Raising a Happy & Healthy Dog',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),

                        // Jump In Button - Updated styling
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Jump In!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          MaterialPageRoute(builder: (context) => AboutMePage(
                            name: 'Millie',
                            breed: 'Golden Retriever',
                            age: '1yr',
                            gender: 'Female',
                            weight: '30 kg',
                            medicalHistory: 'None',
                            imageFile: null,
                          )),
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
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getDogBackgroundColor(int index) {
    final colors = [
      Color(0xFFFFF3E0), // Beige
      Color(0xFF8D6E63), // Brown
      Color(0xFFFFB74D), // Orange
      Color(0xFFFFB74D), // Orange
      Color(0xFF8D6E63), // Brown
      Color(0xFFFFF3E0), // Beige
      Color(0xFFFFF3E0), // Beige
      Color(0xFF8D6E63), // Brown
      Color(0xFFFFB74D), // Orange
    ];
    return colors[index];
  }
}

class DogIconPainter extends CustomPainter {
  final int dogIndex;

  DogIconPainter(this.dogIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void main() {
  runApp(MaterialApp(
    home: RulebookPage(),
  ));
}