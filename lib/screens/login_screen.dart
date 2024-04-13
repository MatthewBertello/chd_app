import 'dart:async';

import 'package:chd_app/components/tab_view.dart';
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
    super.initState();

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabView(),
          ),
        );
      }
    });
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
        Center(
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
                onSignInComplete: (response) {},
                onSignUpComplete: (response) {},
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabView(),
                  ),
                ),
                child: const Text('Skip Login'),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
