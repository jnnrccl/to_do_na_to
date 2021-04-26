import 'package:flutter/material.dart';
import 'package:to_do_na_to/helpers/drawer_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
class SchedulerScreen extends StatefulWidget {
  int selectedDestination;

  SchedulerScreen({this.selectedDestination});

  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerNavigation(selectedDestination: 1,),
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
                  Text('This is your scheduler'),
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
