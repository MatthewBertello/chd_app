import 'dart:async';

import 'package:heart_safe/components/tab_view.dart';
import 'package:heart_safe/models/info_entry_model.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:heart_safe/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:heart_safe/main.dart';

///Author: Pachia Lee, Grace Kiesau 
///Date: 5/14/24
///Description: allows user to login, create a new account, and authenticates user
///Bugs: None Known
///reflection: pretty straightforward
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Create a subscription to listen for a password reset email
  late final StreamSubscription<void> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription =
        supabaseModel.supabase!.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (data.event == AuthChangeEvent.passwordRecovery && session != null) {
        supabaseModel.initialize();
        if (Provider.of<InfoEntryModel>(context, listen: false).loaded ==
                false &&
            Provider.of<InfoEntryModel>(context, listen: false).loading ==
                false) {
          Provider.of<InfoEntryModel>(context, listen: false).init();
        }
        if (Provider.of<VariableEntriesModel>(context, listen: false).loaded ==
                false &&
            Provider.of<VariableEntriesModel>(context, listen: false).loading ==
                false) {
          Provider.of<VariableEntriesModel>(context, listen: false).init();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabView(),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        );
        return;
      }

      if (session != null) {
        supabaseModel.initialize();
        if (Provider.of<InfoEntryModel>(context, listen: false).loaded ==
                false &&
            Provider.of<InfoEntryModel>(context, listen: false).loading ==
                false) {
          Provider.of<InfoEntryModel>(context, listen: false).init();
        }
        if (Provider.of<VariableEntriesModel>(context, listen: false).loaded ==
                false &&
            Provider.of<VariableEntriesModel>(context, listen: false).loading ==
                false) {
          Provider.of<VariableEntriesModel>(context, listen: false).init();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabView(),
          ),
        );
        return;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.inversePrimary,
              Theme.of(context).colorScheme.primary
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(45.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    // Logo Image
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.asset('assets/logo.png')),
                SupaEmailAuth(
                  redirectTo: 'io.supabase.chd://login-callback/',
                  onSignInComplete: (response) {},
                  onSignUpComplete: (response) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign up successful!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
