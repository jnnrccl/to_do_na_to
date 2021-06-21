import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_na_to/helpers/database_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_na_to/models/task_model.dart';
import 'package:to_do_na_to/helpers/local_notification.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:to_do_na_to/utils/validator.dart';

class SetScheduleScreen extends StatefulWidget {
  final Function updateTaskList;
  SetScheduleScreen({this.updateTaskList});
  @override
  _SetScheduleScreenState createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
  TextEditingController _dateController = TextEditingController();
  DateTime _date = DateTime.now();
  List <String> listSchedule = [];
  List<Task> allTasks;

  AwesomeDialog dialog;
  bool enableNotif = false;

  @override
  void initState() {
    super.initState();
    _setVal();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseConnection.instance.getTaskList();
    });
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
      final TimeOfDay onlyTime =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
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

  _submit(task) async {
    if (_formKey.currentState.validate()) {
      bool same = false;
      listSchedule = task.scheduler;
      //print('$listSchedule');
      Task localTask;
      localTask = Task.withID(
        id: task.id,
        subjectName: task.subjectName,
        taskName: task.taskName,
        priority: task.priority,
        date: task.date,
        status: task.status,
      );
      if (listSchedule != null){
        for (String element in listSchedule) {
          if(element == _date.toString()){
            same = true;
            break;
          }
        }
      }
      if(same == false){
        listSchedule.add(_date.toString());
        listSchedule.sort();
        localTask.scheduler = listSchedule;
        //print('$listSchedule');
        DatabaseConnection.instance.updateTask(localTask);
        if (enableNotif == true){
          Task tempTask;
          tempTask = Task.withID(
            id: task.id,
            subjectName: task.subjectName,
            taskName: task.taskName,
            priority: task.priority,
            date: _date,
            status: task.status,
            scheduler: listSchedule,
          );
          Notifications().scheduleTaskScheduler(tempTask);
        }
      }
      dialog.dissmiss();
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  Widget _buildTask(snapshot, index, Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          //SizedBox(height: 5.0),
          Container(
            //padding: EdgeInsets.symmetric(vertical: 3.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  Container(
                    width: 95.0,
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${task.subjectName}',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                '${task.taskName}',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${_dateFormatter.format(task.date)} • ${task.priority}',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                dialog = AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.INFO,
                  keyboardAware: true,
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Set a Schedule',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            onTap: _handleDatePicker,
                            validator: FieldValidator.validateDate,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: GoogleFonts.rubik(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AnimatedButton(
                            text: 'Set',
                            pressEvent: () {
                              _submit(task);
                            })
                      ],
                    ),
                  ),
                )..show();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              allTasks = snapshot.data;

              allTasks.sort((a,b) {
                int first, second;
                if (a.priority == 'Low')
                  first = 3;
                else if (a.priority == 'Medium')
                  first = 2;
                else
                  first = 1;

                if (b.priority == 'Low')
                  second = 3;
                else if (b.priority == 'Medium')
                  second = 2;
                else
                  second = 1;

                if (a.date.month == b.date.month && a.date.day == b.date.day && a.date.year == b.date.year){
                  return first.compareTo(second);
                }
                else{
                  return a.date.compareTo(b.date);
                }
              });
            }
            return CustomScrollView(
              slivers: <Widget> [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, top: 80.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 25.0,
                              color: Colors.indigo,
                            )),
                        SizedBox(height: 20.0),
                        Text(
                          'Select a task',
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          color: Colors.transparent,
                        );
                      }
                      if(allTasks[index - 1].status != 2){
                        return _buildTask(snapshot, index, allTasks[index - 1]);
                      }
                      return Container(color: Colors.indigo);
                    },
                    childCount: 1 + snapshot.data.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                      color: Colors.transparent,
                      height: 20.0,
                    )
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}