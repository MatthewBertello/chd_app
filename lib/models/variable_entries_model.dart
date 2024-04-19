import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';

class VariableEntriesModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  List<Map<String, dynamic>> variableEntries = [];
  Map<DateTime, List<Map<String, dynamic>>> processedVariableEntries = {};

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    variableDefinitions = [];
    variableEntries = [];
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;

    await getVariableDefinitions();
    await getVariableEntries();

    for (var entry in variableEntries) {
      var variable = variableDefinitions.firstWhere((element) => element['id'] == entry['variable_id']);
      entry['name'] = variable['name'];
      entry['unit'] = variable['unit'];
      entry['description'] = variable['description'];
    }

    for (var element in variableEntries) {
      if (!processedVariableEntries.containsKey(element['date'].day)) {
        processedVariableEntries[element['date'].day] = await getVariableEntriesFromDate(date: element['date']);
      }
    }

    loaded = true;
    loading = false;
    notifyListeners();
  }

  Future<dynamic> getVariableDefinitions() async {
    try {
      variableDefinitions =
          await supabase.from('variable_definitions').select();
    } catch (e) {
      print(e);
    }
    variableDefinitions.sort((a, b) => a['name'].compareTo(b['name']));
  }

  Future<dynamic> getVariableEntries() async {
    try {
      variableEntries =
          await supabase.from('variable_entries').select().eq('user_id', supabase.auth.currentUser!.id);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getVariableEntriesFromDate({required DateTime date}) async {
    if (!loaded && !loading) {
      await init();
    }
    while (loading) {
      continue;
    }

    var filteredEntries = variableEntries.where((element) {
      DateTime entryDate = DateTime.parse(element['date']);
      return entryDate.year == date.year && entryDate.month == date.month && entryDate.day == date.day;
    }).toList();

    return filteredEntries;
  }
}
