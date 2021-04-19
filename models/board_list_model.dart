
import 'package:flutter_todo_nato_app/models/task_model.dart';

class BoardListObject{

  String title;
  List<Task> items;

  BoardListObject({this.title,this.items}){
    if(this.title == null){
      this.title = "";
    }
    if(this.items == null){
      this.items = [];
    }
  }
}
