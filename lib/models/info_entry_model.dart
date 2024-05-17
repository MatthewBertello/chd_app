import 'package:heart_safe/main.dart';
import 'package:flutter/material.dart';

///Author: Matthew Bertello
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
class InfoEntryModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<dynamic> variableDefinitions = [];
  Map<String, List<dynamic>> categorizedVariableDefinitions = {};
  List<int> favorites = [];
  DateTime selectedDate = DateTime.now();

  //Reset the model
  //This should be called when the user logs out
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

  //Initialize the model
  Future<dynamic> init() async {
    // If this model is already loading, wait for it to finish
    while (loading) {
      continue;
    }
    loading = true;

    ///Reset the model
    variableDefinitions = [];
    categorizedVariableDefinitions = {};
    favorites = [];

    ///Get the variable definitions and favorites
    await getVariableDefinitions();
    await getFavorites();

    ///Add checkbox, favorite, and form fields to each variable
    for (var element in variableDefinitions) {
      element['favorite'] = favorites.contains(element['id']);
      element['checkbox'] = element['favorite'];
      element['form'] = TextFormField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      );
    }

    ///Categorize the variables
    for (var element in variableDefinitions) {
      if (!categorizedVariableDefinitions.containsKey(element['category'])) {
        categorizedVariableDefinitions[element['category']] = [];
      }
      categorizedVariableDefinitions[element['category']]!.add(element);
    }
    selectedDate = DateTime.now();
    loaded = true;
    loading = false;
    notifyListeners();
  }

  ///Gets the variable definitions from the supabaseModel
  Future<dynamic> getVariableDefinitions() async {
    variableDefinitions = await supabaseModel.getVariableDefinitions();
    variableDefinitions.sort((a, b) => a['name'].compareTo(b['name']));
  }

  ///Gets the user's favorite variables from the supabaseModel
  Future<dynamic> getFavorites() async {
    favorites = (await supabaseModel.getUserVariableFavorites())
        .map<int>((e) => e['variable_id'] as int)
        .toList();
  }

  /// Submits the variable entries to the database
  Future<dynamic> submit() async {
    for (var element in variableDefinitions) {
      if (element['checkbox'] &&
          element['form'].controller!.text.isNotEmpty &&
          double.tryParse(element['form'].controller!.text) != null) {
        try {
          await supabaseModel.supabase!.from('variable_entries').insert([
            {
              'user_id': supabaseModel.supabase!.auth.currentUser!.id,
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
    await supabaseModel.getVariableEntries(reload: true);
    notifyListeners();
  }

  /// Updates the favorite status of a variable
  Future<dynamic> updateFavorite(int id, bool favorited) async {
    try {
      if (favorited) {
        await supabaseModel.supabase!.from('user_variable_favorites').upsert(
          {
            'user_id': supabaseModel.supabase!.auth.currentUser!.id,
            'variable_id': id,
          },
        );
        if (!favorites.contains(id)) {
          favorites.add(id);
        }
      } else {
        await supabaseModel.supabase!
            .from('user_variable_favorites')
            .delete()
            .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)
            .eq('variable_id', id);
        favorites.remove(id);
      }
    } catch (e) {
      print(e);
    }
    supabaseModel.getUserVariableFavorites(reload: true);
  }
}
