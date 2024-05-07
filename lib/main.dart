import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/models/personal_info_model.dart';
import 'package:chd_app/models/pregnancy_model.dart';
import 'package:chd_app/models/question_forum_model/question_forum_model.dart';
import 'package:chd_app/models/supabase_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:chd_app/screens/login_screen.dart';
import 'package:chd_app/theme/theme_constants.dart';
import 'package:chd_app/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
