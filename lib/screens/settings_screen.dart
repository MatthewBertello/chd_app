import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/main.dart';
import 'package:heart_safe/theme/color_demo.dart';
import 'package:heart_safe/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

///Author: Matthew Bertello, Grace Kiesau, Pachia Lee
///Date: 5/14/24
///Description: allows user to change passowrd and change the theme
///Bugs: None Known
///reflection: pretty straightforward
class Settings extends StatelessWidget {
  const Settings({super.key});

  void switchTheme(context) {
    bool isDark = Provider.of<ThemeManager>(context, listen: false).themeMode ==
        ThemeMode.dark;

    ///if the current theme of the app is lightmode, switch to darkMode (and vice versa)
    Provider.of<ThemeManager>(context, listen: false).toggleTheme(!isDark);
  }

  void demoTheme(context) {
    Navigator.push(
        context,

        ///on tapped, shows the colors of the theme
        MaterialPageRoute(builder: (context) => const ColorDemo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(context: context, title: const Text('Settings')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => switchTheme(context),
                        child: const Text('Switch Theme'))),
                // TextButton(onPressed: () => demoTheme(context),child: const Text('Demo Theme')),
                const Divider(),
                SupaResetPassword(
                  accessToken:
                      supabaseModel.supabase!.auth.currentSession?.accessToken,
                  onSuccess: (UserResponse response) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password changed successfully!'),
                      ),
                    );
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change failed!'),
                      ),
                    );
                    print(error);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
