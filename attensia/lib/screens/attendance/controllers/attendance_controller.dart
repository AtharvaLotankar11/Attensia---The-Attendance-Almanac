import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../../../services/attendance_service.dart';

class AttendanceController extends ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();
  
  List<Subject> _subjects = [];
  double _minAttendanceThreshold = 75.0;
  bool _isLoading = false;
  String? _error;

  AttendanceController() {
    _initialize();
  }

  // Getters
  List<Subject> get subjects => _subjects;
  double get minAttendanceThreshold => _minAttendanceThreshold;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize - Load data from Supabase
  Future<void> _initialize() async {
    await loadSubjects();
    await loadUserSettings();
  }

  // Load subjects from Supabase
  Future<void> loadSubjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _subjects = await _attendanceService.fetchSubjects();
    } catch (e) {
      _error = 'Failed to load subjects: $e';
      _subjects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user settings from Supabase
  Future<void> loadUserSettings() async {
    try {
      _minAttendanceThreshold = await _attendanceService.getMinAttendanceThreshold();
      notifyListeners();
    } catch (e) {
      // Use default threshold if loading fails
      _minAttendanceThreshold = 75.0;
    }
  }

  // Update minimum attendance threshold
  Future<void> updateThreshold(double newThreshold) async {
    _minAttendanceThreshold = newThreshold;
    notifyListeners();

    try {
      await _attendanceService.updateMinAttendanceThreshold(newThreshold);
    } catch (e) {
      _error = 'Failed to update threshold: $e';
      notifyListeners();
    }
  }

  // Add a new subject
  Future<void> addSubject(String name, int attended, int total) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newSubject = await _attendanceService.addSubject(name, attended, total);
      _subjects.insert(0, newSubject); // Add to beginning of list
    } catch (e) {
      _error = 'Failed to add subject: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark attendance as present (✅)
  Future<void> markPresent(String subjectId) async {
    final index = _subjects.indexWhere((s) => s.id == subjectId);
    if (index == -1) return;

    final subject = _subjects[index];
    
    try {
      await _attendanceService.markPresent(subject);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to mark present: $e';
      notifyListeners();
    }
  }

  // Mark attendance as absent (❌)
  Future<void> markAbsent(String subjectId) async {
    final index = _subjects.indexWhere((s) => s.id == subjectId);
    if (index == -1) return;

    final subject = _subjects[index];
    
    try {
      await _attendanceService.markAbsent(subject);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to mark absent: $e';
      notifyListeners();
    }
  }

  // Delete a subject
  Future<void> deleteSubject(String subjectId) async {
    try {
      await _attendanceService.deleteSubject(subjectId);
      _subjects.removeWhere((s) => s.id == subjectId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete subject: $e';
      notifyListeners();
    }
  }

  // Get subject by ID
  Subject? getSubjectById(String id) {
    try {
      return _subjects.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh data from server
  Future<void> refresh() async {
    await loadSubjects();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
