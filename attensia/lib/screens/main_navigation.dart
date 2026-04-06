import 'package:flutter/material.dart';
import '../widgets/neo_brutal_curved_nav_bar.dart';
import 'attendance/views/attendance_page.dart';
import 'summary/views/summary_screen.dart';
import 'timetable/views/timetable_screen.dart';
import 'attendance/controllers/attendance_controller.dart';
import 'timetable/controllers/timetable_controller.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final AttendanceController _attendanceController;
  late final TimetableController _timetableController;

  @override
  void initState() {
    super.initState();
    _attendanceController = AttendanceController();
    _timetableController = TimetableController(_attendanceController);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AttendancePageContent(controller: _attendanceController),
      const SummaryScreenContent(),
      TimetableScreenContent(
        attendanceController: _attendanceController,
        timetableController: _timetableController,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, const Color(0xFF67E8F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: NeoBrutalCurvedNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
