import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/screens/home_screen.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  int selectedDestination;

  CalendarScreen({this.selectedDestination});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM d');
  CalendarController calController;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<dynamic>> _events;

  @override
  void initState(){
    super.initState();
    calController = CalendarController();
    _events = {};
    //_selectedEvents = [];
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      //_taskList = DatabaseConnection.instance.getTasksOnDate(convertDateTimeDisplay(_selectedDate.toString()));
      print(convertDateTimeDisplay(_selectedDate.toString()));
      _taskList = DatabaseConnection.instance.getTaskList();
    });
  }

  Map<DateTime, List<dynamic>> _fromModelToEvent(List<Task> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.date.year, event.date.month, event.date.day, 12);
      if (data[date] == null) data[date] = [];
      if(event.status != 2) {
        data[date].add(event);
      }
    });
    return data;
  }

  getDiff() {
    var now = DateTime.now();
    if(_dateFormatter.format(_selectedDate)==_dateFormatter.format(now)) return "Today";
    return _dateFormatter.format(_selectedDate).toString();
  }

  Widget _buildTask(snapshot, index, task){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
        Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Dismissible(
              key: UniqueKey(),
              background: Container(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                margin: EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.tealAccent.shade700,
                ),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                      ),
                      Text(
                        "Complete",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  //alignment: Alignment.centerLeft,
                ),
              ),
              secondaryBackground: Container(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                margin: EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent,
                ),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 260.0),
                      ),
                      Text(
                        "Delete",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart){
                  snapshot.data.removeAt(index-1);
                  DatabaseConnection.instance.deleteTask(task.id);
                }
                else{
                  task.status = 2;
                  DatabaseConnection.instance.updateTask(task);
                  //print(snapshot.data[index-1].status);
                  snapshot.data.removeAt(index-1);
                }
                _updateTaskList();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                margin: EdgeInsets.symmetric(vertical: 3.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Container(
                        width: 95.0,
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${task.subjectName}',
                              style: GoogleFonts.rubik(
                                color: Colors.indigo,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    '${task.taskName}',
                    style: GoogleFonts.rubik(
                      color: Colors.indigo,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${task.priority}',
                    style: GoogleFonts.rubik(
                      color: Colors.indigo,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddTaskScreen(
                      updateTaskList: _updateTaskList,
                      task: task,
                    ),),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent.shade700,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () { Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(
              updateTaskList: _updateTaskList,
            ),
          ),
        );},
      ),
      drawer: DrawerNavigation(selectedDestination: 0),
      body: FutureBuilder (
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData){
              List<Task> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _fromModelToEvent(allEvents);
              }
            }
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(MdiIcons.formatListBulletedSquare),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 35.0, top: 5.0, right: 40.0, bottom: 30.0),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(60.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo,
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
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Text(
                              'This is your calendar.',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2.0,
                              offset: Offset(0.0, 1.0), // shadow direction: bottom right
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            TableCalendar(
                              events: _events,
                              startingDayOfWeek: StartingDayOfWeek.sunday,
                              calendarStyle: CalendarStyle(
                                weekdayStyle: GoogleFonts.rubik(color: Colors.indigo ,fontWeight: FontWeight.normal,fontSize: 14),
                                weekendStyle: GoogleFonts.rubik(color: Colors.indigo,fontWeight: FontWeight.normal,fontSize: 14),
                                selectedColor: Colors.indigo,
                                todayColor: Colors.indigo,
                                todayStyle: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.white
                                ),
                              ),
                              onDaySelected: (date,events,holiday) {
                                setState(() {
                                  //_selectedEvents = events;
                                  _selectedDate = date;
                                  _updateTaskList();
                                });
                              },
                              builders: CalendarBuilders(
                                selectedDayBuilder: (context,date,events) =>
                                    Container(
                                      margin: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.tealAccent.shade700,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        date.day.toString(),
                                        style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekendStyle: GoogleFonts.rubik(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w600,
                                ),
                                weekdayStyle: GoogleFonts.rubik(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  centerHeaderTitle: true,
                                  titleTextStyle: GoogleFonts.rubik(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left,
                                    color: Colors.indigo,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right,
                                    color: Colors.indigo,
                                  )
                              ),
                              calendarController: calController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo,
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
                                    "Due",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    getDiff(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //SizedBox(height: 10),
                          ],
                        );
                      }
                      DateTime day = snapshot.data[index-1].date;

                      if(day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day){
                        if(snapshot.data[index-1].status == 0 || snapshot.data[index-1].status == 1)
                        return _buildTask(snapshot, index, snapshot.data[index-1]);
                      }

                      return Container(color: Colors.indigo);
                    },
                    childCount: 1 + snapshot.data.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo,
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.indigo),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormatter = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormatter.parse(date);
  final String formatted = serverFormatter.format(displayDate);
  return formatted;
}
