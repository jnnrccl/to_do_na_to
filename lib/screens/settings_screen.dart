import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_na_to/helpers/local_notification.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  int selectedDestination;

  SettingsScreen({this.selectedDestination});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

Notifications _notifications = Notifications();

class _SettingsScreenState extends State<SettingsScreen> {

  Future<List<Task>> allTasks;
  List <Task> taskList;

  bool enableNotif = false;

  @override
  void initState() {
    super.initState();
    _setVal();
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
    return Scaffold(
      appBar: AppBar(title:(Text('Notification Settings',style: GoogleFonts.rubik(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w400) ,)),
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerNavigation(selectedDestination: 4),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //_buildCheckbox(),
                    SwitchListTile(
                      title: (Text('Enable Notifications',
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100,))),
                      value: enableNotif,
                      onChanged: (bool value) {
                        setState(() {
                          _changeVal('enable_notif', value);
                          enableNotif = value;
                        });
                        _handleNotifications();
                      },
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              );
            }
            return Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.indigo,
            );
          }
      ),
    );
  }
}