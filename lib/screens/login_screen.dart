import 'dart:async';

import 'package:chd_app/components/tab_view.dart';
import 'package:chd_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:chd_app/main.dart';

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
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (data.event == AuthChangeEvent.passwordRecovery && session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabView(),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Settings(),
          ),
        );
        return;
      }

      if (session != null) {
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
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.inversePrimary,
              Theme.of(context).colorScheme.secondary,
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
                    // Congenital heart disease ribbon
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.network(
                        'https://www.conqueringchd.org/wp-content/uploads/2020/07/awareness-ribbon-300x300.png',
                        width: 100.0,
                        fit: BoxFit.cover)),
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
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TabView(),
                    ),
                  ),
                  child: const Text('Skip Login (Dev only, partial functionality)'),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
