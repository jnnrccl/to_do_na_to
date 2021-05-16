import 'package:test/test.dart';
import 'package:to_do_na_to/utils/validator.dart';

void main(){

  test('Empty Subject Name Test', () {
    var result = FieldValidator.validateSubjectName('');
    expect(result, 'Please enter a subject name.');
  });

  test('Only Letters Subject Name Test', () {
    var result = FieldValidator.validateSubjectName('#abc');
    expect(result, null);
  });

  test('Only Numbers Subject Name Test', () {
    var result = FieldValidator.validateSubjectName('123');
    expect(result, null);
  });

  test('Numbers and Letters Subject Name Test', () {
    var result = FieldValidator.validateSubjectName('abc123');
    expect(result, null);
  });

  test('Empty Task Name Test', () {
    var result = FieldValidator.validateTaskName('');
    expect(result, 'Please enter a task title.');
  });

  test('Only Letters Task Name Test', () {
    var result = FieldValidator.validateTaskName('abc');
    expect(result, null);
  });

  test('Only Numbers Task Name Test', () {
    var result = FieldValidator.validateTaskName('123');
    expect(result, null);
  });

  test('Numbers and Letters Task Name Test', () {
    var result = FieldValidator.validateTaskName('abc123');
    expect(result, null);
  });

  test('Before Current Date Test', () {
    DateTime today = DateTime.now();
    var result = FieldValidator.validateDate(today.subtract(new Duration(days: 1)).toString());
    expect(result, 'Wrong Date Time');
  });

  test('Current Date Before Current Time Test', () {
    DateTime today = DateTime.now();
    var result = FieldValidator.validateDate(today.subtract(new Duration(hours: 1)).toString());
    expect(result, 'Wrong Date Time');
  });

  /*test('Current Date Test', () {
    DateTime today = DateTime.now();
    var result = FieldValidator.validateDate(today.toString());
    expect(result, null);
  });*/

  test('Current Date After Current Time Test', () {
    DateTime today = DateTime.now();
    var result = FieldValidator.validateDate(today.add(new Duration(hours: 1)).toString());
    expect(result, null);
  });

  test('No Priority Level Picked Test', () {
    var result = FieldValidator.validatePriority(null);
    expect(result, 'Please enter a priority level.');
  });

  test('Low Priority Level Test', () {
    var result = FieldValidator.validatePriority('Low');
    expect(result, null);
  });

  test('Medium Priority Level Test', () {
    var result = FieldValidator.validatePriority('Medium');
    expect(result, null);
  });

  test('High Priority Level Test', () {
    var result = FieldValidator.validatePriority('High');
    expect(result, null);
  });
}