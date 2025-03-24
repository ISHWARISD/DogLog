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
          dietInfo = response;
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
        title: const Text('Diet & Nutrition'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Age Group',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    dietInfo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
