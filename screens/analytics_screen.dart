import 'package:flutter/material.dart';
import 'package:flutter_todo_nato_app/helpers/drawer_navigation.dart';
class AnalyticsScreen extends StatefulWidget {
  int selectedDestination;

  AnalyticsScreen({this.selectedDestination});
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerNavigation(selectedDestination: 3),
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
                  Text('This is your analytics'),
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
