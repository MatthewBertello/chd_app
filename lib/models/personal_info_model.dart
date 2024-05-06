// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:chd_app/main.dart';

class PersonalInfoModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now();

  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> variableItems = [];
  Map<String, dynamic> userDemographics = {};
  Map<String, dynamic> userSocials = {};
  Map<String, dynamic> userPhysicals = {};
  List<Map<String, dynamic>> demographicsFormFields = [];
  List<Map<String, dynamic>> socialsFormFields = [];
  List<Map<String, dynamic>> physicalsFormFields = [];

  Map<String, dynamic> userInfo = {};
  List<Map<String, dynamic>> personalInfoVariables = [];
  Map<String, Map<String, dynamic>> variables = {};

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    // Make sure all variables are set back to default
    userData = {};
    variableItems = [];
    userDemographics = {};
    userSocials = {};
    userPhysicals = {};
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;

    await getUserData();
    await getUserDemographics();
    await getUserSocials();
    await getUserPhysicals();
    setRadioVariables();
    setFormFields(demographicsFormFields, userDemographics);
    setFormFields(socialsFormFields, userSocials);
    setFormFields(physicalsFormFields, userPhysicals);

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
      var rowNoName = row.remove(row['name']);
      variables[row['name']] = rowNoName;
    }
  }

  void parseUserInfo() {
    // loop through all the keys in the userInfo map
    for (var key in userInfo.keys) {
      if (!variables.containsKey(key)) {
        // If the key is not in the variables map, remove it from the userInfo map
        userInfo.remove(key);
      } else {
        // Otherwise add the values from the variables map to the userInfo map
        for (var varKey in variables[key]!.keys) {
          userInfo[key][varKey] = variables[key]![varKey];
        }
      }
    }
  }

  Future<dynamic> getEnumValues(String enumName) async {
    final oidQuery = await supabaseModel.supabase!
        .from('public_pg_type')
        .select('oid')
        .eq('typname', enumName);
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

  /////////////////////////////////////////////////////////////////////////////////

  // Gets all of the user's data regarding demographics, social and physical
  Future<dynamic> getUserData() async {
    try {
      userData = (await supabaseModel.supabase!
              .from('user_info')
              .select()
              .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id))
          .first;
      print(userData);
    } catch (e) {
      print(e);
    }
  }

  // Gets the users demographics
  Future<dynamic> getUserDemographics() async {
    try {
      // Get all the variables that are demographics
      List<Map<String, dynamic>> demographics = await supabaseModel.supabase!
          .from('personal_info_variables')
          .select('name')
          .eq('category', 'Demographic');

      // Check the userData and pull out the demographics
      for (var demographic in demographics) {
        var variableName = demographic['name'];
        userDemographics[variableName] = userData[variableName];
      }
      print(userDemographics);
    } catch (e) {
      print(e);
    }
  }

  // Get user social variables
  Future<dynamic> getUserSocials() async {
    try {
      // Get all the variables that are social variables
      List<Map<String, dynamic>> socials = await supabaseModel.supabase!
          .from('personal_info_variables')
          .select('name')
          .eq('category', 'Social');

      // Check the userData and pull out the social variables
      for (var social in socials) {
        var variableName = social['name'];
        userSocials[variableName] = userData[variableName];
      }
      print(userSocials);
    } catch (e) {
      print(e);
    }
  }

  // Get user physical variables
  Future<dynamic> getUserPhysicals() async {
    try {
      // Get all the variables that are physical variables
      List<Map<String, dynamic>> physicals = await supabaseModel.supabase!
          .from('personal_info_variables')
          .select('name')
          .eq('category', 'Physical');

      // Check the userData and pull out the physical variables
      for (var physical in physicals) {
        var variableName = physical['name'];
        userPhysicals[variableName] = userData[variableName];
      }
      print(userPhysicals);
    } catch (e) {
      print(e);
    }
  }

  // Map<String, dynamic> userDemographics = {};
  // Map<String, dynamic> userSocials = {};
  // Map<String, dynamic> userPhysicals = {};

  // Set the form fields according to the type(userDemographics, userSocials, userPhysicals) passed in
  void setFormFields(List formFields, Map type) {
    // for (var entry in type.entries) {
    //   String title = cleanTitle(entry.key);
    //   // If any of the variables in the type map is a radio variable, add it to the formFields list
    //   if (radioVariables.containsKey(entry.key)) {
    //     formFields.add({
    //       "title": cleanTitle(entry.key),
    //       "input": radioVariables[entry.key],
    //       "isTextFormField": false
    //     });
    //   } else {
    //     // Otherwise just add a textformfield to it
    //     formFields.add({
    //       "title": cleanTitle(entry.key),
    //       "input": createTextFormField(),
    //       "isTextFormField": true
    //     });
    //   }
    // }
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

  void setRadioVariables() {
    // add keys with values of radio buttons(  [{'type': type, 'input': radio button}]   )
    // radioVariables['race'] = createRadioButtons(raceSelected, races, 'Race');
    // radioVariables['gender'] =
    //     createRadioButtons(genderSelected, genders, 'Gender');
    // radioVariables['marital_status'] = createRadioButtons(
    //     maritalStatusSelected, maritalStatuses, 'Marital Status');
    // radioVariables['education_level'] = createRadioButtons(
    //     educationLevelSelected, educationLevels, 'Education Level');
    // radioVariables['income_level'] =
    //     createRadioButtons(incomeLevelSelected, incomeLevels, 'Income Level');
    // radioVariables['employment_status'] = createRadioButtons(
    //     employmentStatusSelected, employmentStatuses, 'Employment Status');
    // radioVariables['language'] =
    //     createRadioButtons(languageSelected, languages, 'Language');
  }

  List<Widget> createRadioButtons(
      String selectedValue, List variableTypes, String variableCategory) {
    List<Widget> varWithRadioButtons = [];

    // Add a radio button to all of the different types in the variable category
    for (var type in variableTypes) {
      var radioButton = Radio(
        value: type,
        groupValue: selectedValue,
        onChanged: (value) => saveSelectedToDb(variableCategory, value),
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
