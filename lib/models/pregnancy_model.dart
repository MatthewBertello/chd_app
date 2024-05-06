// ignore_for_file: avoid_print, unused_local_variable

import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PregnancyModel extends ChangeNotifier {
  List toDos = [];
  DateTime? dueDate;
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now();
  int totalPregnantDays = 0;
  int currentPregnantDays = 0;
  DateTime lastMenstrualPeriod = DateTime.now();
  List<Map<String, dynamic>> events = [];

  // Initialize the model
  Future<dynamic> init() async {
    // If this model is already loading, wait for it to finish
    while (loading) {
      continue;
    }
    loading = true;

    setDueDate();
    await getToDos();

    selectedDate = DateTime.now();
    loaded = true;
    loading = false;
    notifyListeners();
  }

  Future<void> getToDos() async {
    toDos = await supabaseModel.supabase!
      .from('user_to_do_lists')
      .select()
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);

    print(toDos);
    notifyListeners();
  }

  // Set the due date
  Future<void> setDueDate() async {
    final response = (await supabaseModel.supabase!
      .from('user_info')
      .select('due_date')
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)).first;
    
    //print(response);

    if(response['due_date'] != null) {
      dueDate = response['due_date'];
      countTotalPregnantDays();
      countCurrentPregnantDays();
      setlastMenstrualPeriod();
    }
    notifyListeners();
  }

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

  //Method that adds to todo list
  Future<void> addToDo(String todo, bool isChecked) async {
    try {
      final response = (await supabaseModel.supabase!
      .from('user_to_do_lists')
      .insert({'user_id': supabaseModel.supabase!.auth.currentUser!.id, 'to_do': todo, 'is_checked': isChecked})
      .select('to_do_id')).first;
    
    getToDos();
    print(response);
    } catch(e) {
      print(e);
    }
  }

  Future<void> deleteToDo(int toDoID) async {
    try {
      final response = await supabaseModel.supabase!
      .from('user_to_do_lists')
      .delete()
      .eq('to_do_id', toDoID);

    getToDos();
    } catch(e) {
      print(e);
    }
  }

  Future<void> updateCheckBox(bool? value, Map todoEntry) async {
    try {
      await supabaseModel.supabase!
      .from('user_to_do_lists')
      .update({'is_checked': value})
      .eq('to_do_id', todoEntry['to_do_id']);
    getToDos();
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
    currentPregnantDays = dueDateCountDown() - totalPregnantDays.abs();
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
    } catch(e) {
      print(e);
    }
  }

  Future<void> addEvent(String event, String location,DateTime? date) async {
    String supabaseDate = date!.toIso8601String();
    DateFormat timeFormat = DateFormat('HH:mm:ss.SSSSSS');
    String supabaseTime = timeFormat.format(date);

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

  Future <void> selectEvents(DateTime day) async {
    final response = await supabaseModel.supabase!
      .from('user_events')
      .select()
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)
      .eq('event_date', day.toIso8601String());
    
    print(day.toIso8601String());
    print(response);
    events = response;
    notifyListeners();
  }
   Future <void> updateSubstantial(String colName, dynamic variable) async {
    final response = await supabaseModel.supabase!
     .from('user_info')
     .update({
       colName : variable
       });
  }

}