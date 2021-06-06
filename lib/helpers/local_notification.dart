import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notifications {
  String _groupKey = 'com.android.example.to_do_na_to';
  String _groupId = 'to_do_na_to';
  String _groupName = 'to_do_na_to_group';
  String _groupDescription = 'TODO  application';

  AndroidNotificationDetails _notificationAndroidSpecifics;
  NotificationDetails _notificationPlatformSpecifics;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  InitializationSettings initializationSettings;

  Notifications() {
    initializing();
  }

  initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // ignore: missing_return
  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print("you clicked notification");
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {},
            child: Text("Okay")),
      ],
    );
  }

  scheduleTask(task) async {
    debugPrint('Created....');
    tz.initializeTimeZones();
    _notificationAndroidSpecifics = AndroidNotificationDetails(
      _groupId,
      _groupName,
      _groupDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      groupKey: _groupKey,
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      ledOnMs: 1000,
      ledOffMs: 500,
      ledColor: Colors.redAccent,
      color: Colors.indigo,
      visibility: NotificationVisibility.public,
      styleInformation: DefaultStyleInformation(true, true),

    );
    _notificationPlatformSpecifics =
        NotificationDetails(android: _notificationAndroidSpecifics);

    _saveTask(task);

    List list = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    //print(list);
    print('Number of Task Notifications =  ${list.length}');
  }

  deleteTask(task) async {
    debugPrint('DELETING....');
    await flutterLocalNotificationsPlugin.cancel(task.secondId);
    await flutterLocalNotificationsPlugin.cancel(task.thirdId);
    await flutterLocalNotificationsPlugin.cancel(task.id);
  }

  updateTask(task) {
    debugPrint('UPDATE....');
    scheduleTask(task);
  }

  _saveTask(task) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      task.id,
      'Task Reminder',
      '${task.subjectName}: ${task.taskName} is due!',
      tz.TZDateTime.from(task.date, tz.local),
      _notificationPlatformSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    var dayBefore = task.date.day;
    var x = dayBefore.compareTo(DateTime.now().day);
    //print(x);

    if (x > 0) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        task.thirdId,
        'Task Reminder',
        '${task.subjectName}: ${task.taskName} is due today at ${task.date.hour}:${task.date.minute}!',
        tz.TZDateTime.from(DateTime(task.date.year, task.date.month, task.date.day), tz.local),
        _notificationPlatformSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      //DateTime curr =   tz.TZDateTime.from(DateTime(task.date.year, task.date.month, task.date.day), tz.local);
      //print(curr);
      flutterLocalNotificationsPlugin.zonedSchedule(
        task.secondId,
        'Task Reminder',
        '${task.subjectName}: ${task.taskName} is due tomorrow at ${task.date.hour}:${task.date.minute}!',
        tz.TZDateTime.from(task.date.subtract(Duration(days: 1)), tz.local),
        _notificationPlatformSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }
  }

  scheduleTaskScheduler(task) async {
    debugPrint('Created....');
    tz.initializeTimeZones();
    _notificationAndroidSpecifics = AndroidNotificationDetails(
      _groupId,
      _groupName,
      _groupDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      groupKey: _groupKey,
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      ledOnMs: 1000,
      ledOffMs: 500,
      ledColor: Colors.redAccent,
      color: Colors.indigo,
      visibility: NotificationVisibility.public,
      styleInformation: DefaultStyleInformation(true, true),
    );

    _notificationPlatformSpecifics = NotificationDetails(android: _notificationAndroidSpecifics);
    //DateTime currentDate = DateTime.now();

    flutterLocalNotificationsPlugin.zonedSchedule(
      task.id,
      'REMINDERS',
      '${task.subjectName} : Do ${task.taskName} now!',
      tz.TZDateTime.from(task.date, tz.local),
      _notificationPlatformSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    List list = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(list);
    print('Number of Task Notifications =  ${list.length}');
  }
}