// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseModel {
  SupabaseClient? supabase;
  List<Map<String, dynamic>> forumQuestions = [];
  List<Map<String, dynamic>> forumReplies = [];
  List<Map<String, dynamic>> stringVariableDefinitions = [];
  Map<String, dynamic> userInfo = {};
  List<Map<String, dynamic>> userVariableFavorites = [];
  List<Map<String, dynamic>> variableDefinitions = [];
  List<Map<String, dynamic>> variableEntries = [];
  bool forumQuestionsLoaded = false;
  bool forumRepliesLoaded = false;
  bool stringVariableDefinitionsLoaded = false;
  bool userInfoLoaded = false;
  bool userVariableFavoritesLoaded = false;
  bool variableDefinitionsLoaded = false;
  bool variableEntriesLoaded = false;

  Future<dynamic> initialize() async {
    await initSupabase();
    await getForumQuestions();
    await getForumReplies();
    await getStringVariableDefinitions();
    await getUserInfo();
    await getUserVariableFavorites();
    await getVariableDefinitions();
    await getVariableEntries();
  }

  Future<dynamic> initSupabase() async {
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    supabase = Supabase.instance.client;
  }

  void sigOut() {
    supabase!.auth.signOut();
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

  bool supabaseIsInitialized() {
    return supabase != null;
  }

  Future<dynamic> ensureSupabaseIntialized() async {
    while (!supabaseIsInitialized()) {
      await initialize();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  Future<dynamic> userLoggedIn() async {
    await ensureSupabaseIntialized();
    return supabase!.auth.currentUser != null;
  }

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

  Future<dynamic> getUserInfo({bool reload = false}) async {
    if (!await userLoggedIn()) {
      return null;
    }
    if (!userInfoLoaded || reload) {
      try {
        userInfo = (await supabase!
                .from('users')
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

  Future<dynamic> getUserVariableFavorites({bool reload = false}) async {
    if (!await userLoggedIn()) {
      return null;
    }
    if (!userVariableFavoritesLoaded || reload) {
      try {
        userVariableFavorites =
            await supabase!.from('user_variable_favorites').select();
      } catch (e) {
        print(e);
      }
      userVariableFavoritesLoaded = true;
    }
    return userVariableFavorites;
  }

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
    return variableEntries;
  }
}
