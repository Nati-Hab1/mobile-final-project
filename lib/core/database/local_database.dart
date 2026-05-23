import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/db_constants.dart';
import '../utils/logger.dart';

class LocalDatabase {
  static Database? _database;
  
  // Check if running on mobile platform
  static bool get _isMobile => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  
  static Future<Database?> get instance async {
    if (!_isMobile) {
      AppLogger.debug('SQLite not supported on web - using API only');
      return null;
    }
    _database ??= await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    try {
      final path = await getDatabasesPath();
      final fullPath = join(path, DbConstants.databaseName);
      
      AppLogger.debug('Database path: $fullPath');
      
      return await openDatabase(
        fullPath,
        version: DbConstants.databaseVersion + 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      AppLogger.error('Failed to initialize database', e);
      rethrow;
    }
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    AppLogger.info('Creating database tables...');
    
    await db.execute(DbConstants.createStartupsTable);
    await db.execute(DbConstants.createInterestsTable);
    await db.execute(DbConstants.createBookmarksTable);
    await db.execute(DbConstants.createIntrosTable);
    
    // Cache tables
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_startups (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_investor (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');
    
    AppLogger.info('Database tables created successfully');
  }
  
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from version $oldVersion to $newVersion');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_startups (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_investor (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');
  }
  
  // Generic CRUD operations - return empty lists when database is null (web)
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance;
    if (db == null) return 0;
    return await db.insert(table, data);
  }
  
  static Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await instance;
    if (db == null) return [];
    return await db.query(
      table,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }
  
  static Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await instance;
    if (db == null) return 0;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }
  
  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await instance;
    if (db == null) return 0;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
  
  static Future<void> clearTable(String table) async {
    final db = await instance;
    if (db == null) return;
    await db.delete(table);
    AppLogger.debug('Cleared table: $table');
  }
  
  static Future<void> clearAllTables() async {
    final db = await instance;
    if (db == null) return;
    await clearTable(DbConstants.tableStartups);
    await clearTable(DbConstants.tableInterests);
    await clearTable(DbConstants.tableBookmarks);
    await clearTable(DbConstants.tableIntros);
    await clearTable('cached_startups');
    await clearTable('cached_investor');
    AppLogger.info('All tables cleared');
  }
  
  static Future<void> close() async {
    final db = await instance;
    if (db == null) return;
    await db.close();
    _database = null;
    AppLogger.info('Database closed');
  }
}