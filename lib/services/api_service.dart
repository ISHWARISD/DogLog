import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://api.thedogapi.com/v1'}); // Example base URL

  Future<List<String>> getBreeds() async {
    try {
      // Simulate fetching breeds from an API
      print('Fetching breeds...');
      return ['Labrador Retriever', 'German Shepherd', 'Golden Retriever', 'French Bulldog', 'Pomeranian', 'Beagle', 'Shih Tzu', 'Siberian Husky', 'Dachshund', 'Rottweiler'];
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<String> getDietInfo(String breed, String ageGroup) async {
    try {
      print('Fetching diet info for breed: $breed, age group: $ageGroup...');
      final String response = await rootBundle.loadString('data/diet_nutrition.json');
      final data = json.decode(response);
      print('Diet info fetched successfully.');
      return data[breed][ageGroup];
    } catch (e) {
      print('Error reading diet information: $e');
      throw Exception('Error reading diet information: $e');
    }
  }
}