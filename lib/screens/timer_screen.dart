import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/models/complete_task_model.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

// ignore: must_be_immutable
class TimerScreen extends StatefulWidget {
  int selectedDestination;
  TimerScreen({this.selectedDestination});
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Future<List<Task>> _taskList;
  String chosenTask = "No Task Selected";
  bool isInProgress = false;
  bool isSelected = false;
  bool _isRunning = false;
  final isHour = true;
  bool _isPause = true;
  String stopTime = "";
  Task taskForStopUpdate;
  final DateFormat _dateFormatter = DateFormat('MMM d, h:mm a');
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseConnection.instance.getTaskList();
    });
  }


  _addTaskToComplete(task, stopTime) async{
    completedTask finished;
    finished = completedTask(
      date: DateTime.now(),
      time: stopTime,
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

  _handleUpdateListAfterStopTime(taskForStopUpdate,stopTime) async {
    _updateTaskList();
    List taskList = await DatabaseConnection.instance.getTaskList();
    var len = taskList.length - 1;
    for (var i = 0; i <= len; i++) {
      Task taskObj = taskList[i];
      log('Update List for stop time is ' + taskObj.stopTime);
    }
  }

  Widget _buildTask(snapshot, index, task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              margin: EdgeInsets.symmetric(vertical: 3.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card( //ripple effect
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                borderOnForeground: true,
                elevation: 0,
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 95.0,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${task.subjectName}',
                                style: GoogleFonts.rubik(
                                  color: Colors.deepPurple,
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
                        color: Colors.deepPurple,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Due ${_dateFormatter.format(task.date)} • ${task.priority}',
                      style: GoogleFonts.rubik(
                        color: Colors.deepPurple,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    //selected: isSelected,
                    //selectedTileColor: Colors.grey,
                    onTap: () => setState(() {
                      if (!isInProgress|| _isPause) {
                        isSelected = true;
                        isInProgress = true;
                        setState(() {
                          chosenTask = "${task.subjectName} • ${task.taskName}";
                          taskForStopUpdate = task;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Stop or Reset timer for task $chosenTask first",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }
                    )
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple,
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
      drawer: DrawerNavigation(selectedDestination: 2),
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
                SliverAppBar(
                  backgroundColor: Colors.deepPurple,
                  centerTitle: true,
                  title: Text(
                    "Task Progress Timer",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:50.0),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500.0),
                                  border: Border.all(
                                    color: Colors.deepPurple[100],
                                    width: 10.0,
                                  ),
                                ),
                                child: StreamBuilder<int>(
                                  stream: _stopWatchTimer.rawTime,
                                  initialData: 0,
                                  builder: (context, snapshot) {
                                    final value = snapshot.data;
                                    final displayTime = StopWatchTimer.getDisplayTime(value, hours: isHour);
                                    stopTime = displayTime;
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                        child: Text(
                                          displayTime,
                                          style: GoogleFonts.rubik(
                                            color: Colors.deepPurple,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              color: Colors.deepPurple[100],
                              hoverColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {},
                              child: Text(
                                chosenTask.toString(),
                                style: GoogleFonts.rubik(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    padding: EdgeInsets.only(top: 12.0),
                                    icon: Icon(
                                        Icons.refresh_rounded,
                                        size: 40.0,
                                        color: Colors.deepPurple
                                    ),
                                    onPressed: () {
                                      if (_isRunning == true) {
                                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.deepPurple,
                                                content: Text(
                                                  "Are you sure you want to reset the timer?",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        color: Colors.deepPurple,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(5.0),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            isInProgress = false;
                                                            isSelected = false;
                                                            chosenTask = "";
                                                            _isPause = true;
                                                            _isRunning = false;
                                                          });
                                                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: GoogleFonts
                                                              .rubik(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.0,
                                                      ),
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        color: Colors.deepPurple,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isPause = false;
                                                          });
                                                          Navigator.pop(context);
                                                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                                        },
                                                        child: Text(
                                                          "No",
                                                          style:
                                                          GoogleFonts.rubik(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    }
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(top: 8.0),
                                    icon: Icon(
                                      _isPause
                                          ? Icons.play_arrow_rounded
                                          : Icons.pause_rounded,
                                      size: 48.0,
                                      color:Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          if(_isPause){
                                            // isInProgress = true;
                                            _isPause = false;
                                            _isRunning = true;
                                            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                          }
                                          else{
                                            _isPause = true;
                                            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                          }
                                        }
                                        else {
                                          Fluttertoast.showToast(
                                              msg: "Please select a task first!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 20.0);
                                        }
                                      });
                                    }),
                                SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(top: 8.0),
                                    icon: Icon(
                                      Icons.stop_rounded,
                                      size: 48.0,
                                      color:Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      if (_isRunning == true) {
                                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.deepPurple,
                                                content: Text(
                                                  "Are you done with the task?",
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        color: Colors.deepPurple,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0)),
                                                        onPressed: () {
                                                          //task progress is extracted here
                                                          taskForStopUpdate.stopTime = stopTime;
                                                          taskForStopUpdate.status = 2;
                                                          DatabaseConnection.instance.updateTask(taskForStopUpdate);
                                                          _handleUpdateListAfterStopTime(taskForStopUpdate,stopTime);
                                                          log('$chosenTask stop time is $stopTime');
                                                          //here
                                                          _addTaskToComplete(taskForStopUpdate, stopTime);
                                                          setState(() {
                                                            isInProgress = false;
                                                            isSelected = false;
                                                            chosenTask = "";
                                                            _isPause = true;
                                                            _isRunning = false;
                                                          });
                                                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style:
                                                          GoogleFonts.rubik(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.0,
                                                      ),
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        color: Colors.deepPurple,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0)),
                                                        onPressed: () {
                                                          //task progress is extracted here
                                                          taskForStopUpdate.stopTime = stopTime;
                                                          taskForStopUpdate.status = 1;
                                                          DatabaseConnection.instance.updateTask(taskForStopUpdate);
                                                          _handleUpdateListAfterStopTime(taskForStopUpdate,stopTime);
                                                          log('$chosenTask stop time is $stopTime');
                                                          //here
                                                          _addTaskToComplete(taskForStopUpdate, stopTime);
                                                          setState(() {
                                                            isInProgress = false;
                                                            isSelected = false;
                                                            chosenTask = "";
                                                            _isPause = true;
                                                            _isRunning = false;
                                                          });
                                                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "No",
                                                          style:
                                                          GoogleFonts.rubik(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                        );
                                      }
                                    }
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 22.0),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple,
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
                                    "Select a task",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //SizedBox(height: 10),
                          ],
                        );
                      }
                      if (index == 0) {
                        return Container(color: Colors.transparent);
                      }
                      if (snapshot.data[index - 1].status == 0 || snapshot.data[index - 1].status == 1) {
                        return _buildTask(snapshot, index, snapshot.data[index - 1]);
                      }
                      return Container(color: Colors.deepPurple);
                    },
                    childCount: 1 + snapshot.data.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple,
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
                    decoration: BoxDecoration(color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
