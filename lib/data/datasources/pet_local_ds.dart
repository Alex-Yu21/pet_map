import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/pet_model.dart';

class PetLocalDataSource {
  static const _dbName = 'pets.db';
  static const _table = 'pets';

  Database? _db;

  Future<Database> get _database async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            photoPath TEXT,
            birthDate INTEGER,
            breed TEXT,
            isSterilized INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(PetModel model) async {
    final db = await _database;
    return db.insert(_table, model.toMap());
  }

  Future<List<PetModel>> getAll() async {
    final db = await _database;
    final maps = await db.query(_table, orderBy: 'id DESC');
    return maps.map(PetModel.fromMap).toList();
  }

  Future<void> update(PetModel model) async {
    final db = await _database;
    await db.update(
      _table,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
