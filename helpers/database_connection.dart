import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_na_to/models/task_model.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._instance();
  static Database _db;

  DatabaseConnection ._instance();

  String taskTable = 'task_table';
  String colId = 'id';
  String colSubjectName = 'subject_name';
  String colTaskName = 'task_name';
  String colPriority = 'priority';
  String colDate = 'date';

  Future<Database> get db async {
    if(_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'task_list.db'; //task_list.db is the name of the database
    final taskListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return taskListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colSubjectName TEXT, $colTaskName TEXT, $colPriority TEXT, $colDate TEXT)",
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
        taskTable,
        task.toMap(),
        where: '$colId = ?',
        whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      taskTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}