class Task {
  int id;
  String subjectName;
  String taskName;
  String priority;
  DateTime date;
  //int status; //0 - task is incomplete, 1 - task is complete

  Task({
    this.subjectName,
    this.taskName,
    this.priority,
    this.date,
    //this.status,
  });

  Task.withId({
    this.id,
    this.subjectName,
    this.taskName,
    this.priority,
    this.date,
    //this.status,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['subject_name'] = subjectName;
    map['task_name'] = taskName;
    map['priority'] = priority;
    map['date'] = date.toIso8601String();
    //map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      subjectName: map['subject_name'],
      taskName: map['task_name'],
      priority: map['priority'],
      date: DateTime.parse(map['date']),
      //status: map['status'],
    );
  }
}