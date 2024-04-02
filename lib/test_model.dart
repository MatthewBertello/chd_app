import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'member.dart';

class TestModel extends ChangeNotifier {
  String test = "hello";
  Connection? conn;
  List membersSearched = [];
  Member member = Member(name: "Jane Doe", dueDate: DateTime(2024, 9, 1)); // Just a hardcoded member for now

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

  TestModel() {
    Future<dynamic> newConn = Connection.open(
      Endpoint(
        port: 26257,
        host: 'wool-toucan-14257.5xj.gcp-us-central1.cockroachlabs.cloud',
        database: 'chd_app',
        username: 'chd_app',
        password: '5mBo9-e559vGXyBc_rVCMA',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.verifyFull),
    );
    newConn.then((connection) => conn = connection);
  }
}
