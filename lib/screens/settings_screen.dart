// ignore_for_file: avoid_print, must_be_immutable

import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/main.dart';
import 'package:heart_safe/models/personal_info_model.dart';
import 'package:heart_safe/screens/personal_info.dart';
import 'package:heart_safe/theme/color_demo.dart';
import 'package:heart_safe/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

///Author: Matthew Bertello, Grace Kiesau, Pachia Lee
///Date: 5/14/24
///Description: allows user to change password and change the theme
///Bugs: None Known
///reflection: pretty straightforward
class Settings extends StatelessWidget {
  Settings({super.key});
  TextEditingController usernameController = TextEditingController();

  void switchTheme(context) {
    bool isDark = 
            Provider.of<ThemeManager>(context, listen: false).themeMode ==
                ThemeMode.dark;///if the current theme of the app is light mode, switch to darkMode (and vice versa)
        Provider.of<ThemeManager>(context, listen: false).toggleTheme(!isDark);
  }

  void demoTheme(context) {
    Navigator.push(
        context,

        ///on tapped, shows the colors of the theme
        MaterialPageRoute(builder: (context) => const ColorDemo()));
  }

  void updateUsername(String username, context) {
    Provider.of<PersonalInfoModel>(context, listen: false).updateUsername(username);
    usernameController.clear();      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(context: context, title: const Text('Settings')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(

              children: [
                TextButton(onPressed: () => switchTheme(context),child: const Text('Switch Theme')),
                TextButton(onPressed: () => demoTheme(context),child: const Text('Demo Theme')),
                const SizedBox(height: 30),

                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter your username'),
                  controller: usernameController,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: () => updateUsername(usernameController.text, context), child: const Text('Update Username'))),

                const SizedBox(height: 30),
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
