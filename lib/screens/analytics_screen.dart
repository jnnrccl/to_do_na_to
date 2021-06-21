import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
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

  String timeHour = "";
  String timeMinute = "";
  String timeSecond = "";
  String timeHourWeekly = "";
  String timeMinuteWeekly = "";
  String timeSecondWeekly = "";
  String timeHourMonthly = "";
  String timeMinuteMonthly = "";
  String timeSecondMonthly = "";

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
    // ignore: missing_return
    String twoDigits(int n) {
      if (n >= 10) {
        n.toString().padLeft(2, "0");
      }
      else {
        n.toString();
      }
    }
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration
        .inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _printHour(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}";
  }

  String _printMinute(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "$twoDigitMinutes";
  }

  String _printSecond(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitSeconds";
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
      timeHour = _printHour(duration);
      timeMinute = _printMinute(duration);
      timeSecond = _printSecond(duration);
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
      timeHourWeekly = _printHour(duration);
      timeMinuteWeekly = _printMinute(duration);
      timeSecondWeekly = _printSecond(duration);
    }
  }

  getCompletedMonthly(dater, dateList) {
    DateTime firstDay = DateTime(dater.year, dater.month, 1);
    DateTime lastDay = DateTime(dater.year, dater.month + 1, 0);
    List <completedTask> result = [];
    print(firstDay);
    print(lastDay);

    if (dateList != null) {
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
      timeHourMonthly = _printHour(duration);
      timeMinuteMonthly = _printMinute(duration);
      timeSecondMonthly = _printSecond(duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(selectedDestination: 3),
      body: FutureBuilder(
          future: _dayList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: MultiSliver(
                      children: <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.purple,
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 35.0, top: 5.0, right: 40.0, bottom: 30.0),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple,
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Hello there!',
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      'This is your progress.',
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      if (index == 0) {
                        _buildProgressReportDaily(snapshot.data);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 140,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 25, right: 35, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                "TODAY",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.red,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  completedDaily == 0 ? "Hmm..."
                                                      : completedDaily == 1 ? "Good job!"
                                                      : "Wow!",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  completedDaily == 0 ? "Looks like you haven't done any tasks yet."
                                                      : completedDaily == 1 ? "You accomplished a task."
                                                      : "You accomplished multiple tasks.",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    completedDaily.toString(),
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 0.5,
                                                      fontSize: 60,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    completedDaily == 1 ? "task" : "tasks",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.redAccent,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$timeHour' == '00' ? " " : '$timeHour' == '01' ? '1' :
                                                      '$timeHour' == '02' ? '2' : '$timeHour' == '03' ? '3':
                                                      '$timeHour' == '04' ? '4' :'$timeHour' == '05' ? '5' :
                                                      '$timeHour' == '06' ? '6': '$timeHour' == '07' ? '7':
                                                      '$timeHour' == '08' ? '8':'$timeHour' == '09' ? '9' : '$timeHour' ,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeHour'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        '$timeHour' == '00' ? " " : 'h ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeHour'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeMinute' == '00' ? " " : '$timeMinute' == '01' ? '1' :
                                                      '$timeMinute' == '02' ? '2' : '$timeMinute' == '03' ? '3':
                                                      '$timeMinute' == '04' ? '4' :'$timeMinute' == '05' ? '5' :
                                                      '$timeMinute' == '06' ? '6': '$timeMinute' == '07' ? '7':
                                                      '$timeMinute' == '08' ? '8':'$timeMinute' == '09' ? '9' : '$timeMinute',
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeMinute'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        '$timeMinute' == '00' ? " " : 'm ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeMinute'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeSecond' == '00' ? "0" : '$timeSecond' == '01' ? '1' :
                                                      '$timeSecond' == '02' ? '2' : '$timeSecond' == '03' ? '3':
                                                      '$timeSecond' == '04' ? '4' :'$timeSecond' == '05' ? '5' :
                                                      '$timeSecond' == '06' ? '6': '$timeSecond' == '07' ? '7':
                                                      '$timeSecond' == '08' ? '8':'$timeSecond' == '09' ? '9' : '$timeSecond',
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        's',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "spent",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else if (index == 1) {
                        _buildProgressReportWeekly(snapshot.data);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 140,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 25, right: 35, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                "WEEKLY",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.deepOrange,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  completedWeekly == 0 ? "Hmm..."
                                                      : completedWeekly == 1 ? "Good job!"
                                                      : "Wow!",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  completedWeekly == 0 ? "Looks like you haven't done any tasks yet."
                                                      : completedWeekly == 1 ? "You accomplished a task."
                                                      : "You accomplished multiple tasks.",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    completedWeekly.toString(),
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 0.5,
                                                      fontSize: 60,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    completedWeekly == 1 ? "task" : "tasks",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.deepOrangeAccent,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$timeHourWeekly' == '00' ? " " : '$timeHourWeekly' == '01' ? '1' :
                                                      '$timeHourWeekly' == '02' ? '2' : '$timeHourWeekly' == '03' ? '3':
                                                      '$timeHourWeekly' == '04' ? '4' :'$timeHourWeekly' == '05' ? '5' :
                                                      '$timeHourWeekly' == '06' ? '6': '$timeHourWeekly' == '07' ? '7':
                                                      '$timeHourWeekly' == '08' ? '8':'$timeHourWeekly' == '09' ? '9' : "$timeHourWeekly" ,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeHourWeekly'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        '$timeHourWeekly' == '00' ? " ": 'h ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeHourWeekly'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeMinuteWeekly' == '00' ? " " : '$timeMinuteWeekly' == '01' ? '1' :
                                                      '$timeMinuteWeekly' == '02' ? '2' : '$timeMinuteWeekly' == '03' ? '3':
                                                      '$timeMinuteWeekly' == '04' ? '4' :'$timeMinuteWeekly' == '05' ? '5' :
                                                      '$timeMinuteWeekly' == '06' ? '6': '$timeMinuteWeekly' == '07' ? '7':
                                                      '$timeMinuteWeekly' == '08' ? '8':'$timeMinuteWeekly' == '09' ? '9' : "$timeMinuteWeekly",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeMinuteWeekly'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        '$timeMinuteWeekly' == '00' ? " " : 'm ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeMinuteWeekly'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeSecondWeekly' == '00' ? "0" : '$timeSecondWeekly' == '01' ? '1' :
                                                      '$timeSecondWeekly' == '02' ? '2' : '$timeSecondWeekly' == '03' ? '3':
                                                      '$timeSecondWeekly' == '04' ? '4' :'$timeSecondWeekly' == '05' ? '5' :
                                                      '$timeSecondWeekly' == '06' ? '6': '$timeSecondWeekly' == '07' ? '7':
                                                      '$timeSecondWeekly' == '08' ? '8':'$timeSecondWeekly' == '09' ? '9' : "$timeSecondWeekly",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        's',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "spent",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else if (index == 2) {
                        _buildProgressReportMonthly(snapshot.data);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 140,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 25, right: 35, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                "MONTHLY",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.green,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade400,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  completedMonthly == 0 ? "Hmm..."
                                                      : completedMonthly == 1 ? "Good job!"
                                                      : "Wow!",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  completedMonthly == 0 ? "Looks like you haven't done any tasks yet."
                                                      : completedMonthly == 1 ? "You accomplished a task."
                                                      : "You accomplished multiple tasks.",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    completedMonthly.toString(),
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 0.5,
                                                      fontSize: 60,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    completedMonthly == 1 ? "task" : "tasks",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                /*boxShadow:[
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],*/
                                color: Colors.green.shade400,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Stack(
                                    children: <Widget> [
                                      Container(
                                        width: 210,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 210,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$timeHourMonthly' == '00' ? " " : '$timeHourMonthly' == '01' ? '1' :
                                                      '$timeHourMonthly' == '02' ? '2' : '$timeHourMonthly' == '03' ? '3':
                                                      '$timeHourMonthly' == '04' ? '4' :'$timeHourMonthly' == '05' ? '5' :
                                                      '$timeHourMonthly' == '06' ? '6': '$timeHourMonthly' == '07' ? '7':
                                                      '$timeHourMonthly' == '08' ? '8':'$timeHourMonthly' == '09' ? '9' : "$timeHourMonthly",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeHourMonthly'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        '$timeHourMonthly'== '00' ? " " : 'h ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeHourMonthly'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeMinuteMonthly' == '00' ? " " : '$timeMinuteMonthly' == '01' ? '1' :
                                                      '$timeMinuteMonthly' == '02' ? '2' : '$timeMinuteMonthly' == '03' ? '3':
                                                      '$timeMinuteMonthly' == '04' ? '4' :'$timeMinuteMonthly' == '05' ? '5' :
                                                      '$timeMinuteMonthly' == '06' ? '6': '$timeMinuteMonthly' == '07' ? '7':
                                                      '$timeMinuteMonthly' == '08' ? '8':'$timeMinuteMonthly' == '09' ? '9' : "$timeMinuteMonthly",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: '$timeMinuteMonthly'== '00' ? 0 : 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        '$timeMinuteMonthly' == '00' ? " " : 'm ',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: '$timeMinuteMonthly'== '00' ? 0 : 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$timeSecondMonthly' == '00' ? "0" : '$timeSecondMonthly' == '01' ? '1' :
                                                      '$timeSecondMonthly' == '02' ? '2' : '$timeSecondMonthly' == '03' ? '3':
                                                      '$timeSecondMonthly' == '04' ? '4' :'$timeSecondMonthly' == '05' ? '5' :
                                                      '$timeSecondMonthly' == '06' ? '6': '$timeSecondMonthly' == '07' ? '7':
                                                      '$timeSecondMonthly' == '08' ? '8':'$timeSecondMonthly' == '09' ? '9' : "$timeSecondMonthly",
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        's',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "spent",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      height: 1.0,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container(
                        height: 100.0,
                        width: double.infinity,
                        color: Colors.purple,
                      );
                    }, childCount: 3,),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20.0,
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}