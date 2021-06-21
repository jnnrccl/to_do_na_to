import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_na_to/helpers/local_notification.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/utils/validator.dart';

// ignore: must_be_immutable
class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  Task task;
  AddTaskScreen({this.updateTaskList, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _subjectName = '';
  String _taskName = '';
  String _priority;
  DateTime _date = DateTime.now();
  List <String> _scheduler = [];
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
  //final List<String> _priorities = ['Low', 'Medium', 'High'];

  bool enableNotif = false;
  bool alreadyIn = false;

  List<Task> taskList;

  @override
  void initState() {
    super.initState();
    _setVal();
    if (widget.task != null) {
      _subjectName = widget.task.subjectName;
      _taskName = widget.task.taskName;
      _priority = widget.task.priority;
      _date = widget.task.date;
      _scheduler = widget.task.scheduler;
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  _setVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enableNotif = prefs.getBool('enable_notif') ?? false;
    });
  }

  _handleDatePicker() async {
    final DateTime onlyDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (onlyDate != null) {
      final TimeOfDay onlyTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (onlyTime != null) {
        var finalDate = DateTime(onlyDate.year, onlyDate.month, onlyDate.day,
            onlyTime.hour, onlyTime.minute);
        if (finalDate != null && finalDate != _date) {
          setState(() {
            _date = finalDate;
          });
          _dateController.text = _dateFormatter.format(finalDate);
        }
      }
    }
  }

  bool itIsThere(){
    return true;
  }

  Future <bool> isItPresent(Task localTask) async {
    taskList = await DatabaseConnection.instance.getTaskToDoList();

    for (Task task in taskList){
      if (task.subjectName.toLowerCase() == localTask.subjectName.toLowerCase()
          && task.taskName.toLowerCase() == localTask.taskName.toLowerCase()){
        return true;
      }
    }
    return false;
  }

  bool isNotSameTask(localTask){
    if (widget.task.subjectName.toLowerCase() == localTask.subjectName.toLowerCase()
        && widget.task.taskName.toLowerCase() == localTask.taskName.toLowerCase()){
      return false;
    }
    else
      return true;
  }

  static var id = Random.secure();
  _submit() async {
    var next = id.nextInt(500);
    Task localTask;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_subjectName, $_taskName, $_date, $_priority, $_scheduler');
      localTask = Task.withID(
        id: widget.task?.id ?? next,
        subjectName: _subjectName,
        taskName: _taskName,
        priority: _priority,
        date: _date,
        scheduler: _scheduler,
        stopTime: "00:00:00:00",
      );
      //CREATE TASK
      if (widget.task == null) {
        localTask.status = 0;
        alreadyIn = false;
        alreadyIn = await isItPresent(localTask);
        if (alreadyIn == false){
          DatabaseConnection.instance.insertTask(localTask);
          if (enableNotif == true)
            Notifications().scheduleTask(localTask);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text(
                "Subject Name and Task Name already exist.",
                key: const Key("Error"),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

      }
      //UPDATE TASK
      else {
        localTask.status = widget.task.status;
        alreadyIn = false;
        alreadyIn = isNotSameTask(localTask);
        if (alreadyIn == false){
          DatabaseConnection.instance.updateTask(localTask);
          print('$_scheduler');
          if (enableNotif == true)
            Notifications().updateTask(localTask);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text(
                "Subject Name and Task Name already exist.",
                key: const Key("Error"),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 22.0,
            color: Colors.indigo,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('floating-save'),
        backgroundColor: Colors.indigo,
        child: Icon(Icons.save_rounded, color: Colors.white),
        onPressed: _submit,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.task == null ? 'Add a task' : 'Edit task',
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          key: Key('subject-name'),
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Subject Name',
                            labelStyle: GoogleFonts.rubik(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: FieldValidator.validateSubjectName,
                          onSaved: (input) => _subjectName = input,
                          initialValue: _subjectName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          key: Key('task-name'),
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Task Name',
                              labelStyle: GoogleFonts.rubik(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          validator: FieldValidator.validateTaskName,
                          onSaved: (input) => _taskName = input,
                          initialValue: _taskName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          key: Key('deadline'),
                          readOnly: true,
                          controller: _dateController,
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          onTap: _handleDatePicker,
                          validator: FieldValidator.validateDate,
                          decoration: InputDecoration(
                              labelText: 'Deadline',
                              labelStyle: GoogleFonts.rubik(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField(
                          key: Key('priority'),
                          icon: Icon(Icons.arrow_drop_down),
                          //iconSize: 25.0,
                          iconEnabledColor: Colors.indigo,
                          items: [
                            DropdownMenuItem<String>(
                              key: Key('low'),
                              value: 'Low',
                              child: Text(
                                'Low',
                                style: GoogleFonts.rubik(
                                  color: Colors.yellow.shade800,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              key: Key('medium'),
                              value: 'Medium',
                              child: Text(
                                'Medium',
                                style: GoogleFonts.rubik(
                                  color: Colors.orange.shade800,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              key: Key('high'),
                              value: 'High',
                              child: Text(
                                'High',
                                style: GoogleFonts.rubik(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          /*items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: GoogleFonts.rubik(
                                    color: priority == 'Low' ? Colors.yellow.shade800
                                         : priority == 'Medium' ? Colors.orange.shade800
                                         : Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),*/
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: GoogleFonts.rubik(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          validator: FieldValidator.validatePriority,
                          onChanged: (value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}