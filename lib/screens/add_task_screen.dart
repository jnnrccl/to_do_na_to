import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:to_do_na_to/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  final Task task;
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
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if(widget.task != null) {
      _subjectName = widget.task.subjectName;
      _taskName = widget.task.taskName;
      _priority = widget.task.priority;
      _date = widget.task.date;
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_subjectName, $_taskName, $_date, $_priority');

      //Insert the task to the user's database
      Task task = Task(
        subjectName: _subjectName,
        taskName: _taskName,
        priority: _priority,
        date: _date,
      );
      if(widget.task == null) {
        task.status = 0;
        DatabaseConnection.instance.insertTask(task);
      }
      else {
        //Update the task
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseConnection.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.save_rounded, color: Colors.white),
          onPressed: _submit,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25.0,
                        color: Colors.indigo,
                      )
                  ),
                  SizedBox(height: 20.0),
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
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Subject Name',
                              labelStyle: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w300,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) =>
                            input.trim().isEmpty
                                ? 'Please enter a subject name.'
                                : null,
                            onSaved: (input) => _subjectName = input,
                            initialValue: _subjectName,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Task Title',
                                labelStyle: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w300,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            ),
                            validator: (input) =>
                            input.trim().isEmpty
                                ? 'Please enter a task title.'
                                : null,
                            onSaved: (input) => _taskName = input,
                            initialValue: _taskName,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                                labelText: 'Deadline',
                                labelStyle: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w300,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.arrow_drop_down),
                            //iconSize: 25.0,
                            iconEnabledColor: Colors.indigo,
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Priority',
                                labelStyle: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w300,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            ),
                            validator: (input) =>
                            _priority == null
                                ? 'Please enter a priority level.'
                                : null,
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
        )
    );
  }
}
