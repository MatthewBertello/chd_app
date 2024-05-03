///GRACE DO
import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(context: context, title: const Text('Settings')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SupaResetPassword(
                  accessToken: supabaseModel.supabase!.auth.currentSession?.accessToken,
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
