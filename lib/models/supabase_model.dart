// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
///Author: Matthew Bertello
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
class SupabaseModel {
  bool isLoading = false;
  SupabaseClient? supabase;
  List<dynamic> forumQuestions = [];
  List<dynamic> forumReplies = [];
  List<dynamic> stringVariableDefinitions = [];
  dynamic userInfo = {};
  List<dynamic> userVariableFavorites = [];
  List<dynamic> variableDefinitions = [];
  List<dynamic> variableEntries = [];
  List<dynamic> personalInfoVariables = [];
  bool forumQuestionsLoaded = false;
  bool forumRepliesLoaded = false;
  bool stringVariableDefinitionsLoaded = false;
  bool userInfoLoaded = false;
  bool userVariableFavoritesLoaded = false;
  bool variableDefinitionsLoaded = false;
  bool variableEntriesLoaded = false;
  bool personalInfoVariablesLoaded = false;

  // Initialize the Supabase client and load data
  Future<dynamic> initialize() async {
    while (isLoading) {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    await initSupabase();
    await getForumQuestions();
    await getForumReplies();
    await getStringVariableDefinitions();
    await getUserInfo();
    await getUserVariableFavorites();
    await getVariableDefinitions();
    await getVariableEntries();
  }

  // Initialize the Supabase client
  Future<dynamic> initSupabase() async {
    if (supabase != null) {
      return;
    }
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    supabase = Supabase.instance.client;
  }

  // Sign out of Supabase and reset the data
  Future<dynamic> signOut() async {
    await supabase!.auth.signOut();
    forumQuestions = [];
    forumReplies = [];
    stringVariableDefinitions = [];
    userInfo = {};
    userVariableFavorites = [];
    variableDefinitions = [];
    variableEntries = [];
    forumQuestionsLoaded = false;
    forumRepliesLoaded = false;
    stringVariableDefinitionsLoaded = false;
    userInfoLoaded = false;
    userVariableFavoritesLoaded = false;
    variableDefinitionsLoaded = false;
    variableEntriesLoaded = false;
  }

  // Check if Supabase is initialized
  bool supabaseIsInitialized() {
    return supabase != null;
  }

  // Checks if supabase is initialized and waits until it is
  Future<dynamic> ensureSupabaseIntialized() async {
    while (!supabaseIsInitialized()) {
      await initialize();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  // Check if the user is logged in
  Future<dynamic> userLoggedIn() async {
    await ensureSupabaseIntialized();
    return supabase!.auth.currentUser != null;
  }

  // Gets the forum questions from the database
  Future<dynamic> getForumQuestions({bool reload = false}) async {
    await ensureSupabaseIntialized();
    if (!forumQuestionsLoaded || reload) {
      try {
        forumQuestions = await supabase!.from('forum_questions').select();
      } catch (e) {
        print(e);
      }
      forumQuestionsLoaded = true;
    }
    return forumQuestions;
  }

  // Gets the forum replies from the database
  Future<dynamic> getForumReplies({bool reload = false}) async {
    await ensureSupabaseIntialized();
    if (!forumRepliesLoaded || reload) {
      try {
        forumReplies = await supabase!.from('forum_replies').select();
      } catch (e) {
        print(e);
      }
      forumRepliesLoaded = true;
    }
    return forumReplies;
  }

  // Gets the string variable definitions from the database
  Future<dynamic> getStringVariableDefinitions({bool reload = false}) async {
    await ensureSupabaseIntialized();
    if (!stringVariableDefinitionsLoaded || reload) {
      try {
        stringVariableDefinitions =
            await supabase!.from('string_variable_definitions').select();
      } catch (e) {
        print(e);
      }
      stringVariableDefinitionsLoaded = true;
    }
    return stringVariableDefinitions;
  }

  // Gets the user info from the database
  Future<dynamic> getUserInfo({bool reload = false}) async {
    if (!await userLoggedIn()) {
      return null;
    }
    if (!userInfoLoaded || reload) {
      try {
        userInfo = (await supabase!
                .from('user_info')
                .select()
                .eq('user_id', supabase!.auth.currentUser!.id))
            .first;
      } catch (e) {
        print(e);
      }
      userInfoLoaded = true;
    }
    return userInfo;
  }

  // Gets the user variable favorites from the database
  Future<dynamic> getUserVariableFavorites({bool reload = false}) async {
    if (!await userLoggedIn()) {
      return null;
    }
    if (!userVariableFavoritesLoaded || reload) {
      try {
        userVariableFavorites =
            await supabase!.from('user_variable_favorites').select().eq(
                  'user_id',
                  supabase!.auth.currentUser!.id,
                );
      } catch (e) {
        print(e);
      }
      userVariableFavoritesLoaded = true;
    }
    return userVariableFavorites;
  }

  // Gets the variable definitions from the database
  Future<dynamic> getVariableDefinitions({bool reload = false}) async {
    await ensureSupabaseIntialized();
    if (!variableDefinitionsLoaded || reload) {
      try {
        variableDefinitions =
            await supabase!.from('variable_definitions').select();
      } catch (e) {
        print(e);
      }
      variableDefinitionsLoaded = true;
    }
    return variableDefinitions;
  }

  // Gets the variable entries from the database
  Future<dynamic> getVariableEntries({bool reload = false}) async {
    if (!await userLoggedIn()) {
      return null;
    }
    if (!variableEntriesLoaded || reload) {
      try {
        variableEntries = await supabase!
            .from('variable_entries')
            .select()
            .eq('user_id', supabase!.auth.currentUser!.id);
      } catch (e) {
        print(e);
      }
      variableEntriesLoaded = true;
    }
    List<dynamic> deepCopy = jsonDecode(jsonEncode(variableEntries));
    return deepCopy;
  }

  // Gets the personal info variables from the database
  Future<dynamic> getPersonalInfoVariables({bool reload = false}) async {
    await ensureSupabaseIntialized();
    if (!personalInfoVariablesLoaded || reload) {
      try {
        personalInfoVariables =
            await supabase!.from('personal_info_variables').select();
      } catch (e) {
        print(e);
      }
      personalInfoVariablesLoaded = true;
    }
    return personalInfoVariables;
  }
}
