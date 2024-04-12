import 'dart:async';

import 'package:chd_app/components/tab_view.dart';
import 'package:chd_app/screens/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:chd_app/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Create a subscription to listen for a password reset email
  late final StreamSubscription<void> _passwordResetEmailSentSubscription;

  @override
  void initState() {
    super.initState();


    // Listen for a password reset email

    _passwordResetEmailSentSubscription =
        supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabView(),
          ),
        );
      }

      // Check for password reset email
    });
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
              SupaEmailAuth(
                redirectTo:
                    kIsWeb ? null : 'io.supabase.chd_app://login-callback/',
                onSignInComplete: (response) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TabView(),
                    ),
                  );
                },
                onSignUpComplete: (response) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                
              ),
              SupaResetPassword(
                accessToken: supabase.auth.currentSession?.accessToken,
                onSuccess: (UserResponse response) {},
                onError: (error) {},
              )
            ],
          ),
        ),
      ]),
    );
  }
}
