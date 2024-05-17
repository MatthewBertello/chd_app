// ignore_for_file: avoid_print, unused_local_variable

import 'package:heart_safe/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
///Author: Pachia Lee, Grace Kiesau
///Date: 5/14/24
///Description: methods to give the calender view functionality
///Bugs: None Known
///reflection: straightforward

// Pregnancy model that helps with the pregnancy planner and the pregnancy countdown
class PregnancyModel extends ChangeNotifier {
  List toDos = []; //sets to-dos to empty to start
  DateTime? dueDate; 
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now(); //time selected is the current date
  int totalPregnantDays = 0; 
  int currentPregnantDays = 0;
  DateTime lastMenstrualPeriod = DateTime.now(); //assumes the date of the last menstrual period is the current date
  List<dynamic> events = []; 
  DateTime currentEventDay = DateTime.now();

  ///Initialize the model
  Future<dynamic> init() async {
    // If this model is already loading, wait for it to finish
    while (loading) {
      continue;
    }
    loading = true;

    setDueDate();
    await getToDos(); //gets the to-dos user has set 

    selectedDate = DateTime.now();
    loaded = true;
    loading = false;
    notifyListeners(); 
  }

  // Gets the users to do list from db
  Future<void> getToDos() async {
    toDos = await supabaseModel.supabase!
      .from('user_to_do_lists')
      .select()
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);

    notifyListeners();
  }

  // Set the due date
  Future<void> setDueDate() async {
    final response = (await supabaseModel.supabase!
      .from('user_info')
      .select('due_date')
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)).first;

    // If there is a due date present, calculate the pregnant days
    if(response['due_date'] != null) {
      dueDate = DateTime.parse(response['due_date']);
      countTotalPregnantDays();
      countCurrentPregnantDays();
      setlastMenstrualPeriod();
    }
    notifyListeners();
  }

  // Sets date of last period from db
  Future<void> setlastMenstrualPeriod() async {
    try {
      final response = (await supabaseModel.supabase!
      .from('user_info')
      .select('last_menstrual_cycle')
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)).first;

    lastMenstrualPeriod = response['last_menstrual_cycle'];
    } catch(e) {
      print(e);
    }
  }

  // Method that adds to todo list
  Future<void> addToDo(String todo, bool isChecked) async {
    try {
      final response = (await supabaseModel.supabase!
      .from('user_to_do_lists')
      .insert({'user_id': supabaseModel.supabase!.auth.currentUser!.id, 'to_do': todo, 'is_checked': isChecked})
      .select('to_do_id')).first;
    
    getToDos(); // Call get to dos to update the todo list
    } catch(e) {
      print(e);
    }
  }

  // Method that deletes a to do item from db according to the to do ID
  Future<void> deleteToDo(int toDoID) async {
    try {
      final response = await supabaseModel.supabase!
      .from('user_to_do_lists')
      .delete()
      .eq('to_do_id', toDoID);

    getToDos(); // Call get to dos to update the todo list
    } catch(e) {
      print(e);
    }
  }

  // Method that updates a checkbox corresponding to the to do item
  Future<void> updateCheckBox(bool? value, Map todoEntry) async {
    try {
      await supabaseModel.supabase!
      .from('user_to_do_lists')
      .update({'is_checked': value})
      .eq('to_do_id', todoEntry['to_do_id']);

    getToDos(); // Call get to dos to update the todo list
    } catch(e) {
      print(e);
    }
  }

  // Method to get the countdown for the due date in days
  int dueDateCountDown() {
    return dueDate!.difference(DateTime.now()).inDays;
  }

  // Method that counts the number of pregnant days
  void countCurrentPregnantDays() {
    currentPregnantDays = totalPregnantDays.abs() - dueDateCountDown();
  }

  // Method that counts the total number of days in the 9 months of pregnancy
  void countTotalPregnantDays() {
    try {
      int month = dueDate!.month - 9; // Subtract the due dates month from 9 months
      int year = dueDate!.year;

      while (month <= 0) {
        // If the month is negative or 0 keep adding 12 until it isn't
        month += 12;
        year--;
      }

      // Put together the last time the pregnant person had their period
      totalPregnantDays = dueDate!.difference(lastMenstrualPeriod).inDays; // Subtract the due date from the last menstrual period
      totalPregnantDays = 270;
    } catch(e) {
      print(e);
    }
  }

  Future<void> deleteEvent(int eventID) async {
    try {
      await supabaseModel.supabase!
      .from('user_events')
      .delete()
      .eq('event_id', eventID);

    getToDos(); // Call get to dos to update the todo list
    } catch(e) {
      print(e);
    }
  }

  // Adds an event to the calender in the db
  Future<void> addEvent(String event, String location, DateTime? date) async {
    String supabaseDate = date!.toIso8601String(); // get the supabase date format
    DateFormat timeFormat = DateFormat('HH:mm:ss.SSSSSS'); // time formatter 
    String supabaseTime = timeFormat.format(date); // formate the time for supabase

    // Insert into supabase
    final response = await supabaseModel.supabase!
      .from('user_events')
      .insert({
        'user_id': supabaseModel.supabase!.auth.currentUser!.id, 
        'event': event, 
        'event_date': supabaseDate, 
        'event_time': supabaseTime,
        'location': location});

    notifyListeners();
  }

  // Method that updates an event in the db
  Future<void> updateEvent(int eventID, String event, String location, String date, String time) async {
    try {
      // Update the event according to the event ID
      final response = await supabaseModel.supabase!
        .from('user_events')
        .update({'event': event, 'event_date': date, 'event_time': time, 'location': location})
        .eq('event_id', eventID);
        
    } catch(e) {
      print(e);
    }
  }

  // Select all of the events according to the day that is passed in
  Future <void> selectEvents(DateTime day) async {
    currentEventDay = day; // Set the instance variable
    // Get all the user's events from the day
    final response = await supabaseModel.supabase!
      .from('user_events')
      .select()
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)
      .eq('event_date', day.toIso8601String());
    
    events = response;
    notifyListeners();
  }

  // Updates the user's ID 
  Future <void> updateSubstantial(String colName, dynamic variable) async {
    final response = await supabaseModel.supabase!
     .from('user_info')
     .update({
        'user_id': supabaseModel.supabase!.auth.currentUser!.id, 
         colName : variable
      });
  }
}