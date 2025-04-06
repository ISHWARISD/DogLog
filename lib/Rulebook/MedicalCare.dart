import 'package:flutter/material.dart';

import '../services/api_service.dart';

class MedicalCarePage extends StatefulWidget {
  const MedicalCarePage({Key? key}) : super(key: key);

  @override
  _MedicalCarePageState createState() => _MedicalCarePageState();
}

class _MedicalCarePageState extends State<MedicalCarePage> {
  final ApiService apiService = ApiService();
  String? selectedBreed;
  String? selectedAgeGroup;
  String medicalInfo = 'Select a breed and age group to view medical care tips';
  List<String> breeds = [];
  bool isLoading = false;

  // Fresh, minimalist color palette
  final Color primaryRed = const Color(0xFFE53935); // Vibrant red
  final Color secondaryRed = const Color(0xFFEF5350); // Softer red
  final Color accentRed = const Color(0xFFFFCDD2); // Very light red
  final Color backgroundColor = const Color(0xFFFFEBEE); // Off-white with red tint
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
        medicalInfo = 'Failed to load breeds: $e';
        isLoading = false;
      });
    }
  }

  void fetchMedicalInfo() async {
    if (selectedBreed != null && selectedAgeGroup != null) {
      setState(() => isLoading = true);
      try {
        final response = await apiService.getMedicalInfo(selectedBreed!, selectedAgeGroup!);
        setState(() {
          medicalInfo = response.toString(); // Convert the map to a string for display
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          medicalInfo = 'No information available for the selected filters.';
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
          'Vaccination & Medical Care',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryRed,
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
                      : _buildMedicalInfoCard(),
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
          'Medical Care Tips',
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
                fetchMedicalInfo();
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
                fetchMedicalInfo();
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
            valueColor: AlwaysStoppedAnimation<Color>(primaryRed),
            strokeWidth: 2,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading medical care tips...',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      key: const ValueKey('medicalInfo'),
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
                color: primaryRed,
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services,
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
                        'Medical Care Tips',
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
                          medicalInfo,
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
                        Icons.medical_services,
                        size: 40,
                        color: primaryRed.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        medicalInfo,
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