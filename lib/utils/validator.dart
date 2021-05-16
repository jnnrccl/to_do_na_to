import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';

class FieldValidator{

  static String validateSubjectName(String value) {
    //checkSameTaskName(value);
    if(value.trim().isEmpty){
      return 'Please enter a subject name.';
    }
    else{
      return null;
    }
  }

  static String validateTaskName(String value) {
    if(value.trim().isEmpty){
      return 'Please enter a task title.';
    }
    else{
      return null;
    }
  }

  static String validateDate(String value) {
    DateTime date = DateTime.parse(value);
    print(value);
    if (date.compareTo(DateTime.now()) < 0) {
      return 'Wrong Date Time';
    }
    else{
      return null;
    }
  }

  static String validatePriority(String value) {
    if (value == null) {
      return 'Please enter a priority level.';
    }
    else{
      return null;
    }
  }
}

/*checkSameTaskName(String value) async {
  List <Task> taskList = await DatabaseConnection.instance.getTaskList();
  checkerNotAs(taskList, value);
}

checkerNotAs(taskList, value) {
  bool found = false;
  if (value.trim().isEmpty) {
    return 'Please enter a subject name.';
  }
  else if (taskList == null){
    return null;
  }
  else {
    for (var i = 0; i < taskList.length; i++) {
      if (value.toLowerCase() == taskList[i].taskName.toLowerCase()) {
        found = true;
      }
    }
    if (found) {
      return 'Same subject name. name another one';
    }
    else {
      return null;
    }
  }
}*/
