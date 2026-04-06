import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/attendance/models/subject_model.dart';

class AttendanceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  // Fetch all subjects for current user
  Future<List<Subject>> fetchSubjects() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('subjects')
        .select()
        .eq('user_id', _userId!)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Subject.fromMap(json))
        .toList();
  }

  // Add a new subject
  Future<Subject> addSubject(String name, int attended, int total) async {
    if (_userId == null) throw Exception('User not authenticated');

    final data = {
      'user_id': _userId,
      'name': name,
      'attended': attended,
      'total': total,
    };

    final response = await _supabase
        .from('subjects')
        .insert(data)
        .select()
        .single();

    return Subject.fromMap(response);
  }

  // Update subject attendance
  Future<void> updateSubject(Subject subject) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('subjects')
        .update({
          'attended': subject.attended,
          'total': subject.total,
        })
        .eq('id', subject.id)
        .eq('user_id', _userId!);
  }

  // Delete a subject
  Future<void> deleteSubject(String subjectId) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('subjects')
        .delete()
        .eq('id', subjectId)
        .eq('user_id', _userId!);
  }

  // Mark present (increment both attended and total)
  Future<void> markPresent(Subject subject) async {
    subject.markPresent();
    await updateSubject(subject);
    
    // Optional: Log to attendance history
    await _logAttendanceHistory(
      subjectId: subject.id,
      action: 'present',
      attendedBefore: subject.attended - 1,
      totalBefore: subject.total - 1,
      attendedAfter: subject.attended,
      totalAfter: subject.total,
    );
  }

  // Mark absent (increment only total)
  Future<void> markAbsent(Subject subject) async {
    subject.markAbsent();
    await updateSubject(subject);
    
    // Optional: Log to attendance history
    await _logAttendanceHistory(
      subjectId: subject.id,
      action: 'absent',
      attendedBefore: subject.attended,
      totalBefore: subject.total - 1,
      attendedAfter: subject.attended,
      totalAfter: subject.total,
    );
  }

  // Log attendance history (optional)
  Future<void> _logAttendanceHistory({
    required String subjectId,
    required String action,
    required int attendedBefore,
    required int totalBefore,
    required int attendedAfter,
    required int totalAfter,
  }) async {
    if (_userId == null) return;

    try {
      await _supabase.from('attendance_history').insert({
        'subject_id': subjectId,
        'user_id': _userId,
        'action': action,
        'attended_before': attendedBefore,
        'total_before': totalBefore,
        'attended_after': attendedAfter,
        'total_after': totalAfter,
      });
    } catch (e) {
      // Silently fail if history logging fails
    }
  }

  // Get user settings (min attendance threshold)
  Future<double> getMinAttendanceThreshold() async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      final response = await _supabase
          .from('user_settings')
          .select('min_attendance_threshold')
          .eq('user_id', _userId!)
          .single();

      return (response['min_attendance_threshold'] as num).toDouble();
    } catch (e) {
      // Return default if settings don't exist
      return 75.0;
    }
  }

  // Update user settings (min attendance threshold)
  Future<void> updateMinAttendanceThreshold(double threshold) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      // First, try to update existing record
      final response = await _supabase
          .from('user_settings')
          .update({'min_attendance_threshold': threshold})
          .eq('user_id', _userId!)
          .select();

      // If no rows were updated, insert a new record
      if (response.isEmpty) {
        await _supabase.from('user_settings').insert({
          'user_id': _userId,
          'min_attendance_threshold': threshold,
        });
      }
    } catch (e) {
      // If update fails, try upsert with proper conflict handling
      await _supabase
          .from('user_settings')
          .upsert(
            {
              'user_id': _userId,
              'min_attendance_threshold': threshold,
            },
            onConflict: 'user_id',
          );
    }
  }

  // Get attendance history for a subject (optional)
  Future<List<Map<String, dynamic>>> getAttendanceHistory(String subjectId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('attendance_history')
        .select()
        .eq('subject_id', subjectId)
        .eq('user_id', _userId!)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
