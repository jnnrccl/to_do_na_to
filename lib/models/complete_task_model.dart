
// ignore: camel_case_types
import 'package:intl/intl.dart';

// ignore: camel_case_types
class completedTask{
  DateTime date;
  String time;
  int completed; // 0 - incomplete, 1 - complete

  completedTask({
    this.date,
    this.time,
    this.completed
  });

  Map<String, dynamic> toMapComplete() {
    final map = Map<String, dynamic>();
    map['date'] = convertDateTimeDisplay(date.toString()); //date.toIso8601String();
    map['time'] = time;
    map['completed'] = completed;
    return map;
  }

  factory completedTask.fromMap(Map<String, dynamic> map) {
    return completedTask(
      date: convertStringToDate(map['date']),
      time: map['time'],
      completed: map['completed'],
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

DateTime convertStringToDate(String date) {
  String dateWithT = date + 'T0:00:00.00000';
  DateTime dateTime = DateTime.parse(date);
  return dateTime;
}
