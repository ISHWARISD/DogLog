import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;
  static const String _userDataKey = 'user_data';
  static const String _currentUserKey = 'current_user';
  static const String _userProfileKey = 'user_profile_';  // Will be used as prefix: user_profile_email@example.com

  ApiService({this.baseUrl = 'https://api.thedogapi.com/v1'});

  // Save dog profile information
  Future<bool> saveDogProfile(String email, Map<String, dynamic> dogInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userProfileKey = _userProfileKey + email;
      
      // Save the dog profile
      await prefs.setString(userProfileKey, json.encode(dogInfo));
      print('Dog profile saved for user: $email');
      
      // Update onboarding status for this user
      await updateOnboardingStatus(email, true);
      
      return true;
    } catch (e) {
      print('Error saving dog profile: $e');
      return false;
    }
  }

  // Get saved dog profile information
  Future<Map<String, dynamic>?> getDogProfile(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userProfileKey = _userProfileKey + email;
      final profileData = prefs.getString(userProfileKey);
      
      if (profileData == null) {
        print('No profile found for user: $email');
        return null;
      }
      
      print('Profile retrieved for user: $email');
      return json.decode(profileData);
    } catch (e) {
      print('Error retrieving dog profile: $e');
      return null;
    }
  }

  // Fetching breeds
  Future<List<String>> getBreeds() async {
    try {
      print('Fetching breeds...');
      return [
        'Labrador Retriever', 'German Shepherd', 'Golden Retriever',
        'French Bulldog', 'Pomeranian', 'Beagle', 'Shih Tzu',
        'Siberian Husky', 'Dachshund', 'Rottweiler'
      ];
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Fetching diet info
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

  // Fetching fun & socialization info
  Future<Map<String, dynamic>> getFunInfo(String breed, String ageGroup) async {
    try {
      print('Fetching fun info for breed: $breed, age group: $ageGroup...');
      final String response = await rootBundle.loadString('data/fun.json');
      final data = json.decode(response);
      print('Fun info fetched successfully.');
      return data[breed][ageGroup];
    } catch (e) {
      print('Error reading fun information: $e');
      throw Exception('Error reading fun information: $e');
    }
  }

  // Fetching health & hygiene info
  Future<Map<String, dynamic>> getHygieneInfo(String breed, String ageGroup) async {
    try {
      print('Fetching health & hygiene info for breed: $breed, age group: $ageGroup...');
      final String response = await rootBundle.loadString('data/health_hygiene.json');
      final data = json.decode(response);
      print('Health & hygiene info fetched successfully.');
      return data[breed][ageGroup];
    } catch (e) {
      print('Error reading health & hygiene information: $e');
      throw Exception('Error reading health & hygiene information: $e');
    }
  }

  // Fetching medical care info
  Future<Map<String, dynamic>> getMedicalInfo(String breed, String ageGroup) async {
    try {
      print('Fetching medical care info for breed: $breed, age group: $ageGroup...');
      final String response = await rootBundle.loadString('data/medical_care.json');
      final data = json.decode(response);
      print('Medical care info fetched successfully.');
      return data[breed][ageGroup];
    } catch (e) {
      print('Error reading medical care information: $e');
      throw Exception('Error reading medical care information: $e');
    }
  }

  // Register user
  Future<bool> registerUser(String email, String password) async {
    try {
      print('Registering user with email: $email...');
      
      if (email.isEmpty || password.isEmpty) {
        print('Registration failed: Invalid input.');
        return false;
      }
      
      // Check if user already exists
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_userDataKey);
      Map<String, dynamic> users = {};
      
      if (usersJson != null) {
        users = json.decode(usersJson);
        if (users.containsKey(email)) {
          print('Registration failed: Email already in use.');
          return false;
        }
      }
      
      // Add new user to local storage
      users[email] = {
        'password': password,
        'onboardingCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // Save updated users
      await prefs.setString(_userDataKey, json.encode(users));
      print('User registered successfully.');
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      print('Logging in user with email: $email...');
      
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_userDataKey);
      
      if (usersJson == null) {
        print('No registered users found.');
        return {'success': false, 'message': 'Invalid email or password'};
      }
      
      final users = json.decode(usersJson);
      
      // Check if user exists and password matches
      if (users.containsKey(email) && users[email]['password'] == password) {
        // Store current user session
        final currentUser = {
          'email': email,
          'onboardingCompleted': users[email]['onboardingCompleted'],
          'loggedInAt': DateTime.now().toIso8601String()
        };
        
        await prefs.setString(_currentUserKey, json.encode(currentUser));
        
        print('Login successful.');
        return {
          'success': true, 
          'onboardingCompleted': users[email]['onboardingCompleted'],
          'message': 'Login successful',
          'email': email  // Add email to the return map for convenience
        };
      } else {
        print('Invalid credentials.');
        return {'success': false, 'message': 'Invalid email or password'};
      }
    } catch (e) {
      print('Error during login: $e');
      return {'success': false, 'message': 'An error occurred during login'};
    }
  }
  
  // Update onboarding status
  Future<bool> updateOnboardingStatus(String email, bool completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_userDataKey);
      
      if (usersJson == null) {
        return false;
      }
      
      Map<String, dynamic> users = json.decode(usersJson);
      
      if (!users.containsKey(email)) {
        return false;
      }
      
      // Update onboarding status
      users[email]['onboardingCompleted'] = completed;
      await prefs.setString(_userDataKey, json.encode(users));
      
      // Also update in current user if it's the logged-in user
      final currentUserJson = prefs.getString(_currentUserKey);
      if (currentUserJson != null) {
        final currentUser = json.decode(currentUserJson);
        if (currentUser['email'] == email) {
          currentUser['onboardingCompleted'] = completed;
          await prefs.setString(_currentUserKey, json.encode(currentUser));
        }
      }
      
      return true;
    } catch (e) {
      print('Error updating onboarding status: $e');
      return false;
    }
  }
  
  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserJson = prefs.getString(_currentUserKey);
      
      if (currentUserJson == null) {
        return null;
      }
      
      return json.decode(currentUserJson);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
  
  // Logout
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_userDataKey);
      
      if (usersJson == null) {
        return false;
      }
      
      Map<String, dynamic> users = json.decode(usersJson);
      
      if (!users.containsKey(email)) {
        return false;
      }
      
      // In a real app, this would trigger a password reset email
      // For this demo, we'll just print a message
      print('Password reset initiated for $email');
      return true;
    } catch (e) {
      print('Error during password reset: $e');
      return false;
    }
  }
}