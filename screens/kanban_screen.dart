import 'dart:async';

import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter_todo_nato_app/helpers/database_helper.dart';
import 'package:flutter_todo_nato_app/helpers/drawer_navigation.dart';
import 'package:flutter_todo_nato_app/models/board_item_model.dart';

import 'package:flutter_todo_nato_app/models/board_list_model.dart';
import 'package:flutter_todo_nato_app/models/task_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'calendar_screen.dart';
import 'home_screen.dart';

class KanbanScreen extends StatefulWidget {
  int selectedDestination;

  KanbanScreen({this.selectedDestination});

  @override
  _KanbanScreenState createState() => _KanbanScreenState();

}
class _KanbanScreenState extends State<KanbanScreen> {

  Future<List<Task>> _taskList;
  List<BoardListObject> _listData = [
    BoardListObject(title: "List title 1"),
    BoardListObject(title: "List title 2"),
    BoardListObject(title: "List title 3")
  ];

  BoardViewController boardViewController = new BoardViewController();


  @override
  void initState(){
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  List<BoardList> buildList(taskList){
    for (int j = 0; j < taskList.length; j++){
      if(taskList[j].status == 0){
        _listData[0].items.add(taskList[j]);
      }
      else{
        _listData[1].items.add(taskList[j]);
      }
    }
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return _lists;

  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int listIndex) {

      },
      onTapList: (int listIndex) async {

      },
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }

  Widget buildBoardItem(Task itemObject) {
    return BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {

        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {

          //Used to update our local item data
          var item = _listData[oldListIndex].items[oldItemIndex];

          _listData[oldListIndex].items.removeAt(oldItemIndex);

          _listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        },
        item: Container(
          margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Card(
            elevation: 0,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(itemObject.subjectName, style: TextStyle(
                        height: 1.5,
                        color: Color(0xff2F334B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10.0,),
                    Text(itemObject.taskName, style: TextStyle(
                        height: 1.5,
                        color: Color(0xff2F334B),
                        fontSize: 16
                    ),),
                  ],
                )
            ),
          ),
        ));
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
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalendarScreen(selectedDestination: 0),
                            ),
                          ),
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
      drawer: DrawerNavigation(selectedDestination: 0,),
      body: FutureBuilder (
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return BoardView(
              lists: buildList(snapshot.data),
              boardViewController: boardViewController,
            );
          }
      ),
    );
  }
}

/*class BoardViewExample extends StatelessWidget{

  List <Task> taskList;

  convertList() async{
    List<Task> futureOfList = await DatabaseHelper.instance.getTaskList();
    return futureOfList;
    //print(_listData);
  }

  List<BoardListObject> _listData = [
    BoardListObject(title: "List title 1"),
    BoardListObject(title: "List title 2"),
    BoardListObject(title: "List title 3")
  ];
  //List<Task> _listData;

  BoardViewController boardViewController = new BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return BoardView(
      lists: _lists,
      boardViewController: boardViewController,
    );
  }

  Widget buildBoardItem(Task itemObject) {
    return BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {

        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {

          //Used to update our local item data
          var item = _listData[oldListIndex].items[oldItemIndex];

          _listData[oldListIndex].items.removeAt(oldItemIndex);

          _listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        },
        item: Container(
          margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Card(
            elevation: 0,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(itemObject.subjectName, style: TextStyle(
                        height: 1.5,
                        color: Color(0xff2F334B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10.0,),
                    Text(itemObject.taskName, style: TextStyle(
                        height: 1.5,
                        color: Color(0xff2F334B),
                        fontSize: 16
                    ),),
                  ],
                )
            ),
          ),
        ));
  }

  Widget _createBoardList(BoardListObject list) {
    list.items = convertList();
    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int listIndex) {

      },
      onTapList: (int listIndex) async {

      },
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }
}*/
