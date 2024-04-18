import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:chd_app/screens/login_screen.dart';
import 'package:chd_app/theme/theme_constants.dart';
import 'package:chd_app/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainModel()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => QuestionForumModel()),
        ChangeNotifierProvider(create: (context) => InfoEntryModel()),
      ],
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Preload the InfoEntryModel so that it is ready when the user navigates to the InfoEntryScreen
    if (Provider.of<InfoEntryModel>(context).loaded == false &&
        Provider.of<InfoEntryModel>(context).loading == false) {
      Provider.of<InfoEntryModel>(context, listen: false).init();
    }
    return MaterialApp(
      title: 'CHD App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      home: const Login(),
    );
  }
}
