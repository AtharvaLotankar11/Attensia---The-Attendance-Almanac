import 'package:flutter/material.dart';
import '../models/summary_model.dart';
import '../../../services/summary_service.dart';
import '../../../services/attendance_service.dart';

class SummaryController extends ChangeNotifier {
  final SummaryService _summaryService = SummaryService();
  final AttendanceService _attendanceService = AttendanceService();
  
  AttendanceSummary? _summary;
  double _threshold = 75.0;
  bool _isLoading = false;
  String? _error;

  // Getters
  AttendanceSummary? get summary => _summary;
  double get threshold => _threshold;
  bool get isLoading => _isLoading;
  String? get error => _error;

  SummaryController() {
    _loadSummaryData();
  }

  // Load summary data from Supabase
  Future<void> _loadSummaryData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get dashboard data from Supabase
      _summary = await _summaryService.getDashboardData();
      _threshold = _summary?.threshold ?? 75.0;
    } catch (e) {
      _error = 'Failed to load summary: $e';
      _summary = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update threshold
  Future<void> updateThreshold(double newThreshold) async {
    _threshold = newThreshold;
    
    if (_summary != null) {
      _summary = _summary!.copyWith(threshold: newThreshold);
    }
    
    notifyListeners();

    try {
      // Save to Supabase
      await _attendanceService.updateMinAttendanceThreshold(newThreshold);
    } catch (e) {
      _error = 'Failed to update threshold: $e';
      notifyListeners();
    }
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

    final attended = _summary!.attendedLectures;
    final total = _summary!.totalLectures;
    
    if (_threshold == 0) return 0;
    
    final maxTotal = (100 * attended) / _threshold;
    final canMiss = (maxTotal - total).floor();
    
    return canMiss > 0 ? canMiss : 0;
  }

  // Get subject breakdown
  Future<List<Map<String, dynamic>>> getSubjectBreakdown() async {
    try {
      return await _summaryService.getSubjectBreakdown();
    } catch (e) {
      return [];
    }
  }

  // Get attendance trends
  Future<List<Map<String, dynamic>>> getAttendanceTrends({int days = 30}) async {
    try {
      return await _summaryService.getAttendanceTrends(days: days);
    } catch (e) {
      return [];
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
