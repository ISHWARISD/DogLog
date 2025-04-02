import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../database_helper.dart'; // Importing SQLite database helper

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://api.thedogapi.com/v1'}); // Example base URL

  // Fetching breeds (existing function)
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

  // Fetching diet info (existing function)
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

  // ------------------- New Authentication Functions -------------------

  // User Registration
  Future<bool> registerUser(String username, String password) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      
      // Ensure the users table exists
      await dbHelper.ensureUsersTableExists();
      
      final db = await dbHelper.database;
      
      // Check if user already exists
      final existingUser = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (existingUser.isNotEmpty) {
        print('User already exists!');
        return false;
      }

      // Hash the password
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Insert new user into database
      await db.insert('users', {
        'username': username,
        'password': hashedPassword,
        'onboardingCompleted': 0, // New users have not completed onboarding
      });

      print('User registered successfully!');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // User Login
  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      
      // Ensure the users table exists
      await dbHelper.ensureUsersTableExists();
      
      final db = await dbHelper.database;

      // Hash the password
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Check credentials
      final user = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, hashedPassword],
      );

      if (user.isNotEmpty) {
        print('Login successful!');
        bool onboardingCompleted = user.first['onboardingCompleted'] == 1;

        return {
          'success': true,
          'onboardingCompleted': onboardingCompleted,
          'email': user.first['username'], // Ensure email is returned
        };
      } else {
        print('Invalid username or password');
        return {'success': false};
      }
    } catch (e) {
      print('Error logging in user: $e');
      return {'success': false};
    }
  }

  // Mark user onboarding as completed
  Future<bool> completeUserOnboarding(String username) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;

      int updated = await db.update(
        'users',
        {'onboardingCompleted': 1},
        where: 'username = ?',
        whereArgs: [username],
      );

      if (updated > 0) {
        print('Onboarding marked as completed for user: $username');
        return true;
      } else {
        print('Failed to mark onboarding as completed for user: $username');
        return false;
      }
    } catch (e) {
      print('Error completing onboarding: $e');
      return false;
    }
  }
}