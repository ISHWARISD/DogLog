import 'package:flutter/material.dart';

class VetCarePage extends StatelessWidget {
  const VetCarePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB74D), // Orange background color
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFE0B2),
                  hintText: 'Vet Services near you...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Vet Cards
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildVetCard(
                    'Dr.Raj Sharma',
                    '1234567890',
                    'abc@gmail.com',
                    '10 am - 4 pm',
                  ),
                  _buildVetCard(
                    'Dr.Nidhi Roy',
                    '1234567890',
                    'abc@gmail.com',
                    '10 am - 4 pm',
                  ),
                  _buildVetCard(
                    'Dr.Ishwari Rai',
                    '1234567890',
                    'abc@gmail.com',
                    '10 am - 4 pm',
                    showVaccinations: true,
                  ),
                  _buildVetCard(
                    'Dr.Joshi',
                    '1234567890',
                    'abc@gmail.com',
                    '10 am - 4 pm',
                  ),
                ],
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
                  _buildNavItem(Icons.book, 'Rule Book'),
                  _buildNavItem(Icons.home, 'Vet Care'),
                  _buildNavItem(Icons.pets, 'About Me'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetCard(
    String name,
    String contact,
    String email,
    String hours, {
    bool showVaccinations = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            if (!showVaccinations) ...[
              _buildInfoRow(Icons.phone, 'Contact Number', contact),
              _buildInfoRow(Icons.email, 'Email-Address', email),
              _buildInfoRow(Icons.access_time, 'Available Hours', hours),
            ] else ...[
              _buildInfoRow(Icons.medical_services, 'Rabies Vaccination', contact),
              _buildInfoRow(Icons.medical_services, 'Bordetella Vaccination', email),
              _buildInfoRow(Icons.medical_services, 'Leptospirosis Vaccination', hours),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(value),
              ],
            ),
          ),
        ],
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
}