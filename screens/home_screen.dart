import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/screens/add_task_screen.dart';

import 'calendar_screen.dart';
import 'kanban_screen.dart';

class HomeScreen extends StatefulWidget {
  int selectedDestination;

  HomeScreen({this.selectedDestination});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseConnection.instance.getTaskList();
    });
  }

  Widget _buildTask(snapshot, index, Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Dismissible(
            key: UniqueKey(),
            background: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              margin: EdgeInsets.symmetric(vertical: 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.redAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2.0,
                    offset: Offset(0.0, 1.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                    ),
                    /*Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),*/
                    Text(
                      "Delete",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.left,
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
              padding: EdgeInsets.symmetric(vertical: 10.0),
              margin: EdgeInsets.symmetric(vertical: 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.redAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2.0,
                    offset: Offset(0.0, 1.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 260.0),
                    ),
                    /*Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),*/
                    Text(
                      "Delete",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                alignment: Alignment.centerRight,
              ),
            ),
            onDismissed: (direction) {
              snapshot.data.removeAt(index-1);
              DatabaseConnection.instance.deleteTask(task.id);
              _updateTaskList();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                margin: EdgeInsets.symmetric(vertical: 3.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(width: 10.5, color: Colors.indigo),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2.0,
                      offset: Offset(0.0, 1.0), // shadow direction: bottom right
                    ),
                  ],
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
                      /*VerticalDivider(
                        color: Colors.indigo,
                        thickness: 1.3,
                      ),*/
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
                    '${_dateFormatter.format(task.date)} • ${task.priority}',
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
                      onPressed: () {},
                      child: Text(
                        'List',
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalendarScreen(selectedDestination: 0),
                            ),
                          ),
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
      drawer: DrawerNavigation(selectedDestination: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(
            Icons.add,
            //color: Colors.white,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => AddTaskScreen(
            updateTaskList: _updateTaskList,
          ),
          ),
        ),
      ),
      body: FutureBuilder(
            future: _taskList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: 1 + snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      padding: EdgeInsets.only(left: 40.0, top: 5.0, right: 40.0, bottom: 26.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(80.0),
                        ),
                        color: Colors.indigo,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hello there!',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400,
                              //fontStyle: FontStyle.normal,
                            ),
                          ),
                          //SizedBox(height: 10.0),
                          Text(
                            'This is your to-do list.',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w200,
                              //fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return _buildTask(snapshot, index, snapshot.data[index - 1]);
                },
              );
            },
          ),
    );
  }
}

