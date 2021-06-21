import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/screens/analytics_screen.dart';
import 'package:to_do_na_to/screens/scheduler_screen.dart';
import 'package:to_do_na_to/screens/timer_screen.dart';
import '../screens/home_screen.dart';
import 'database_connection.dart';
import 'local_notification.dart';

// ignore: must_be_immutable
class DrawerNavigation extends StatefulWidget {
  int selectedDestination;
  DrawerNavigation({this.selectedDestination});
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

Notifications _notifications = Notifications();

class _DrawerNavigationState extends State<DrawerNavigation> {
  int _selectedDestination;
  Future<List<Task>> allTasks;
  List <Task> taskList;
  bool enableNotif = false;

  @override
  void initState(){
    super.initState();
    _setVal();
    _selectedDestination = widget.selectedDestination;
  }

  _setVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enableNotif = prefs.getBool('enable_notif') ?? false;
    });
    await prefs.setBool('enable_notif', enableNotif);
  }

  _changeVal(String key, bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  _handleNotifications() async {
    List taskList = await DatabaseConnection.instance.getTaskList();
    var len = taskList.length-1;
    if (enableNotif == true) {
      for (var i = 0; i<= len; i++) {
        Notifications().scheduleTask(taskList[i]);
      }
    }
    else {
      await _notifications.cancelNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
            DrawerHeader(
              child: Text(
                'MENU',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 20.0, top: 15.0),
            ),
            ListTile(
              leading: Icon(Icons.chrome_reader_mode_outlined),
              title: Text(
                'Dashboard',
                /*style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w500,
                ),*/
              ),
              selected: _selectedDestination == 0,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Scheduler'),
              selected: _selectedDestination == 1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SchedulerScreen(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Task Progress Timer'),
              selected: _selectedDestination == 2,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TimerScreen(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Analytics'),
              selected: _selectedDestination == 3,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnalyticsScreen(),
                ),
              ),
            ),
            Divider(),
            SwitchListTile(
              activeColor: Colors.indigo,
              title: Text('Enable Notifications'),
              value: enableNotif,
              onChanged: (bool value) {
                setState(() {
                  _changeVal('enable_notif', value);
                  enableNotif = value;
                });
                _handleNotifications();
              },
            ),
          ],
        ),
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}