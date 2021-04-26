import 'package:intl/intl.dart';

class Task{

  //static String table = "events";

  int id;
  String subjectName;
  String taskName;
  DateTime date;
  String priority;
  int status; // 0 - incomplete, 1 - complete

  Task({this.subjectName, this.taskName, this.date, this.priority, this. status});
  Task.withID({this.id, this.subjectName, this.taskName, this.date, this.priority, this. status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['subjectName'] = subjectName;
    map['taskName'] = taskName;
    map['date'] = convertDateTimeDisplay(date.toString()); //date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map){
    return Task.withID(
      id: map['id'],
      subjectName: map['subjectName'],
      taskName: map['taskName'],
      date: convertStringToDate(map['date']),
      priority: map['priority'],
      status: map['status'],
    );
  }
}

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

DateTime convertStringToDate(String date){
  String dateWithT = date + 'T0:00:00.00000';
  DateTime dateTime = DateTime.parse(date);
  return dateTime;
}