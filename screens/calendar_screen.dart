import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:todo_na_to/helpers/database_connection.dart';
import 'package:todo_na_to/helpers/drawer_navigation.dart';
import 'package:todo_na_to/models/task_model.dart';

import 'add_task_screen.dart';
import 'home_screen.dart';
import 'kanban_screen.dart';

class CalendarScreen extends StatefulWidget {
  int selectedDestination;

  CalendarScreen({this.selectedDestination});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  CalendarController calController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState(){
    super.initState();
    calController=CalendarController();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTasksOnDate(convertDateTimeDisplay(_selectedDate.toString()));
      print(convertDateTimeDisplay(_selectedDate.toString()));
      //_taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  getDiff() {

    var now=DateTime.now();
    if(_dateFormatter.format(_selectedDate)==_dateFormatter.format(now)) return "Today";
    return _dateFormatter.format(_selectedDate).toString();

  }

  Widget _buildTask(snapshot, index, task){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget> [
          //SizedBox(height: 10.0),
          Container(color: Colors.red),
          Dismissible(
            key: Key(task.id.toString()),
            onDismissed: (direction) {
              snapshot.data.removeAt(index-1);
              DatabaseHelper.instance.deleteTask(task.id);
              _updateTaskList();
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(
                '${task.taskName}',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${_dateFormatter.format(task.date)} • ${task.priority}',
                style: GoogleFonts.rubik(
                  color: Colors.white,
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
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        'Select display view',
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(selectedDestination: 0),
                            ),
                          ),
                          child: Text(
                            'List',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {},
                          child: Text(
                            'Calendar',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KanbanScreen(selectedDestination: 0),
                            ),
                          ),
                          child: Text(
                            'Kanban',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        onPressed: () { Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(
              updateTaskList: _updateTaskList,
            ),
          ),
        );
        },
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
            return SingleChildScrollView(
              child: Container(
                //padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    TableCalendar(
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                          weekdayStyle: TextStyle(color: Colors.indigo ,fontWeight: FontWeight.normal,fontSize: 14),
                          weekendStyle: TextStyle(color: Colors.indigo,fontWeight: FontWeight.normal,fontSize: 14),
                          selectedColor: Colors.indigo,
                          todayColor: Colors.indigo,
                          todayStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          )
                      ),
                      onDaySelected: (date,events,holiday) {
                        setState(() {
                          _selectedDate = date;
                          _updateTaskList();
                        });
                      },
                      builders: CalendarBuilders(
                          selectedDayBuilder: (context,date,events)=>
                              Container(
                                margin: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.indigo,

                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),),
                              )
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold
                          ),
                          weekdayStyle: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold
                          )

                      ),
                      headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          centerHeaderTitle: true,
                          titleTextStyle: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.only(left: 15,right: 10),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(30))
                      ),
                      child: Container(
                        child: ListView.builder(
                          itemCount: 1 + snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){
                            if (index == 0) {
                              print(index);
                              print(snapshot.data);
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 50,),
                                    Text(

                                      getDiff(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            print(index);
                            print(snapshot.data);

                            return _buildTask(snapshot, index, snapshot.data[index - 1]);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          }
      ),
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
