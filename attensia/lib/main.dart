import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/main_navigation.dart';

void main() {
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
      home: const MainNavigation(),
    );
  }
}
