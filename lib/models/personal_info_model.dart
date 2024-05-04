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


  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    // Make sure all variables are set back to default
    // ignore: unused_local_variable
    Map<String, dynamic> userData = {};
    // ignore: unused_local_variable
    List<Map<String, dynamic>> variableItems = [];
    // ignore: unused_local_variable
    Map<String, dynamic> userDemographics = {};
    // ignore: unused_local_variable
    Map<String, dynamic> userSocials = {};
    // ignore: unused_local_variable
    Map<String, dynamic> userPhysicals = {};
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

    loaded = true;
    loading = false;
    notifyListeners();
  }

  // Gets all of the user's data regarding demographics, social and physical
  Future<dynamic> getUserData() async {
    try {
      userData =
          (await supabaseModel.supabase!
          .from('user_info')
          .select()
          .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)
          ).first;
          print(userData);
    } catch (e) {
      // ignore: avoid_print
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
      for(var demographic in demographics) {
         var variableName = demographic['name'];
         userDemographics[variableName] = userData[variableName];
      }
      print(userDemographics);

    } catch(e) {
      print(e);
    }
  }

  // Get user social variables
  Future<dynamic> getUserSocials() async {
    try {
      // Get all the variables that are demographics
      List<Map<String, dynamic>> socials = await supabaseModel.supabase!
      .from('personal_info_variables')
      .select('name')
      .eq('category', 'Social');

      // Check the userData and pull out the demographics
      for(var social in socials) {
         var variableName = social['name'];
         userSocials[variableName] = userData[variableName];
      }
      print(userSocials);

    } catch(e) {
      print(e);
    }
  }

  // Get user physical variables
  Future<dynamic> getUserPhysicals() async {
    try {
      // Get all the variables that are demographics
      List<Map<String, dynamic>> physicals = await supabaseModel.supabase!
      .from('personal_info_variables')
      .select('name')
      .eq('category', 'Physical');

      // Check the userData and pull out the demographics
      for(var physical in physicals) {
         var variableName = physical['name'];
         userPhysicals[variableName] = userData[variableName];
      }
      print(userPhysicals);
      
    } catch(e) {
      print(e);
    }
  }

  // Future<dynamic> submit() async {
  //   for (var element in variableDefinitions) {
  //     if (element['checkbox'] && element['form'].controller!.text.isNotEmpty) {
  //       try {
  //         await supabaseModel.supabase!.from('variable_entries').insert([
  //           {
  //             'user_id': supabaseModel.supabase!.auth.currentUser!.id,
  //             'variable_id': element['id'],
  //             'value': double.tryParse(element['form'].controller!.text),
  //             'date': selectedDate.toIso8601String(),
  //           }
  //         ]);
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //     element['checkbox'] = element['favorite'];
  //     element['form'].controller!.clear();
  //   }
  //   selectedDate = DateTime.now();
  //   notifyListeners();
  // }

  // Future<dynamic> updateFavorite(int id, bool favorited) async {
  //   try {
  //     if (favorited) {
  //       await supabaseModel.supabase!.from('user_variable_favorites').upsert(
  //         {
  //           'user_id': supabaseModel.supabase!.auth.currentUser!.id,
  //           'variable_id': id,
  //         },
  //       );
  //       if (!favorites.contains(id)) {
  //         favorites.add(id);
  //       }
  //     } else {
  //       await supabaseModel.supabase!
  //           .from('user_variable_favorites')
  //           .delete()
  //           .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id)
  //           .eq('variable_id', id);
  //       favorites.remove(id);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}