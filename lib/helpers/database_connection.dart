import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_na_to/models/complete_task_model.dart';
import 'package:to_do_na_to/models/task_model.dart';

class DatabaseConnection{
  static final DatabaseConnection instance = DatabaseConnection._instance();
  static Database _db;

  DatabaseConnection._instance();

  String tasksTable = 'task_table';
  String colId = 'id';
  String secondID = 'secondid';
  String thirdID = 'thirdid';
  String colSubject = 'subjectName';
  String colTask = 'taskName';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';
  String colScheduler = 'scheduler';
  String stopTime = 'stopTime';

  String historyTable = 'history_table';
  String colDay = 'date';
  String colTime = 'time';
  String colCompleted= 'completed';


  Future<Database> get db async {
    if (_db == null){
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_nato.db';
    final todoListDB = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDB;
  }

  void _createDb(Database db, int version) async{
    await db.execute(
        'CREATE TABLE $tasksTable('
            '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$secondID INTEGER, '
            '$thirdID INTEGER, '
            '$colSubject TEXT, '
            '$colTask TEXT, '
            '$colDate TEXT, '
            '$colPriority TEXT, '
            '$colStatus INTEGER, '
            '$colScheduler TEXT, '
            '$stopTime TEXT)'
    );
    await db.execute(
        'CREATE TABLE $historyTable('
            '$colDay TEXT, '
            '$colTime TEXT, '
            '$colCompleted INTEGER)'
    );
  }

  Future<void> deleteDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_nato.db';
    await deleteDatabase(path);
    // delete database
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap){
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<List<Task>> getTaskToDoList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap){
      if (taskMap['status'] == 0){
        taskList.add(Task.fromMap(taskMap));
      }
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<List<Task>> getTaskInProgList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap){
      if (taskMap['status'] == 1){
        taskList.add(Task.fromMap(taskMap));
      }
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<List<Task>> getTaskCompList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap){
      if (taskMap['status'] == 2){
        taskList.add(Task.fromMap(taskMap));
      }
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<List<Task>> getTasksOnDate(String date) async{
    Database db = await this.db;
    final List<Map<String, dynamic>> queryRows = await db.rawQuery('SELECT * FROM task_table WHERE date = ?', [date]);
    final List<Task> taskList = [];
    queryRows.forEach((taskMap){
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;

  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tasksTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Task>> getTask (int id) async {
    Database db = await this.db;
    final List<Map<String, dynamic>> task  = await db.rawQuery('SELECT * FROM task_table WHERE id = ?', [id]);
    final List<Task> taskList = [];

    task.forEach((taskMap){
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<List<Map<String, dynamic>>> getTaskMapCompleted() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(historyTable);
    return result;
  }

  Future<List<completedTask>> getCompletedTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapCompleted();
    final List<completedTask> completedList = [];
    taskMapList.forEach((taskMap){
      completedList.add(completedTask.fromMap(taskMap));
    });
    completedList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return completedList;
  }

  Future<int> insertCompletedTask(completedTask complete) async {
    Database db = await this.db;
    final int result = await db.insert(historyTable, complete.toMapComplete());
    return result;
  }

  Future<List<Map<String, dynamic>>> getDayMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(historyTable);
    return result;
  }

  Future<List<completedTask>> getDayList() async {
    final List<Map<String, dynamic>> dayMapList = await getDayMapList();
    final List<completedTask> dayList = [];
    dayMapList.forEach((dayMap){
      dayList.add(completedTask.fromMap(dayMap));
    });
    dayList.sort((dayA, dayB) => dayA.date.compareTo(dayB.date));
    return dayList;
  }

}
