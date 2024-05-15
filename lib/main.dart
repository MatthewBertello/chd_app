import 'package:heart_safe/models/info_entry_model.dart';
import 'package:heart_safe/models/main_model.dart';
import 'package:heart_safe/models/personal_info_model.dart';
import 'package:heart_safe/models/pregnancy_model.dart';
import 'package:heart_safe/models/question_forum_model/question_forum_model.dart';
import 'package:heart_safe/models/supabase_model.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:heart_safe/screens/login_screen.dart';
import 'package:heart_safe/theme/theme_constants.dart';
import 'package:heart_safe/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
///Author: 
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known

final SupabaseModel supabaseModel = SupabaseModel();

Future<void> main() async {
  await supabaseModel.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainModel()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => QuestionForumModel()),
        ChangeNotifierProvider(create: (context) => InfoEntryModel()),
        ChangeNotifierProvider(create: (context) => VariableEntriesModel()),
        ChangeNotifierProvider(create: (context) => PregnancyModel()),
        ChangeNotifierProvider(create:(context) => PersonalInfoModel(),)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHD App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      home: const Login(),
    );
  }
}
