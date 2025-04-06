import 'package:flutter/material.dart';

import '../services/api_service.dart';

class HealthHygienePage extends StatefulWidget {
  const HealthHygienePage({Key? key}) : super(key: key);

  @override
  _HealthHygienePageState createState() => _HealthHygienePageState();
}

class _HealthHygienePageState extends State<HealthHygienePage> {
  final ApiService apiService = ApiService();
  String? selectedBreed;
  String? selectedAgeGroup;
  String hygieneInfo = 'Select a breed and age group to view health & hygiene tips';
  List<String> breeds = [];
  bool isLoading = false;

  // Fresh, minimalist color palette
  final Color primaryGreen = const Color(0xFF4CAF50); // Vibrant green
  final Color secondaryGreen = const Color(0xFF81C784); // Softer green
  final Color accentGreen = const Color(0xFFA5D6A7); // Very light green
  final Color backgroundColor = const Color(0xFFF1F8E9); // Off-white with green tint
  final Color textColor = const Color(0xFF333333); // Near-black for text
  final Color subtleGrey = const Color(0xFFEEEEEE); // Subtle grey for dividers

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
        hygieneInfo = 'Failed to load breeds: $e';
        isLoading = false;
      });
    }
  }

  void fetchHygieneInfo() async {
    if (selectedBreed != null && selectedAgeGroup != null) {
      setState(() => isLoading = true);
      try {
        final response = await apiService.getHygieneInfo(selectedBreed!, selectedAgeGroup!);
        setState(() {
          hygieneInfo = response.toString(); // Convert the map to a string for display
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          hygieneInfo = 'No information available for the selected filters.';
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
          'Health & Hygiene Guide',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryGreen,
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
                      : _buildHygieneInfoCard(),
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
          'Health & Hygiene Tips',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
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
                fetchHygieneInfo();
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
                fetchHygieneInfo();
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
            valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
            strokeWidth: 2,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading health & hygiene tips...',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHygieneInfoCard() {
    return Container(
      key: const ValueKey('hygieneInfo'),
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
                color: primaryGreen,
                child: Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedBreed!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                        'Health & Hygiene Tips',
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
                          hygieneInfo,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: textColor,
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
                        Icons.health_and_safety,
                        size: 40,
                        color: primaryGreen.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        hygieneInfo,
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
}