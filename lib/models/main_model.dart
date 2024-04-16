import 'package:flutter/material.dart';
import 'member.dart';
import 'package:chd_app/main.dart';

class MainModel extends ChangeNotifier {
  String test = "hello";
  List membersSearched = [];
  Member member = Member(name: "Jane Doe", dueDate: DateTime(2024, 9, 1)); // Just a hardcoded member for now

  List<Map<String, dynamic>>? variableDefinitions;

  void getVariableDefinitions() async {
    final data = await supabase.from('variable_definitions').select();
    variableDefinitions = data;
    print(variableDefinitions); 
  }

  // Method to get the countdown for the due date in days
  int dueDateCountDown() {
    return member.dueDate!.difference(DateTime.now()).inDays;
  }

   // Method that counts the number of pregnant days
  int countDay() {
    return (dueDateCountDown() - countTotalPregnantDays()).abs(); 
  }

  // Method that counts the total number of days in the 9 months of pregnancy
  int countTotalPregnantDays() {
    int month = member.dueDate!.month - 9; // Subtract the due dates month from 9 months
    int year = member.dueDate!.year;

    while (month <= 0) { // If the month is negative or 0 keep adding 12 until it isn't
      month += 12;
      year--;
    }

    // Put together the last time the pregnant person had their period
    DateTime lastMenstrualPeriod = DateTime(year, month, member.dueDate!.day);
    return member.dueDate!.difference(lastMenstrualPeriod).inDays; // Subtract the due date from the last menstrual period
  }

  // A method that searches a member depending on the keyword, 
  // TODO: will need to get it from database later
  searchMember(String keyword) {
    membersSearched = [Member(name: "Jan Doe", birthDate: DateTime(1990, 12, 3)), 
            Member(name: "John Doe", birthDate: DateTime(1970, 10, 4))];
    notifyListeners();
  }

  // Clears all the members in the membersSearched list
  clearMembersSearched() {
    membersSearched = [];
  }
}
