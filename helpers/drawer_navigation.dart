import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_na_to/screens/analytics_screen.dart';
import 'package:to_do_na_to/screens/home_screen.dart';
import 'package:to_do_na_to/screens/scheduler_screen.dart';
import 'package:to_do_na_to/screens/settings_screen.dart';
import 'package:to_do_na_to/screens/timer_screen.dart';

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
  void initState(){
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
                  child  : Text('MENU', style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  )),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                  ),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(left: 20.0, top: 15.0),
             ),
            ListTile(
              leading: Icon(Icons.chrome_reader_mode_outlined),
              title: Text('Dashboard'),
              selected: _selectedDestination == 0,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(selectedDestination:0,),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
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
            Divider(
              height: 1,
              thickness: 1,
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
            Divider(
              height: 1,
              thickness: 1,
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
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notification Settings'),
              selected: _selectedDestination == 4,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(),
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
