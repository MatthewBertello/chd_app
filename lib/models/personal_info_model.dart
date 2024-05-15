// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';

///Author: Pachia lee, Grace Kiesau
///Date: 5/14/24
///Description: 
///Bugs: None Known
class PersonalInfoModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now();

  dynamic userInfo = {};
  Map<String, dynamic> userInfoMap = {};
  List<dynamic> personalInfoVariables = [];
  Map<String, dynamic> variables = {};
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
        .select('enumlabel, enumsortorder')
        .eq('enumtypid', oid);
    List<dynamic> values = [];
    for (var value in valuesQuery) {
      values.add({
        'enumlabel': value['enumlabel'],
        'enumsortorder': value['enumsortorder']
      });
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
          print(variables[key]!['values']);
          variables[key]!['values'].sort((a, b) {
            if (a['enumsortorder'].toInt() > b['enumsortorder'].toInt()) {
              return 1;
            } else if (a['enumsortorder'].toInt() <
                b['enumsortorder'].toInt()) {
              return -1;
            }
            return 0;
          });
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

  Future<dynamic> saveSelectedToDb(
      String variableCategory, String? value) async {
    try {
      print(
          "update user ${supabaseModel.supabase!.auth.currentUser!.id} type $variableCategory to $value");
      await supabaseModel.supabase!
          .from('user_info')
          .update({variableCategory: value}).match(
              {'user_id': supabaseModel.supabase!.auth.currentUser!.id});

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
