import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter_todo_nato_app/helpers/drawer_navigation.dart';
import 'package:flutter_todo_nato_app/models/board_item_model.dart';

import 'package:flutter_todo_nato_app/models/board_list_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'calendar_screen.dart';
import 'home_screen.dart';

class KanbanScreen extends StatefulWidget {
  int selectedDestination;

  KanbanScreen({this.selectedDestination});

  List<BoardListObject> _listData = [
    BoardListObject(title: "List title 1"),
    BoardListObject(title: "List title 2"),
    BoardListObject(title: "List title 3")
  ];

  @override
  _KanbanScreenState createState() => _KanbanScreenState();

}
class _KanbanScreenState extends State<KanbanScreen> {

  BoardViewController boardViewController = new BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = [];
    for (int i = 0; i < widget._listData.length; i++) {
      _lists.add(_createBoardList(widget._listData[i]) as BoardList);
    }
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
      body: BoardView(
        lists: _lists,
        boardViewController: boardViewController,
      ),
    );
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {

        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = widget._listData[oldListIndex].items[oldItemIndex];
          widget._listData[oldListIndex].items.removeAt(oldItemIndex);
          widget._listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {

        },
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
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
        var list = widget._listData[oldListIndex];
        widget._listData.removeAt(oldListIndex);
        widget._listData.insert(listIndex, list);
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
}
