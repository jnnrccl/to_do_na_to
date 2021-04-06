import 'package:flutter/material.dart';
import 'package:flutter_todo_nato_app/helpers/drawer_navigation.dart';
class SettingsScreen extends StatefulWidget {
  int selectedDestination;

  SettingsScreen({this.selectedDestination});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerNavigation(selectedDestination: 4),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 80.0),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('This is your notification settings'),
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
        },
      ),

    );
  }
}