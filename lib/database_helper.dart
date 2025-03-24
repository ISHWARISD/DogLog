import 'dart:io';

import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dog_info.db');
    debugPrint('Database path: $path');

    // For development: delete the database to force recreation
    // Uncomment this when testing, then comment it again for production
    // await deleteDatabase(path);
    // debugPrint('Previous database deleted for testing');

    return await openDatabase(
      path,
      version: 2, // Incremented version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('Creating database tables at version $version');
    
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
        breed TEXT NOT NULL,
        age_group TEXT NOT NULL,
        diet_info TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    
    debugPrint('Database tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion');
    
    if (oldVersion < 2) {
      // Check if users table already exists
      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='users'");
      if (tables.isEmpty) {
        debugPrint('Creating users table during upgrade');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        debugPrint('Users table created during database upgrade');
      } else {
        debugPrint('Users table already exists, skipping creation');
      }
    }
  }

  // Utility method to check if the users table exists
  Future<bool> ensureUsersTableExists() async {
    final db = await database;
    
    try {
      // Check if the table exists
      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='users'");
      if (tables.isEmpty) {
        debugPrint('Users table does not exist, creating it now');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        debugPrint('Users table created');
        return true;
      } else {
        debugPrint('Users table already exists');
        return true;
      }
    } catch (e) {
      debugPrint('Error checking/creating users table: $e');
      return false;
    }
  }

  // Insert Dog Info
  Future<int> insertDogInfo(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('dog_info', row);
  }

  // Fetch Latest Dog Info
  Future<Map<String, dynamic>?> getLatestDogInfo() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'dog_info',
      orderBy: 'id DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Print All Dog Info (For Debugging)
  Future<void> printAllDogInfo() async {
    final db = await database;
    List<Map<String, dynamic>> allDogs = await db.query('dog_info');
    for (var dog in allDogs) {
      debugPrint("Dog Info: $dog");
    }
  }

  // Insert Diet Info
  Future<int> insertDietInfo(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('diet_info', row);
  }

  // Fetch Diet Info for Specific Breed and Age Group
  Future<List<Map<String, dynamic>>> getDietInfo(String breed, String ageGroup) async {
    final db = await database;
    return await db.query(
      'diet_info',
      where: 'breed = ? AND age_group = ?',
      whereArgs: [breed, ageGroup],
    );
  }

  // Print All Diet Info (For Debugging)
  Future<void> printAllDietInfo() async {
    final db = await database;
    List<Map<String, dynamic>> allDietInfo = await db.query('diet_info');
    for (var diet in allDietInfo) {
      debugPrint("Diet Info: $diet");
    }
  }

  // Get All Unique Breeds from Diet Info
  Future<List<String>> getBreeds() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT DISTINCT breed FROM diet_info');
    return result.map((row) => row['breed'] as String).toList();
  }

  // Delete Dog Info by ID
  Future<int> deleteDogInfo(int id) async {
    final db = await database;
    return await db.delete('dog_info', where: 'id = ?', whereArgs: [id]);
  }

  // Delete Diet Info by Breed and Age Group
  Future<int> deleteDietInfo(String breed, String ageGroup) async {
    final db = await database;
    return await db.delete(
      'diet_info',
      where: 'breed = ? AND age_group = ?',
      whereArgs: [breed, ageGroup],
    );
  }

  // Update Dog Info by ID
  Future<int> updateDogInfo(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'dog_info',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}