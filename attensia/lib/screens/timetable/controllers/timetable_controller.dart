import 'package:flutter/material.dart';
import '../models/timetable_day.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../../services/timetable_service.dart';

class TimetableController extends ChangeNotifier {
  final AttendanceController _attendanceController;
  final TimetableService _timetableService = TimetableService();
  
  List<TimetableDay> _timetable = [
    TimetableDay(day: 'Monday', subjects: []),
    TimetableDay(day: 'Tuesday', subjects: []),
    TimetableDay(day: 'Wednesday', subjects: []),
    TimetableDay(day: 'Thursday', subjects: []),
    TimetableDay(day: 'Friday', subjects: []),
    TimetableDay(day: 'Saturday', subjects: []),
    TimetableDay(day: 'Sunday', subjects: []),
  ];

  bool _isLoading = false;
  String? _error;

  TimetableController(this._attendanceController) {
    _loadTimetable();
  }

  List<TimetableDay> get timetable => _timetable;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  // Load timetable from Supabase
  Future<void> _loadTimetable() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _timetable = await _timetableService.getWeekTimetable();
    } catch (e) {
      _error = 'Failed to load timetable: $e';
      // Keep default empty timetable
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update day subjects and save to Supabase
  Future<void> updateDaySubjects(String day, List<String> subjects) async {
    final index = _timetable.indexWhere((d) => d.day == day);
    if (index != -1) {
      _timetable[index] = TimetableDay(day: day, subjects: subjects);
      notifyListeners();

      try {
        await _timetableService.updateDayTimetable(day, subjects);
      } catch (e) {
        _error = 'Failed to save timetable: $e';
        notifyListeners();
      }
    }
  }

  // Mark today's attendance
  Future<void> markTodayAttendance() async {
    final today = todaySchedule;
    for (final subjectName in today.subjects) {
      if (subjectName.isNotEmpty) {
        final subject = _attendanceController.subjects.firstWhere(
          (s) => s.name == subjectName,
          orElse: () => _attendanceController.subjects.first,
        );
        await _attendanceController.markPresent(subject.id);
      }
    }
    notifyListeners();
  }

  // Set full timetable and save to Supabase
  Future<void> setFullTimetable(List<TimetableDay> newTimetable) async {
    try {
      // Update local state first
      _timetable = newTimetable;
      notifyListeners();
      
      // Then save to Supabase
      await _timetableService.updateWeekTimetable(newTimetable);
    } catch (e) {
      _error = 'Failed to save timetable: $e';
      notifyListeners();
      rethrow; // Re-throw so the UI can handle it
    }
  }

  // Refresh timetable from server
  Future<void> refresh() async {
    await _loadTimetable();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
