import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _determinePosition();
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

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _userLocation = position;
      print('User Location: $_userLocation');
      _filterContacts();
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = contact['Name'].toLowerCase();
        final double lat = contact['lat'];
        final double lon = contact['lon'];
        if (_userLocation == null) {
          print('User location is null');
          return name.contains(query);
        }
        final distance = Geolocator.distanceBetween(
          _userLocation!.latitude, _userLocation!.longitude, lat, lon) / 1000;
        print('Contact: ${contact['Name']}, Distance: $distance km, Filter Distance: $_filterDistance km');
        return name.contains(query) && distance <= _filterDistance;
      }).toList();
      print('Filtered Contacts: ${_filteredContacts.length}');
    });
  }

  void _showVetDetails(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    contact['Name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(contact['Contact Number']),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(contact['Email-address']),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(contact['Available Hours']),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Care'),
        backgroundColor: const Color(0xFFFFB300),
      ),
      body: Column(
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
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFFFFB300),
              inactiveTrackColor: Color(0xFFFFE0B2),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Color(0xFFFFB300),
              overlayColor: Color(0x29FFB300),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Color(0xFFFFB300),
              inactiveTickMarkColor: Color(0xFFFFE0B2),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Color(0xFFFFB300),
              valueIndicatorTextStyle: TextStyle(
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
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  leading: const Icon(Icons.medical_services, color: Color(0xFFFFB300)),
                  title: Text(contact['Name']),
                  subtitle: Text(contact['Contact Number']),
                  onTap: () => _showVetDetails(contact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}