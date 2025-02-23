import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AboutMe.dart';
import 'Rulebook/Rulebook.dart';

class VetCarePage extends StatefulWidget {
  @override
  _VetCarePageState createState() => _VetCarePageState();
}

class _VetCarePageState extends State<VetCarePage> {
  List<dynamic> _contacts = [];
  List<dynamic> _filteredContacts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _loadContacts() async {
    final String response = await rootBundle.loadString('data/vetcare.json');
    final data = await json.decode(response);
    setState(() {
      _contacts = data['contacts'];
      _filteredContacts = _contacts;
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = contact['Name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Vet Care',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFFB300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Color(0xFFFFFBE6), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            // Search Container
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Vets Near You..',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'Poppins',
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFFB300),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),

            // List of Contacts
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFFFB300),
                                child: Icon(
                                  Icons.medical_services,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  contact['Name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          _buildContactInfo(
                            Icons.phone,
                            contact['Contact Number'],
                          ),
                          _buildContactInfo(
                            Icons.email,
                            contact['Email-address'],
                          ),
                          _buildContactInfo(
                            Icons.access_time,
                            contact['Available Hours'],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton(
                    context,
                    Icons.book,
                    'Rule Book',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RulebookPage()),
                    ),
                  ),
                  _buildNavButton(
                    context,
                    Icons.home,
                    'Vet Care',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VetCarePage()),
                    ),
                  ),
                  _buildNavButton(
                    context,
                    Icons.pets,
                    'About Me',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutMePage(
                          name: 'Millie',
                          breed: 'Golden Retriever',
                          age: '1yr',
                          gender: 'Female',
                          weight: '30 kg',
                          medicalHistory: 'None',
                          imageFile: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Color(0xFFFFB300),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Color(0xFFFFB300),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}