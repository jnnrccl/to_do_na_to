import'package:flutter/material.dart';
import 'package:flutter_todo_nato_app/screens/analytics_screen.dart';
import 'package:flutter_todo_nato_app/screens/home_screen.dart';
import 'package:flutter_todo_nato_app/screens/scheduler_screen.dart';
import 'package:flutter_todo_nato_app/screens/settings_screen.dart';
import 'package:flutter_todo_nato_app/screens/timer_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerNavigation extends StatefulWidget {
  int selectedDestination;

  DrawerNavigation({this.selectedDestination});
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  int _selectedDestination;
  //var h = AppBar().preferredSize.height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDestination = widget.selectedDestination;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
             DrawerHeader(
                  child  : Text('MENU', style: TextStyle(color: Colors.white, fontSize: 20)),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                  ),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(left: 20.0, top: 15.0),
             ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Dashboard'),
              selected: _selectedDestination == 0,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(selectedDestination: 0),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Scheduler'),
              selected: _selectedDestination == 1,
              onTap: () {
                //Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SchedulerScreen(selectedDestination: 1),
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text('Task Progress Timer'),
              selected: _selectedDestination == 2,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TimerScreen(selectedDestination: 2),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Analytics'),
              selected: _selectedDestination == 3,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnalyticsScreen(selectedDestination: 3),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Notification Settings'),
              selected: _selectedDestination == 4,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(selectedDestination: 4),
                ),
              ),
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
