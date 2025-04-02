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
  String dietInfo = 'Select a breed and age group to view dietary recommendations';
  List<String> breeds = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBreeds();
  }

  void fetchBreeds() async {
    setState(() => isLoading = true);
    try {
      final fetchedBreeds = await apiService.getBreeds();
      setState(() {
        breeds = fetchedBreeds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        dietInfo = 'Failed to load breeds: $e';
        isLoading = false;
      });
    }
  }

  void fetchDietInfo() async {
    if (selectedBreed != null && selectedAgeGroup != null) {
      setState(() => isLoading = true);
      try {
        final response = await apiService.getDietInfo(selectedBreed!, selectedAgeGroup!);
        setState(() {
          dietInfo = response;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          dietInfo = 'No information available for the selected filters.';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dog Nutrition Guide',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.yellow[50]!, Colors.yellow[100]!],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with decorative paw prints
            _buildHeader(),

            // Filter Section
            _buildFilterCard(),

            const SizedBox(height: 24),

            // Information Display Section
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? _buildLoadingIndicator()
                    : _buildDietInfoCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pets, color: Colors.yellow[800], size: 32),
              const SizedBox(width: 8),
              Text(
                'Tailored Nutrition Plans',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Get breed-specific dietary recommendations for your dog',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildStyledDropdown(
              label: 'Select Dog Breed',
              value: selectedBreed,
              items: breeds,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBreed = newValue;
                  fetchDietInfo();
                });
              },
              icon: Icons.pets,
            ),
            const SizedBox(height: 16),
            _buildStyledDropdown(
              label: 'Select Age Group',
              value: selectedAgeGroup,
              items: const [
                'Puppy (0-12 months)',
                'Young Adult (1-3 years)',
                'Mid Adult (4-5 years)',
                'Mature Adult (6-7 years)',
                'Senior (7+ years)'
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedAgeGroup = newValue;
                  fetchDietInfo();
                });
              },
              icon: Icons.cake,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.yellow[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.yellow[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.yellow[300]!),
        ),
        filled: true,
        fillColor: Colors.yellow[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text('Choose $label', style: TextStyle(color: Colors.black)),
          dropdownColor: Colors.yellow[50],
          icon: Icon(Icons.arrow_drop_down, color: Colors.yellow[700]),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[700]!),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Fetching nutrition details...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedBreed != null && selectedAgeGroup != null) ...[
                Row(
                  children: [
                    Icon(
                      _getAgeGroupIcon(),
                      size: 28,
                      color: Colors.yellow[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$selectedBreed - $selectedAgeGroup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.yellow, height: 1),
                const SizedBox(height: 20),
                _buildInfoSection(
                  title: 'Dietary Recommendations',
                  icon: Icons.restaurant,
                  content: dietInfo,
                ),
              ] else ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 48,
                        color: Colors.yellow[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dietInfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required IconData icon, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.yellow[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.yellow[300]!, width: 1),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getAgeGroupIcon() {
    if (selectedAgeGroup == null) return Icons.help_outline;
    if (selectedAgeGroup!.contains('Puppy')) return Icons.child_friendly;
    if (selectedAgeGroup!.contains('Senior')) return Icons.elderly;
    return Icons.health_and_safety;
  }
}