import 'package:flutter/material.dart';
import '../models/timetable_day.dart';
import '../../attendance/controllers/attendance_controller.dart';

class TimetableController extends ChangeNotifier {
  final AttendanceController _attendanceController;
  
  List<TimetableDay> _timetable = [
    TimetableDay(day: 'Monday', subjects: []),
    TimetableDay(day: 'Tuesday', subjects: []),
    TimetableDay(day: 'Wednesday', subjects: []),
    TimetableDay(day: 'Thursday', subjects: []),
    TimetableDay(day: 'Friday', subjects: []),
    TimetableDay(day: 'Saturday', subjects: []),
    TimetableDay(day: 'Sunday', subjects: []),
  ];

  TimetableController(this._attendanceController);

  List<TimetableDay> get timetable => _timetable;

  List<String> get availableSubjects {
    return _attendanceController.subjects.map((s) => s.name).toList();
  }

  String get todayName {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[now.weekday - 1];
  }

  TimetableDay get todaySchedule {
    return _timetable.firstWhere(
      (day) => day.day == todayName,
      orElse: () => TimetableDay(day: todayName, subjects: []),
    );
  }

  void updateDaySubjects(String day, List<String> subjects) {
    final index = _timetable.indexWhere((d) => d.day == day);
    if (index != -1) {
      _timetable[index] = TimetableDay(day: day, subjects: subjects);
      notifyListeners();
    }
  }

  void markTodayAttendance() {
    final today = todaySchedule;
    for (final subjectName in today.subjects) {
      if (subjectName.isNotEmpty) {
        final subject = _attendanceController.subjects.firstWhere(
          (s) => s.name == subjectName,
          orElse: () => _attendanceController.subjects.first,
        );
        _attendanceController.markPresent(subject.id);
      }
    }
    notifyListeners();
  }

  void setFullTimetable(List<TimetableDay> newTimetable) {
    _timetable = newTimetable;
    notifyListeners();
  }
}
