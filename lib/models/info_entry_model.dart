import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';

class InfoEntryModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  Map<String, List<Map<String, dynamic>>> categorizedVariableDefinitions = {};
  List<int> favorites = [];
  DateTime selectedDate = DateTime.now();

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    variableDefinitions = [];
    categorizedVariableDefinitions = {};
    favorites = [];
    selectedDate = DateTime.now();
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;
    variableDefinitions = [];
    categorizedVariableDefinitions = {};
    favorites = [];
    await getVariableDefinitions();
    await getFavorites();

    // Add checkbox, favorite, and form fields to each variable
    for (var element in variableDefinitions) {
      element['favorite'] = favorites.contains(element['id']);
      element['checkbox'] = element['favorite'];
      element['form'] = TextFormField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      );
    }

    // Categorize the variables
    for (var element in variableDefinitions) {
      if (!categorizedVariableDefinitions.containsKey(element['category'])) {
        categorizedVariableDefinitions[element['category']] = [];
      }
      categorizedVariableDefinitions[element['category']]!.add(element);
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

  Future<dynamic> getFavorites() async {
    try {
      favorites = (await supabase
              .from('user_variable_favorites')
              .select('variable_id')
              .eq('user_id', supabase.auth.currentUser!.id))
          .map<int>((e) => e['variable_id'] as int)
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> submit() async {
    for (var element in variableDefinitions) {
      if (element['checkbox'] && element['form'].controller!.text.isNotEmpty) {
        try {
          await supabase.from('variable_entries').insert([
            {
              'user_id': supabase.auth.currentUser!.id,
              'variable_id': element['id'],
              'value': double.tryParse(element['form'].controller!.text),
              'date': selectedDate.toIso8601String(),
            }
          ]);
        } catch (e) {
          print(e);
        }
      }
      element['checkbox'] = element['favorite'];
      element['form'].controller!.clear();
    }
    selectedDate = DateTime.now();
    notifyListeners();
  }

  Future<dynamic> updateFavorite(int id, bool favorited) async {
    try {
      if (favorited) {
        await supabase.from('user_variable_favorites').upsert(
          {
            'user_id': supabase.auth.currentUser!.id,
            'variable_id': id,
          },
        );
        if (!favorites.contains(id)) {
          favorites.add(id);
        }
      } else {
        await supabase
            .from('user_variable_favorites')
            .delete()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('variable_id', id);
        favorites.remove(id);
      }
    } catch (e) {
      print(e);
    }
  }
}
