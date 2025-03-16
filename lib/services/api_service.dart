import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://api.thedogapi.com/v1'}); // Example base URL

  Future<List<String>> getBreeds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/breeds'));

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = json.decode(response.body);
        return data.map((breed) => breed['name'].toString()).toList();
      } else {
        throw Exception('Failed to load breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Map<String, dynamic>> getDietInfo(String breed, String ageGroup) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/diet_info/$breed/$ageGroup')
      );

      if (response.statusCode == 200) {
        // Parse the response body
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('No diet information found for $breed $ageGroup');
      } else {
        throw Exception('Failed to load diet information: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}