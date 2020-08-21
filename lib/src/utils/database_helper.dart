import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/list_model.dart';

//Database helper which includes all the method to create database, save data, delete data, update data, render data etc.

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableTask = 'taskTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'task.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTask($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)');
  }

  Future<int> saveTask(ListModel task) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTask, task.toMap());

    return result;
  }

  Future<List> getAllTasks() async {
    var dbClient = await db;
    var result = await dbClient
        .query(tableTask, columns: [columnId, columnTitle, columnDescription]);

    return result.toList();
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableTask, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTask(ListModel listModel) async {
    var dbClient = await db;
    return await dbClient.update(tableTask, listModel.toMap(),
        where: "$columnId = ?", whereArgs: [listModel.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
