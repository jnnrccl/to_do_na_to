import 'package:flutter/material.dart';
import 'package:flutter_todo_nato_app/helpers/drawer_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'home_screen.dart';

class CalendarScreen extends StatefulWidget {
  int selectedDestination;

  CalendarScreen({this.selectedDestination});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight){
    return TextStyle(color: Color(0xff30384c), fontWeight:fontWeight);
  }
  @override
  void initState(){
    super.initState();
    _controller = CalendarController();
  }
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        'Select display view',
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(selectedDestination: 0),
                            ),
                          ),
                          child: Text(
                            'List',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {},
                          child: Text(
                            'Calendar',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {},
                          child: Text(
                            'Kanban',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
          ]
      ),
      drawer: DrawerNavigation(selectedDestination: 0),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //SizedBox(height: 30.0),
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  weekdayStyle: dayStyle(FontWeight.normal),
                  weekendStyle: dayStyle(FontWeight.normal),
                  selectedColor: Colors.indigo,
                  todayColor: Colors.indigo,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color(0xff30384c),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  weekendStyle: TextStyle(
                    color: Color(0xff30384c),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Color(0xff30384c),
                    fontSize: 20, fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xff30384c),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Color(0xff30384c),
                  ),
                ),
                calendarController: _controller,
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left:30.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((50)),
                      topRight: Radius.circular((50))
                  ),
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
