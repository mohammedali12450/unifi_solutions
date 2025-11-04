import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../core/error/failures.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUsers(List<UserModel> users);
  Future<List<UserModel>> getLastUsers();
}

const String TABLE_USERS = 'users';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_cache.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_USERS(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        gender TEXT,
        status TEXT
      )
    ''');
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final db = await database;
    // Clear old cache before inserting new data
    await db.delete(TABLE_USERS);
    final batch = db.batch();
    for (var user in users) {
      batch.insert(TABLE_USERS, user.toJson()..['id'] = user.id,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<UserModel>> getLastUsers() async {
    final db = await database;
    final result = await db.query(TABLE_USERS);
    if (result.isNotEmpty) {
      return result.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw CacheException();
    }
  }
}

