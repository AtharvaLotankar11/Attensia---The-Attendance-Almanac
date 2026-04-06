import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme.dart';
import 'screens/main_navigation.dart';
import 'screens/auth/login_screen.dart';
import 'core/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const AttensiaApp());
}

class AttensiaApp extends StatelessWidget {
  const AttensiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attensia',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Supabase.instance.client.auth.currentUser != null
          ? const MainNavigation()
          : const LoginScreen(),
    );
  }
}
