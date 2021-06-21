import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:to_do_na_to/screens/calendar_screen.dart';
import 'package:to_do_na_to/screens/navigations/to_do_list.dart';
import 'package:to_do_na_to/screens/navigations/completed.dart';
import 'package:to_do_na_to/screens/navigations/in_progress.dart';
import '../helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends  State<HomeScreen> {
  int _pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final _pageController = PageController();
  final _navigationPages = [ToDoScreen(), InProgressNavigationScreen(), CompletedNavigationScreen()];

  ScrollController _hideBottomNavController;
  bool _isVisible;

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(() {
      if (_hideBottomNavController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
      if (_hideBottomNavController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(selectedDestination: 0),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        controller: _hideBottomNavController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: MultiSliver(
                children: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.indigo,
                    pinned: true,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(MdiIcons.calendar),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CalendarScreen(selectedDestination: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.only(left: 35.0, top: 5.0, right: 40.0, bottom: 30.0),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(60.0),
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
                                  _pageIndex == 0 ? 'Hello there!'
                                      : _pageIndex == 1 ? 'Hey!' : 'Good job!',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Text(
                                  _pageIndex == 0 ? "This is your to-do list."
                                      : _pageIndex == 1 ? "Time to finish these." : "You aced these tasks.",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
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
        body: PageView(
          children: _navigationPages,
          onPageChanged: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          controller: _pageController,
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? 50.0 : 0.0,
        child: Wrap(
          children: <Widget>[
            CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: _pageIndex,
              height: 50.0,
              items: <Widget>[
                Icon(Icons.library_add, size: 20, color: Colors.white),
                Icon(Icons.library_books, size: 20, color: Colors.white),
                Icon(Icons.library_add_check, size: 20, color: Colors.white),
              ],
              color: Colors.indigo,
              buttonBackgroundColor: Colors.indigo,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 500),
              onTap: (index) {
                setState(() {
                  //_showPage = _navigationPage(index);
                  _pageIndex = index;
                  _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.linear);
                });
              },
              letIndexChange: (index) => true,
            ),
          ],
        ),
      ),
    );
  }
}