import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/summary/models/summary_model.dart';

class SummaryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  // Get complete dashboard data using SQL function
  Future<AttendanceSummary> getDashboardData() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .rpc('get_user_dashboard', params: {'p_user_id': _userId});

    if (response == null || response.isEmpty) {
      // Return empty summary if no data
      return AttendanceSummary(
        attendedLectures: 0,
        totalLectures: 0,
        totalSubjects: 0,
        threshold: 75.0,
      );
    }

    final data = response[0];
    
    return AttendanceSummary(
      attendedLectures: (data['total_attended'] as num?)?.toInt() ?? 0,
      totalLectures: (data['total_lectures'] as num?)?.toInt() ?? 0,
      totalSubjects: (data['total_subjects'] as num?)?.toInt() ?? 0,
      threshold: (data['min_threshold'] as num?)?.toDouble() ?? 75.0,
    );
  }

  // Get subject-wise breakdown
  Future<List<Map<String, dynamic>>> getSubjectBreakdown() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .rpc('get_subject_breakdown', params: {'p_user_id': _userId});

    return List<Map<String, dynamic>>.from(response ?? []);
  }

  // Get attendance trends for last N days
  Future<List<Map<String, dynamic>>> getAttendanceTrends({int days = 30}) async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase.rpc('get_attendance_trends', params: {
      'p_user_id': _userId,
      'p_days': days,
    });

    return List<Map<String, dynamic>>.from(response ?? []);
  }

  // Get user attendance summary from view
  Future<Map<String, dynamic>?> getUserSummaryView() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('user_attendance_summary')
        .select()
        .eq('user_id', _userId!)
        .maybeSingle();

    return response;
  }

  // Get cached dashboard data (faster but may be slightly outdated)
  Future<Map<String, dynamic>?> getCachedDashboard() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('dashboard_cache')
        .select()
        .eq('user_id', _userId!)
        .maybeSingle();

    return response;
  }

  // Refresh dashboard cache manually
  Future<void> refreshDashboardCache() async {
    await _supabase.rpc('refresh_dashboard_cache');
  }

  // Get lectures needed to reach threshold
  Future<int> getLecturesNeededForThreshold() async {
    final dashboard = await getDashboardData();
    
    final currentPercentage = dashboard.percentage;
    final threshold = dashboard.threshold;
    
    if (currentPercentage >= threshold) return 0;

    final attended = dashboard.attendedLectures;
    final total = dashboard.totalLectures;
    
    final numerator = (threshold * total) - (100 * attended);
    final denominator = 100 - threshold;
    
    if (denominator == 0) return 0;
    
    final lecturesNeeded = (numerator / denominator).ceil();
    return lecturesNeeded > 0 ? lecturesNeeded : 0;
  }

  // Get lectures can miss while maintaining threshold
  Future<int> getLecturesCanMiss() async {
    final dashboard = await getDashboardData();
    
    final currentPercentage = dashboard.percentage;
    final threshold = dashboard.threshold;
    
    if (currentPercentage < threshold) return 0;

    final attended = dashboard.attendedLectures;
    final total = dashboard.totalLectures;
    
    if (threshold == 0) return 0;
    
    final maxTotal = (100 * attended) / threshold;
    final canMiss = (maxTotal - total).floor();
    
    return canMiss > 0 ? canMiss : 0;
  }
}
