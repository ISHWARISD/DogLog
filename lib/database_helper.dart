import 'dart:io';

import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Add this import
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the application documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dog_info.db');
    debugPrint('Database path: $path'); // Print the database path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dog_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        breed TEXT,
        age TEXT,
        gender TEXT,
        weight TEXT,
        medical_history TEXT,
        vaccination TEXT,
        vaccination_date TEXT,
        next_due_date TEXT,
        image_file TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE diet_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        breed TEXT,
        age_group TEXT,
        diet_info TEXT
      )
    ''');
  }

  // Dog Info Methods
  Future<int> insertDogInfo(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('dog_info', row);
  }

  Future<Map<String, dynamic>?> getLatestDogInfo() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'dog_info',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> printAllDogInfo() async {
    Database db = await database;

    List<Map<String, dynamic>> allDogs = await db.query('dog_info');

    for (var dog in allDogs) {
      debugPrint("Dog Info: $dog");
    }
  }

  // Diet Info Methods
  Future<int> insertDietInfo(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('diet_info', row);
  }

  Future<List<Map<String, dynamic>>> getDietInfo(String breed, String ageGroup) async {
    Database db = await database;
    return await db.query(
      'diet_info',
      where: 'breed = ? AND age_group = ?',
      whereArgs: [breed, ageGroup],
    );
  }

  Future<void> printAllDietInfo() async {
    Database db = await database;

    List<Map<String, dynamic>> allDietInfo = await db.query('diet_info');

    for (var diet in allDietInfo) {
      debugPrint("Diet Info: $diet");
    }
  }

  // New method to get all breeds
  Future<List<String>> getBreeds() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT DISTINCT breed FROM diet_info');
    return result.map((row) => row['breed'] as String).toList();
  }
}