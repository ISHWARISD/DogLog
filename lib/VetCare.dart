import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class VetCarePage extends StatefulWidget {
  const VetCarePage({Key? key}) : super(key: key);

  @override
  _VetCarePageState createState() => _VetCarePageState();
}

class _VetCarePageState extends State<VetCarePage> {
  List<dynamic> _contacts = [];
  List<dynamic> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  double _filterDistance = 10.0;
  Position? _userLocation;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _determinePosition();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    try {
      final String response = await rootBundle.loadString('data/vetcare.json');
      final data = await json.decode(response);
      setState(() {
        _contacts = data['contacts'] ?? [];
        _filteredContacts = _contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load contacts: $e';
        _isLoading = false;
      });
      print('Error loading contacts: $e');
    }
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mounted) {
        setState(() {
          _userLocation = position;
          _filterContacts();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error getting location: $e';
        });
      }
      print('Error getting location: $e');
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        // Check if name exists and matches search query
        final name = contact['Name']?.toString().toLowerCase() ?? '';
        final nameMatch = name.contains(query);
        
        // If no location is available, just filter by name
        if (_userLocation == null) {
          return nameMatch;
        }
        
        // Make sure lat/lon exist and are valid
        if (contact['lat'] == null || contact['lon'] == null) {
          return nameMatch;
        }
        
        // Calculate distance
        try {
          final double lat = double.tryParse(contact['lat'].toString()) ?? 0.0;
          final double lon = double.tryParse(contact['lon'].toString()) ?? 0.0;
          
          final distance = Geolocator.distanceBetween(
            _userLocation!.latitude, _userLocation!.longitude, lat, lon) / 1000;
          
          return nameMatch && distance <= _filterDistance;
        } catch (e) {
          print('Error calculating distance for ${contact['Name']}: $e');
          return nameMatch;
        }
      }).toList();
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _showVetDetails(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) {
        double? lat = double.tryParse(contact['lat']?.toString() ?? '');
        double? lon = double.tryParse(contact['lon']?.toString() ?? '');
        String? distance;
        
        if (_userLocation != null && lat != null && lon != null) {
          final distanceInKm = Geolocator.distanceBetween(
            _userLocation!.latitude, _userLocation!.longitude, lat, lon) / 1000;
          distance = '${distanceInKm.toStringAsFixed(1)} km away';
        }

        final phoneNumber = contact['Contact Number']?.toString() ?? '';
        final email = contact['Email-address']?.toString() ?? '';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section with color
                  Container(
                    color: const Color(0xFFFFB300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.medical_services,
                            size: 40,
                            color: Color(0xFFFFB300),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          contact['Name']?.toString() ?? 'Unknown',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (distance != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              distance,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Details section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.phone,
                          'Phone',
                          contact['Contact Number']?.toString() ?? 'No phone number',
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          Icons.email,
                          'Email',
                          contact['Email-address']?.toString() ?? 'No email',
                          Colors.blue,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          Icons.access_time,
                          'Available Hours',
                          contact['Available Hours']?.toString() ?? 'Hours not specified',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.phone),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: phoneNumber.isEmpty ? null : () async {
                              final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not launch phone dialer')),
                                );
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.email),
                            label: const Text('Email'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: email.isEmpty ? null : () async {
                              final Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: email,
                                query: encodeQueryParameters({
                                  'subject': 'Inquiry about veterinary services'
                                }),
                              );
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not launch email client')),
                                );
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Care'),
        backgroundColor: const Color(0xFFFFB300),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB300)))
        : _errorMessage.isNotEmpty 
          ? Center(child: Text(_errorMessage, textAlign: TextAlign.center))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Vets Near You..',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB300)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text('Distance: '),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFFFFB300),
                            inactiveTrackColor: const Color(0xFFFFE0B2),
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: const Color(0xFFFFB300),
                            overlayColor: const Color(0x29FFB300),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: const Color(0xFFFFB300),
                            inactiveTickMarkColor: const Color(0xFFFFE0B2),
                            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: const Color(0xFFFFB300),
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            value: _filterDistance,
                            min: 1,
                            max: 50,
                            divisions: 10,
                            label: "${_filterDistance.round()} km",
                            onChanged: (value) {
                              setState(() {
                                _filterDistance = value;
                                _filterContacts();
                              });
                            },
                          ),
                        ),
                      ),
                      Text("${_filterDistance.round()} km"),
                    ],
                  ),
                ),
                _filteredContacts.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'No vets found matching your criteria',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          
                          // Calculate distance if location is available
                          String? distanceText;
                          if (_userLocation != null) {
                            try {
                              final double lat = double.tryParse(contact['lat'].toString()) ?? 0.0;
                              final double lon = double.tryParse(contact['lon'].toString()) ?? 0.0;
                              
                              final distanceInKm = Geolocator.distanceBetween(
                                _userLocation!.latitude, _userLocation!.longitude, lat, lon) / 1000;
                              
                              distanceText = '${distanceInKm.toStringAsFixed(1)} km';
                            } catch (e) {
                              print('Error calculating list distance: $e');
                            }
                          }
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB300).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.medical_services, color: Color(0xFFFFB300)),
                              ),
                              title: Text(
                                contact['Name']?.toString() ?? 'Unknown',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(contact['Contact Number']?.toString() ?? 'No phone number'),
                              trailing: distanceText != null 
                                ? Chip(
                                    label: Text(distanceText),
                                    backgroundColor: const Color(0xFFFFE0B2),
                                    labelStyle: const TextStyle(color: Color(0xFFE65100)),
                                  )
                                : null,
                              onTap: () => _showVetDetails(contact),
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
    );
  }
}