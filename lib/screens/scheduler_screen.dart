import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_na_to/helpers/local_notification.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'set_schedule_screen.dart';

// ignore: must_be_immutable
class SchedulerScreen extends StatefulWidget {
  int selectedDestination;

  SchedulerScreen({this.selectedDestination});

  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM d');
  List<dynamic> _elements = [];
  List<Task> elem = [];
  List <String> listSchedule = [];
  var grouped;

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

  _fromModelToElements(List elem){
    _elements.clear();
    if(elem != null){
      for (Task element in elem){
        for(String text in element.scheduler){
          DateTime dateTime = DateTime.parse(text);
          //print('date');
          //print(dateTime);
          DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
          String formattedTime = DateFormat.jm().format(dateTime);
          Map map = {
            'subjectName': element.subjectName,
            'taskName': element.taskName,
            'date': _dateFormatter.format(date).toString(),
            'time': formattedTime,
            'dateTime': dateTime,
          };
          _elements.add(map);
        }
      }
      grouped = groupBy(_elements, (obj) => obj['date']);
    }

  }

  _updateSchedule(element){
    for (Task task in elem) {
      if(task.taskName == element['taskName']){
        listSchedule = task.scheduler;
        listSchedule.remove(element['dateTime'].toString());
        //print(listSchedule);
        task.scheduler = listSchedule;
        DatabaseConnection.instance.updateTask(task);
        Task tempTask;
        tempTask = Task.withID(
          id: task.id,
          subjectName: task.subjectName,
          taskName: task.taskName,
          priority: task.priority,
          date: element['dateTime'],
          status: task.status,
          scheduler: listSchedule,
        );
        Notifications().deleteTask(tempTask);
      }
    }
  }

  int getLen(grouped){
    if (grouped == null){
      return 0;
    }
    else{
      return grouped.keys.length;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent.shade700,
        child: Icon(MdiIcons.pencil, color: Colors.white),
        onPressed: () { Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SetScheduleScreen(
              updateTaskList: _updateTaskList,
            ),
          ),
        );},
      ),
      drawer: DrawerNavigation(selectedDestination: 1),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData){
              elem = snapshot.data;
              if (elem.isNotEmpty) {
                _fromModelToElements(elem);
              }
            }
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: MultiSliver(
                      children: <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.blue.shade800,
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 35.0, top: 5.0, right: 40.0, bottom: 30.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade800,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(40.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade800,
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
                                      'This is your schedule.',
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
                slivers: <Widget> [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          color: Colors.transparent,
                        );
                      }
                      String dates = grouped.keys.toList()[index-1];
                      final scheds = grouped[dates];

                      scheds.sort((a,b) {
                        DateTime first = a['dateTime'];
                        DateTime second = b['dateTime'];
                        return first.compareTo(second);
                      });

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              dates,
                              style: GoogleFonts.rubik(
                                color: Colors.blue.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: scheds.length,
                              itemBuilder: (context, index){
                                return Column(
                                  children: <Widget>[
                                    Dismissible(
                                      key: UniqueKey(),
                                      background: Container(
                                        padding: EdgeInsets.symmetric(vertical: 3.0),
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 15.0),
                                              child: Text(
                                                "Delete",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        padding: EdgeInsets.symmetric(vertical: 3.0),
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 15.0),
                                              child: Text(
                                                "Delete",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        _elements.remove(scheds[index]);
                                        _updateSchedule(scheds[index]);
                                        _updateTaskList();
                                      },
                                      confirmDismiss: (DismissDirection dismissDirection) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Confirm",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              content: Text(
                                                "Are you sure?",
                                                style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: Text(
                                                    "Yes",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.blue.shade800,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: Text(
                                                    "No",
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.blue.shade800,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 85,
                                        margin: EdgeInsets.symmetric(vertical: 3.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              blurRadius: 2,
                                              offset: Offset(3,3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          child: Container(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade800,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget> [
                                                    Container(
                                                      width: 120,
                                                      padding: EdgeInsets.only(left: 28.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            scheds[index]['time'],
                                                            style: GoogleFonts.rubik(
                                                              color: Colors.blue.shade800,
                                                              fontSize: 14.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 15.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              scheds[index]['subjectName'],
                                                              style: GoogleFonts.rubik(
                                                                color: Colors.blue.shade800,
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            SizedBox(height: 3.0),
                                                            Text(
                                                              scheds[index]['taskName'],
                                                              style: GoogleFonts.rubik(
                                                                color: Colors.blue.shade800,
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                /*ListTile(
                                                  leading: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget> [
                                                      Container(
                                                        width: 95.0,
                                                        child: Center(
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              scheds[index]['time'],
                                                              style: GoogleFonts.rubik(
                                                                color: Colors.blue.shade800,
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
                                                    scheds[index]['subjectName'],
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.blue.shade800,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    scheds[index]['taskName'],
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.blue.shade800,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                        childCount: getLen(grouped) + 1),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 80.0),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}