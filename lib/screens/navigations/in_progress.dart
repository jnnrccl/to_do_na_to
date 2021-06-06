import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/helpers/local_notification.dart';
import 'package:to_do_na_to/models/complete_task_model.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/screens/add_task_screen.dart';

// ignore: must_be_immutable
class InProgressNavigationScreen extends StatefulWidget {
  int selectedDestination;

  InProgressNavigationScreen({this.selectedDestination});

  @override
  _InProgressNavigationScreenState createState() => _InProgressNavigationScreenState();
}

class _InProgressNavigationScreenState extends State<InProgressNavigationScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM d, h:mm a');

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

  _addTaskToComplete(task) async{
    completedTask finished;
    finished = completedTask(
      date: DateTime.now(),
      time: "00:00:00.00",
    );
    if (task.status == 1) {
      finished.completed = 0;
    }
    else
      finished.completed = 1;

    DatabaseConnection.instance.insertCompletedTask(finished);
    print("DZAEEE ARI ANG SIYA");
    List list= await DatabaseConnection.instance.getCompletedTaskList();
    print (list);
  }


  Widget _buildTask(snapshot, index, Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12.0),
          Dismissible(
            key: UniqueKey(),
            background: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              margin: EdgeInsets.symmetric(vertical: 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.tealAccent.shade700,
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
                _addTaskToComplete(task);
                snapshot.data.removeAt(index-1);
              }
              Notifications().deleteTask(task);
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
                    left: BorderSide(
                      width: 10.5,
                      color:
                      task.priority == 'Low' ? Colors.yellow.shade800
                          : task.priority == 'Medium' ? Colors.orange.shade800
                          : Colors.red,
                    ),
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
                    'Due ${_dateFormatter.format(task.date)}',
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
      drawer: DrawerNavigation(selectedDestination: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
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
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        color: Colors.transparent,
                      );
                    }
                    if(snapshot.data[index - 1].status == 1){
                      return _buildTask(snapshot, index, snapshot.data[index - 1]);
                    }
                    return Container();
                  },
                  childCount: 1 + snapshot.data.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 80.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
