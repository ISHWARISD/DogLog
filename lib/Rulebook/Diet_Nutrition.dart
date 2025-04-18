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

  // Fresh, minimalist color palette
  final Color primaryYellow = const Color(0xFFFFC42B);  // Vibrant but not harsh yellow
  final Color secondaryYellow = const Color(0xFFFFD966); // Softer yellow
  final Color accentYellow = const Color.fromARGB(255, 255, 255, 153);    // Very light yellow
  final Color backgroundColor = const Color(0xFFFFFBF2); // Off-white with yellow tint
  final Color textColor = const Color(0xFF333333);       // Near-black for text
  final Color subtleGrey = const Color(0xFFEEEEEE);      // Subtle grey for dividers

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dog Nutrition Guide',
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryYellow,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show info dialog
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simple header
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Filter Section
              _buildFilterSection(),
              
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
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tailored Nutrition',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
        // const SizedBox(height: 6),
        // Text(
        //   'Breed-specific dietary recommendations for your dog',
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: textColor.withOpacity(0.6),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Dog Breed',
            value: selectedBreed,
            items: breeds,
            onChanged: (String? newValue) {
              setState(() {
                selectedBreed = newValue;
                fetchDietInfo();
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Age Group',
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
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: subtleGrey),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: textColor.withOpacity(0.6)),
              style: TextStyle(color: textColor, fontSize: 15),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Text(
                'Select ${label.toLowerCase()}',
                style: TextStyle(color: textColor.withOpacity(0.4)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryYellow),
            strokeWidth: 2,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading nutrition information...',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietInfoCard() {
    return Container(
      key: const ValueKey('dietInfo'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            if (selectedBreed != null && selectedAgeGroup != null) ...[
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: primaryYellow,
                child: Row(
                  children: [
                    Icon(
                      _getAgeGroupIcon(),
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedBreed!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedAgeGroup!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dietary Recommendations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dietInfo,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(Icons.download_outlined, 
                            color: primaryYellow, 
                            size: 18
                          ),
                          label: Text(
                            'Download Guide',
                            style: TextStyle(
                              color: primaryYellow,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            // Download action
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 8
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Empty state
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets_outlined,
                        size: 40,
                        color: primaryYellow.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        dietInfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getAgeGroupIcon() {
    if (selectedAgeGroup == null) return Icons.help_outline;
    if (selectedAgeGroup!.contains('Puppy')) return Icons.child_friendly;
    if (selectedAgeGroup!.contains('Young')) return Icons.directions_run;
    if (selectedAgeGroup!.contains('Mid')) return Icons.fitness_center;
    if (selectedAgeGroup!.contains('Mature')) return Icons.elderly_woman;
    if (selectedAgeGroup!.contains('Senior')) return Icons.elderly;
    return Icons.pets;
  }
}