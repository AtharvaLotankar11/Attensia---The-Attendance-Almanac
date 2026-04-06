import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../../../sample_data.dart';

class AttendanceController extends ChangeNotifier {
  List<Subject> _subjects = [];
  double _minAttendanceThreshold = 75.0;

  AttendanceController() {
    _loadSampleData();
  }

  // Getters
  List<Subject> get subjects => _subjects;
  double get minAttendanceThreshold => _minAttendanceThreshold;

  // Load sample data (will be replaced with Supabase later)
  void _loadSampleData() {
    _subjects = getSampleSubjects();
    notifyListeners();
  }

  // Update minimum attendance threshold
  void updateThreshold(double newThreshold) {
    _minAttendanceThreshold = newThreshold;
    notifyListeners();
  }

  // Add a new subject
  void addSubject(String name, int attended, int total) {
    final newSubject = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      attended: attended,
      total: total,
    );
    _subjects.add(newSubject);
    notifyListeners();
  }

  // Mark attendance as present (✅)
  void markPresent(String subjectId) {
    final index = _subjects.indexWhere((s) => s.id == subjectId);
    if (index != -1) {
      _subjects[index].markPresent();
      notifyListeners();
    }
  }

  // Mark attendance as absent (❌)
  void markAbsent(String subjectId) {
    final index = _subjects.indexWhere((s) => s.id == subjectId);
    if (index != -1) {
      _subjects[index].markAbsent();
      notifyListeners();
    }
  }

  // Delete a subject (optional, for future use)
  void deleteSubject(String subjectId) {
    _subjects.removeWhere((s) => s.id == subjectId);
    notifyListeners();
  }

  // Get subject by ID
  Subject? getSubjectById(String id) {
    try {
      return _subjects.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
