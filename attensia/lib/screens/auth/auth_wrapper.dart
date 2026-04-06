import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main_navigation.dart';
import 'login_screen.dart';

/// Wrapper widget that listens to auth state changes
/// and automatically navigates between login and main app
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          // Widget will rebuild with new auth state
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show main app if user is logged in, otherwise show login
    return Supabase.instance.client.auth.currentSession != null
        ? const MainNavigation()
        : const LoginScreen();
  }
}
