import 'package:flutter/material.dart';
import '../models/summary_model.dart';
import '../../../sample_data.dart';

class SummaryController extends ChangeNotifier {
  AttendanceSummary? _summary;
  double _threshold = 75.0;
  bool _isLoading = false;

  // Getters
  AttendanceSummary? get summary => _summary;
  double get threshold => _threshold;
  bool get isLoading => _isLoading;

  SummaryController() {
    _loadSummaryData();
  }

  // Load summary data (currently using sample data)
  Future<void> _loadSummaryData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Get subjects from sample data
    final subjects = getSampleSubjects();

    // Calculate totals
    int totalAttended = 0;
    int totalLectures = 0;

    for (var subject in subjects) {
      totalAttended += subject.attended;
      totalLectures += subject.total;
    }

    _summary = AttendanceSummary(
      attendedLectures: totalAttended,
      totalLectures: totalLectures,
      totalSubjects: subjects.length,
      threshold: _threshold,
    );

    _isLoading = false;
    notifyListeners();
  }

  // Update threshold
  Future<void> updateThreshold(double newThreshold) async {
    _threshold = newThreshold;
    
    if (_summary != null) {
      _summary = _summary!.copyWith(threshold: newThreshold);
    }
    
    notifyListeners();

    // TODO: Save to Supabase in future
    // await _supabaseService.updateThreshold(newThreshold);
  }

  // Refresh summary data
  Future<void> refreshSummary() async {
    await _loadSummaryData();
  }

  // Calculate lectures needed to reach threshold
  int lecturesNeededForThreshold() {
    if (_summary == null) return 0;
    
    final currentPercentage = _summary!.percentage;
    if (currentPercentage >= _threshold) return 0;

    // Formula: (attended + x) / (total + x) = threshold / 100
    // Solving for x: x = (threshold * total - 100 * attended) / (100 - threshold)
    
    final attended = _summary!.attendedLectures;
    final total = _summary!.totalLectures;
    
    final numerator = (_threshold * total) - (100 * attended);
    final denominator = 100 - _threshold;
    
    if (denominator == 0) return 0;
    
    final lecturesNeeded = (numerator / denominator).ceil();
    return lecturesNeeded > 0 ? lecturesNeeded : 0;
  }

  // Calculate how many lectures can be missed while maintaining threshold
  int lecturesCanMiss() {
    if (_summary == null) return 0;
    
    final currentPercentage = _summary!.percentage;
    if (currentPercentage < _threshold) return 0;

    // Formula: attended / (total + x) = threshold / 100
    // Solving for x: x = (100 * attended / threshold) - total
    
    final attended = _summary!.attendedLectures;
    final total = _summary!.totalLectures;
    
    if (_threshold == 0) return 0;
    
    final maxTotal = (100 * attended) / _threshold;
    final canMiss = (maxTotal - total).floor();
    
    return canMiss > 0 ? canMiss : 0;
  }
}
