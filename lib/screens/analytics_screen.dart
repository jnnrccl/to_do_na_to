import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/models/complete_task_model.dart';

// ignore: must_be_immutable
class AnalyticsScreen extends StatefulWidget {
  int selectedDestination;
  AnalyticsScreen({this.selectedDestination});
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Future<List<completedTask>> _dayList;
  int completedDaily = 0;
  int completedWeekly = 0;
  int completedMonthly = 0;
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  int hrs = 0;
  int min = 0;
  int sec = 0;
  String timeDaily = "";
  String timeWeekly = "";
  String timeMonthly = "";
  String dur = "";

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _dayList = DatabaseConnection.instance.getDayList();
    });
  }

  getCompletedOnDate(date, dateList){
    List <completedTask> completed = [];
    if (dateList != null){
      for (completedTask element in dateList){
        if (date.year == element.date.year && date.month == element.date.month && date.day == element.date.day){
          completed.add(element);
        }
      }
    }
    return completed;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _buildProgressReportDaily(dateList) {
    DateTime _today = DateTime.now();
    _dateController.text = _dateFormat.format(_today);
    List dailyList = getCompletedOnDate(_today, dateList);
    if (dailyList != null) {
      for (completedTask element in dailyList) {
        if (element.completed == 1) {
          completedDaily++;
        }
        List l = element.time.split(':');
        hrs = hrs + int.parse(l[0]);
        min = min + int.parse(l[1]);
        List lst = l[2].split('.');
        sec = sec + int.parse(lst[0]);
      }
      final duration = Duration(hours: hrs, minutes: min, seconds: sec);
      timeDaily = _printDuration(duration);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  getCompletedWeekly(dater, dateList){
    List <completedTask> result = [];
    DateTime dayz = findFirstDateOfTheWeek(dater);
    if (dateList != null) {
      for (int d = 0; d < 7; d++) {
        // print(dayz);
        for (completedTask element in dateList) {
          if (dayz.year == element.date.year && dayz.month == element.date.month && dayz.day == element.date.day) {
            result.add(element);
          }
        }
        DateTime newDate = DateTime(dayz.year, dayz.month, dayz.day + 1);
        dayz = newDate;
      }
    }
    return result;
  }

  _buildProgressReportWeekly(dateList){
    hrs = 0; min = 0; sec = 0;
    DateTime _today = DateTime.now();
    _dateController.text = _dateFormat.format(_today);
    List weeklyList = getCompletedWeekly(_today, dateList);
    if (weeklyList != null) {
      for (completedTask element in weeklyList) {
        if (element.completed == 1) {
          completedWeekly++;
        }
        List l = element.time.split(':');
        hrs = hrs + int.parse(l[0]);
        min = min + int.parse(l[1]);
        List lst = l[2].split('.');
        sec = sec + int.parse(lst[0]);
      }
      final duration = Duration(hours: hrs, minutes: min, seconds: sec);
      timeWeekly = _printDuration(duration);
    }

  }

  getCompletedMonthly(dater, dateList) {
    DateTime firstDay = DateTime(dater.year, dater.month, 1);
    DateTime lastDay = DateTime(dater.year, dater.month + 1, 0);
    List <completedTask> result = [];
    print(firstDay);
    print(lastDay);

    if (dateList != null) {
      print(" huhuhu");
      while (firstDay.year == lastDay.year && firstDay.month == lastDay.month &&
          firstDay.day != lastDay.day) {
        print(firstDay);
        for (completedTask element in dateList) {
          if (firstDay.year == element.date.year &&
              firstDay.month == element.date.month &&
              firstDay.day == element.date.day) {
            result.add(element);
          }
        }
        DateTime newDate = DateTime(
            firstDay.year, firstDay.month, firstDay.day + 1);
        firstDay = newDate;
      }

      for (completedTask element in dateList) {
        if (firstDay.year == element.date.year &&
            firstDay.month == element.date.month &&
            firstDay.day == element.date.day) {
          result.add(element);
        }
      }

      return result;
    }
  }

  _buildProgressReportMonthly(dateList){
    hrs = 0; min = 0; sec = 0;
    DateTime _today = DateTime.now();
    _dateController.text = _dateFormat.format(_today);
    List monthlyList = getCompletedMonthly(_today, dateList);
    if (monthlyList != null) {
      for (completedTask element in monthlyList) {
        if (element.completed == 1) {
          completedMonthly++;
        }
        List l = element.time.split(':');
        hrs = hrs + int.parse(l[0]);
        min = min + int.parse(l[1]);
        List lst = l[2].split('.');
        sec = sec + int.parse(lst[0]);
      }
      final duration = Duration(hours: hrs, minutes: min, seconds: sec);
      timeMonthly = _printDuration(duration);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: DrawerNavigation(selectedDestination: 3),
        body: FutureBuilder(
            future: _dayList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    _buildProgressReportDaily(snapshot.data);
                    return Center(
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(completedDaily.toString()),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text('$timeDaily'),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                      ),
                    ); //Container
                  }
                  else if (index == 1) {
                    _buildProgressReportWeekly(snapshot.data);
                    return Center(
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                        child: Text(completedWeekly.toString()),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                        child: Text('$timeWeekly'),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                      ),
                    );
                  }
                  else if (index == 2) {
                    _buildProgressReportMonthly(snapshot.data);
                    return Center(
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueAccent,
                                      ),
                                      child: Center(
                                        child: Text(completedMonthly.toString()),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueAccent,
                                      ),
                                      child: Center(
                                        child: Text('$timeMonthly'),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                      ),
                    );
                  }
                  return Container(
                    height: 100.0,
                    width: double.infinity,
                    color: Colors.indigo,
                  );
                },
              );
            }
        )

    );
  }
}