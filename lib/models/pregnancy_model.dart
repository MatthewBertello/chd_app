import 'package:flutter/material.dart';

class PregnancyModel extends ChangeNotifier {
  List toDos = [];
  DateTime? dueDate;

  //Method that adds to todo list
  void addToToDo(String todo, bool isChecked) {
    Map<String, dynamic> todoItem = {'todo': todo, 'isChecked': isChecked};
    toDos.add(todoItem);
    notifyListeners();
  }

  void deleteToDo(int index) {
    toDos.removeAt(index);
    notifyListeners();
  }

  // Method to get the countdown for the due date in days
  int dueDateCountDown() {
    return dueDate!.difference(DateTime.now()).inDays;
  }

  // Method that counts the number of pregnant days
  int countDay() {
    return (dueDateCountDown() - countTotalPregnantDays()).abs();
  }

  // Method that counts the total number of days in the 9 months of pregnancy
  int countTotalPregnantDays() {
    int month = dueDate!.month - 9; // Subtract the due dates month from 9 months
    int year = dueDate!.year;

    while (month <= 0) {
      // If the month is negative or 0 keep adding 12 until it isn't
      month += 12;
      year--;
    }

    // Put together the last time the pregnant person had their period
    DateTime lastMenstrualPeriod = DateTime(year, month, dueDate!.day);
    return dueDate!
        .difference(lastMenstrualPeriod)
        .inDays; // Subtract the due date from the last menstrual period
  }
}