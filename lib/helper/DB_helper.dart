import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  DatabaseHelper._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scores.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        score INTEGER
      )
    ''');
  }

  Future<void> insertScore(String name, int score) async {
    final db = await instance.database;
    await db.insert('scores', {'name': name, 'score': score});
  }


  Future<void> initDB() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tic_scores.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE scores (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          points INTEGER
        )
      ''');
    });
  }

  Future<void> insertWin(String name, int points) async {
    await _db!.insert('scores', {'name': name, 'points': points});
  }

  Future<int> totalPoints(String name) async {
    final res = await _db!.rawQuery(
        'SELECT IFNULL(SUM(points),0) as total FROM scores WHERE name = ?',
        [name]);
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<List<Map<String, dynamic>>> topPlayers({int limit = 5}) async {
    return await _db!.query('scores',
        columns: ['name', 'SUM(points) as score'],
        groupBy: 'name',
        orderBy: 'score DESC',
        limit: limit);
  }

  Future<void> resetAllScores() async {
    await _db!.delete('scores');
  }
}