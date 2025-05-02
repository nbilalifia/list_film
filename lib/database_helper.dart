// database_helper.dart (versi terbaru, support FilmItem dan imagePath)

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import '../models/film_item.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String filmTable = 'film_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colRecommendation = 'recommendation';
  String colDate = 'date';
  String colImagePath = 'imagePath';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'film.db');
    var filmDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return filmDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $filmTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT,
        $colDescription TEXT,
        $colRecommendation TEXT,
        $colDate TEXT,
        $colImagePath TEXT
      )''');
  }

  // Get list of all film items
  Future<List<FilmItem>> getFilmList() async {
    Database db = await this.database;
    var result = await db.query(filmTable, orderBy: '$colRecommendation ASC');
    return result.map((e) => FilmItem.fromMapObject(e)).toList();
  }

  // Insert
  Future<int> insertFilm(FilmItem item) async {
    Database db = await this.database;
    var result = await db.insert(filmTable, item.toMap());
    return result;
  }

  // Update
  Future<int> updateFilm(FilmItem item) async {
    Database db = await this.database;
    var result = await db.update(filmTable, item.toMap(), where: '$colId = ?', whereArgs: [item.id]);
    return result;
  }

  // Delete
  Future<int> deleteFilm(int id) async {
    Database db = await this.database;
    var result = await db.delete(filmTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Delete all selected
  Future<int> deleteMultiple(List<int> ids) async {
    Database db = await this.database;
    var idList = ids.join(',');
    var result = await db.rawDelete('DELETE FROM $filmTable WHERE $colId IN ($idList)');
    return result;
  }

  // Delete all
  Future<int> deleteAll() async {
    Database db = await this.database;
    var result = await db.delete(filmTable);
    return result;
  }

  // Count
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $filmTable');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }
}
