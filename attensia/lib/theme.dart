import 'package:flutter/material.dart';

class AppTheme {
  // Neo-Brutalism Color Palette
  static const Color textColor = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFFFBBF24); // Amber
  static const Color accentColor = Color(0xFF10B981); // Emerald
  static const Color borderColor = Color(0xFF000000);
  static const Color cyanLight = Color(0xFF67E8F9); // Cyan 300
  static const Color cyanDark = Color(0xFF06B6D4); // Cyan 500
  static const Color navBarColor = Color(0xFFE0F7FA); // Light cyan/white
  
  // Additional colors for attendance status
  static const Color goodAttendance = Color(0xFF10B981); // Emerald green
  static const Color poorAttendance = Color(0xFFEF4444); // Red
  static const Color warningAttendance = Color(0xFFF59E0B); // Orange

  // Neo-Brutalism Text Styles (Bold, High Contrast)
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: textColor,
    letterSpacing: -0.5,
  );

  static const TextStyle subjectName = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: textColor,
    letterSpacing: -0.3,
  );

  static const TextStyle attendanceText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: textColor,
    letterSpacing: 0,
  );

  static const TextStyle percentageText = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: textColor,
    letterSpacing: -1,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: textColor,
    letterSpacing: -0.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: textColor,
    letterSpacing: 0.5,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: textColor,
  );

  // Neo-Brutalism Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor, size: 28),
        titleTextStyle: appBarTitle,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 3),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
