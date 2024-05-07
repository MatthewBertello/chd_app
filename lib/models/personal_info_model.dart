// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:chd_app/main.dart';

class PersonalInfoModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now();

  Map<String, dynamic> userInfo = {};
  Map<String, Map<String, dynamic>> userInfoMap = {};
  List<Map<String, dynamic>> personalInfoVariables = [];
  Map<String, Map<String, dynamic>> variables = {};
  final List<String> notEnumTypes = ['text', 'date', 'int'];

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    // Make sure all variables are set back to default
    userInfo = {};
    personalInfoVariables = [];
    variables = {};
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;

    await getUserInfo();
    await getPersonalInfoVariables();
    await prepareUserInfoVariables();
    addForms();

    loaded = true;
    loading = false;
    notifyListeners();
  }

  Future<dynamic> getUserInfo() async {
    userInfo = await supabaseModel.getUserInfo();
  }

  Future<dynamic> getPersonalInfoVariables() async {
    personalInfoVariables = await supabaseModel.getPersonalInfoVariables();
    for (var row in personalInfoVariables) {
      var name = row['name'];
      row.remove(row['name']);
      row['key'] = name;
      variables[name] = row;
    }
  }

  Future<dynamic> getEnumValues(String enumName) async {
    final oidQuery = await supabaseModel.supabase!
        .from('public_pg_type')
        .select('oid')
        .eq('typname', enumName);
    print(enumName);
    var oid = oidQuery[0]['oid'];

    final valuesQuery = await supabaseModel.supabase!
        .from('public_pg_enum')
        .select('enumlabel')
        .eq('enumtypid', oid);
    List<String> values = [];
    for (var value in valuesQuery) {
      values.add(value['enumlabel']);
    }
    return values;
  }

  Future<dynamic> prepareUserInfoVariables() async {
    for (var key in variables.keys) {
      if (userInfo.containsKey(key)) {
        variables[key]!['value'] = userInfo[key];
        variables[key]!['title'] = cleanTitle(key);
        if (!notEnumTypes.contains(variables[key]!['unit'])) {
          variables[key]!['values'] =
              await getEnumValues(variables[key]!['unit']);
        } else {
          variables[key]!['values'] = variables[key]!['unit'];
        }
      } else {
        variables.remove(key);
      }
    }
  }

  void addForms() {
    for (var key in variables.keys) {
      if (!notEnumTypes.contains(variables[key]!['unit'])) {
      } else {
        var textField = createTextFormField();
        variables[key]!['input'] = textField;
      }
    }
  }

  // Cleans the column name from the database for the title of a variable
  String cleanTitle(String clutteredTitle) {
    var splitTitle = clutteredTitle.split('_');
    String title = "";

    for (var word in splitTitle) {
      // If the work is Num change it to #
      if (word == "num") {
        word = "#";
      } else {
        // Get the first letter and capitalize it
        String firstLetter = word[0].toUpperCase();
        word = firstLetter + word.substring(1);
      }

      title += "$word "; // Add the word to the title
    }

    return title;
  }

  TextFormField createTextFormField() {
    return TextFormField(
      controller: TextEditingController(),
    );
  }

  List<Widget> createRadioButtons(
      String selectedValue, List variableTypes, String variableCategory) {
    List<Widget> varWithRadioButtons = [];

    // Add a radio button to all of the different types in the variable category
    for (var type in variableTypes) {
      var radioButton = Radio<String>(
        value: type,
        groupValue: variables[variableCategory]!['value'],
        onChanged: (value) {
          print(value);
          variables[variableCategory]!['value'] = value;
          // saveSelectedToDb(variableCategory, value);
          notifyListeners();
        },
      );

      var title = Text(type);

      varWithRadioButtons.add(Row(children: [radioButton, title]));
    }

    return varWithRadioButtons;
  }

  Future<dynamic> saveSelectedToDb(
      String variableCategory, String value) async {
    try {
      await supabaseModel.supabase!
          .from('user_info')
          .update({variableCategory: value}).eq(
              'user_id', supabaseModel.supabase!.auth.currentUser!.id);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
