import 'package:flutter/material.dart';

class DietNutritionPage extends StatelessWidget {
  const DietNutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet & Nutrition'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dog Breed Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Dog Breed',
                border: OutlineInputBorder(),
              ),
              items: <String>[
                'Labrador Retriever',
                'German Shepherd',
                'Golden Retriever',
                'French Bulldog',
                'Pomeranian',
                'Beagle',
                'Shih Tzu',
                'Siberian Husky',
                'Dachshund',
                'Rottweiler'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle breed selection
              },
            ),
            SizedBox(height: 16),

            // Age Group Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Age Group',
                border: OutlineInputBorder(),
              ),
              items: <String>[
                'Puppy (0-12 months)',
                'Young Adult (1-3 years)',
                'Mid Adult (4-5 years)',
                'Mature Adult (6-7 years)',
                'Senior (7+ years)'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle age group selection
              },
            ),
            SizedBox(height: 16),

            // Information based on filters
            Expanded(
              child: Center(
                child: Text(
                  'Information will appear here based on selected filters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
