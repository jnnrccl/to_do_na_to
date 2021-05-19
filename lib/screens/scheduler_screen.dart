import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');
  List<dynamic> _elements = [];

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
          print('date');
          print(dateTime);
          DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
          String formattedTime = DateFormat.jm().format(dateTime);
          Map map = {'taskName': element.taskName, 'date': _dateFormatter.format(date).toString(), 'time': formattedTime};
          _elements.add(map);
        }

      }
    }
    print(_elements);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
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
      body: NestedScrollView(
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
                              bottomRight: Radius.circular(60.0),
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
          ];},
        body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData){
              List<Task> elem = snapshot.data;
              if (elem.isNotEmpty) {
                _fromModelToElements(elem);
              }
            }
            return GroupedListView<dynamic, String>(
              elements: _elements,
              groupBy: (element) => element['date'],
              groupComparator: (value1,
                  value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1['taskName'].compareTo(item2['taskName']),
              order: GroupedListOrder.DESC,
              // useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (c, element) {
                return Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0,
                      vertical: 6.0),
                  child: Container(
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0,
                          vertical: 10.0),
                      //leading: Icon(Icons.account_circle),
                      title: Text(
                        element['time'] + '   ' + element['taskName'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        /*body: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
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
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
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
              ),*/
      ),
    );
  }
}