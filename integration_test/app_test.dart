import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to_do_na_to/main.dart' as app;
import 'package:to_do_na_to/screens/add_task_screen.dart';
import 'package:to_do_na_to/screens/navigations/to_do_list.dart';

void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //create test case
    testWidgets("adding a task with correct input details", (tester) async {
      app.main();
      final inputSubjectName = 'CMSC 129';
      final inputTaskName = 'Integration Testing';
      //testing
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('floating-add')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);

      await tester.enterText(find.byKey(Key('subject-name')), inputSubjectName);
      await tester.enterText(find.byKey(Key('task-name')), inputTaskName);
      await tester.tap(find.byKey(Key('deadline')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('priority')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(find.text(inputSubjectName), findsWidgets);
      expect(find.text(inputTaskName), findsWidgets);
      expect(find.text('High'), findsWidgets);

      await tester.tap(find.byKey(Key('floating-save')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Container, inputSubjectName), findsWidgets);
      expect(find.widgetWithText(Container, inputTaskName), findsWidgets);

    });

    testWidgets("adding a task with no input details provided", (tester) async {
      app.main();
      //testing
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('floating-add')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);

      await tester.tap(find.byKey(Key('floating-save'))); //No input data was provided yet still pressed the Save Button
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);
      expect(find.text('Please enter a subject name.'), findsWidgets);
      expect(find.text('Please enter a task title.'), findsWidgets);
      expect(find.text('Date and time has passed.'), findsWidgets);
      expect(find.text('Please enter a priority level.'), findsWidgets);

    });
    testWidgets("adding a task if subject is empty", (tester) async {
      app.main();
      final inputTaskName = 'Integration Testing';
      //testing
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('floating-add')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);

      await tester.enterText(find.byKey(Key('task-name')), inputTaskName);
      await tester.tap(find.byKey(Key('deadline')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('priority')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(find.text(inputTaskName), findsWidgets);
      expect(find.text('High'), findsWidgets);

      await tester.tap(find.byKey(Key('floating-save')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);
      expect(find.text('Please enter a subject name.'), findsWidgets);

    });
    testWidgets("adding a task if taskname is empty", (tester) async {
      app.main();
      final inputSubjectName = 'CMSC 129';
      //testing
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('floating-add')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);

      await tester.enterText(find.byKey(Key('subject-name')), inputSubjectName);
      await tester.tap(find.byKey(Key('deadline')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('priority')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(find.text(inputSubjectName), findsWidgets);
      expect(find.text('High'), findsWidgets);

      await tester.tap(find.byKey(Key('floating-save')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);
      expect(find.text('Please enter a task title.'), findsWidgets);

    });
    testWidgets("adding a task if deadline inputted is incorrect", (tester) async {
      app.main();
      final inputSubjectName = 'CMSC 129';
      final inputTaskName = 'Integration Testing';
      //testing
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('floating-add')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);

      await tester.enterText(find.byKey(Key('subject-name')), inputSubjectName);
      await tester.enterText(find.byKey(Key('task-name')), inputTaskName);
      await tester.tap(find.byKey(Key('priority')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(find.text(inputSubjectName), findsWidgets);
      expect(find.text(inputTaskName), findsWidgets);
      expect(find.text('High'), findsWidgets);

      await tester.tap(find.byKey(Key('floating-save')));
      await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);
      expect(find.text('Date and time has passed.'), findsWidgets);

    });
    testWidgets("adding a task if priority is empty", (tester) async {
      app.main();
        final inputSubjectName = 'CMSC 129';
        final inputTaskName = 'Integration Testing';
        //testing
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('floating-add')));
        await tester.pumpAndSettle();

        expect(find.byType(AddTaskScreen), findsWidgets);

        await tester.enterText(find.byKey(Key('subject-name')), inputSubjectName);
        await tester.enterText(find.byKey(Key('task-name')), inputTaskName);
        await tester.tap(find.byKey(Key('deadline')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('10'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.text(inputSubjectName), findsWidgets);
        expect(find.text(inputTaskName), findsWidgets);

        await tester.tap(find.byKey(Key('floating-save')));
        await tester.pumpAndSettle();

      expect(find.byType(AddTaskScreen), findsWidgets);
      expect(find.text('Please enter a priority level.'), findsWidgets);

    });
  });
}