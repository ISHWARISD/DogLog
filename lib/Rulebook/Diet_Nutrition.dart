import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DietNutritionPage extends StatefulWidget {
  const DietNutritionPage({Key? key}) : super(key: key);

  @override
  _DietNutritionPageState createState() => _DietNutritionPageState();
}

class _DietNutritionPageState extends State<DietNutritionPage> {
  final ApiService apiService = ApiService();
  String? selectedBreed;
  String? selectedAgeGroup;
  String dietInfo = 'Information will appear here based on selected filters.';
  List<String> breeds = [];

  @override
  void initState() {
    super.initState();
    fetchBreeds();
  }

  void fetchBreeds() async {
    try {
      final fetchedBreeds = await apiService.getBreeds();
      setState(() {
        breeds = fetchedBreeds;
      });
    } catch (e) {
      setState(() {
        dietInfo = 'Failed to load breeds: $e';
      });
    }
  }

  void fetchDietInfo() async {
    if (selectedBreed != null && selectedAgeGroup != null) {
      try {
        final response = await apiService.getDietInfo(selectedBreed!, selectedAgeGroup!);
        setState(() {
          dietInfo = response['diet_info'];
        });
      } catch (e) {
        setState(() {
          dietInfo = 'No information available for the selected filters.';
        });
      }
    }
  }

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
              items: breeds.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedBreed = newValue;
                  fetchDietInfo();
                });
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
                setState(() {
                  selectedAgeGroup = newValue;
                  fetchDietInfo();
                });
              },
            ),
            SizedBox(height: 16),

            // Information based on filters
            Expanded(
              child: Center(
                child: Text(
                  dietInfo,
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