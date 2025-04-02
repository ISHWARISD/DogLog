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
      version: 4, // Incremented version number for new schema
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
        image_file TEXT,
        email TEXT
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
        password TEXT NOT NULL,
        onboarding_completed BOOLEAN NOT NULL DEFAULT 0
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
    
    if (oldVersion < 3) {
      // Add onboarding_completed column to users table if it doesn't exist
      var columns = await db.rawQuery("PRAGMA table_info(users)");
      bool hasOnboardingColumn = columns.any((column) => column['name'] == 'onboarding_completed');
      
      if (!hasOnboardingColumn) {
        debugPrint('Adding onboarding_completed column to users table');
        await db.execute('''
          ALTER TABLE users ADD COLUMN onboarding_completed BOOLEAN NOT NULL DEFAULT 0
        ''');
        debugPrint('Added onboarding_completed column');
      } else {
        debugPrint('onboarding_completed column already exists');
      }
    }

    if (oldVersion < 4) {
      // Add email column to dog_info table if it doesn't exist
      var columns = await db.rawQuery("PRAGMA table_info(dog_info)");
      bool hasEmailColumn = columns.any((column) => column['name'] == 'email');
      
      if (!hasEmailColumn) {
        debugPrint('Adding email column to dog_info table');
        await db.execute('''
          ALTER TABLE dog_info ADD COLUMN email TEXT
        ''');
        debugPrint('Added email column to dog_info table');
      } else {
        debugPrint('email column already exists');
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
            password TEXT NOT NULL,
            onboarding_completed BOOLEAN NOT NULL DEFAULT 0
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
    try {
      return await db.insert('dog_info', row);
    } catch (e) {
      debugPrint('Error inserting dog info: $e');
      return -1; // Return -1 to indicate failure
    }
  }

  // Fetch Latest Dog Info
  Future<Map<String, dynamic>?> getLatestDogInfo() async {
    final db = await database;
    try {
      // Query the latest dog info by ordering by ID in descending order
      List<Map<String, dynamic>> result = await db.query(
        'dog_info',
        orderBy: 'id DESC',
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('Error fetching latest dog info: $e');
      return null;
    }
  }

  // Fetch Dog Info by Email
  Future<List<Map<String, dynamic>>> getDogInfoByEmail(String email) async {
    final db = await database;
    try {
      return await db.query(
        'dog_info',
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      debugPrint('Error fetching dog info by email: $e');
      return [];
    }
  }

  // Print All Dog Info (For Debugging)
  Future<void> printAllDogInfo() async {
    final db = await database;
    List<Map<String, dynamic>> allDogs = await db.query('dog_info');
    for (var dog in allDogs) {
      debugPrint("Dog Info: $dog");
    }
  }
}