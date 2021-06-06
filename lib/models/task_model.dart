import 'package:intl/intl.dart';

class Task{
  //static String table = "events";
  int id;
  String subjectName;
  String taskName;
  DateTime date;
  String priority;
  int status; // 0 - incomplete, 1 - complete
  String stopTime;
  List<String> scheduler;

  //ADDING SECOND ID FOR SECOND AND THIRD NOTIFICATION
  int secondId, thirdId;

  Task(
      {this.subjectName,
        this.taskName,
        this.date,
        this.priority,
        this.status,
        this.scheduler,
        this.stopTime}) {
    secondId = id + 100;
    thirdId = id+200;
  }

  Task.withID(
      {this.id,
        this.subjectName,
        this.taskName,
        this.date,
        this.priority,
        this.status,
        this.scheduler,
        this.stopTime}) {
    secondId = id + 100;
    thirdId = id+200;
  }

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
    map['scheduler'] = convertListToString(scheduler);
    map['stopTime'] = stopTime;
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
      scheduler: convertStringToList(map['scheduler']),
      stopTime: map['stopTime'],
    );
  }
}

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormatter = DateFormat('yyyy-MM-dd HH:mm');
  final DateTime displayDate = displayFormatter.parse(date);
  final String formatted = serverFormatter.format(displayDate);
  return formatted;
}

DateTime convertStringToDate(String date){
  //String dateWithT = date + 'T0:00:00.00000';
  DateTime dateTime = DateTime.parse(date);
  return dateTime;
}

String convertListToString(List<String> scheduler){
  if(scheduler.length == 0){
    return ' ';
  }
  else{
    return scheduler.join(",");
  }
}

List<String> convertStringToList(String text){
  if (text == ' '){
    return [];
  }
  else{
    return text.split(',');
  }
}