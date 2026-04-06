import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/timetable/models/timetable_day.dart';

class TimetableService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  // Get full week timetable
  Future<List<TimetableDay>> getWeekTimetable() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .rpc('get_user_timetable', params: {'p_user_id': _userId});

    if (response == null || response.isEmpty) {
      // Return empty timetable for all days
      return [
        TimetableDay(day: 'Monday', subjects: []),
        TimetableDay(day: 'Tuesday', subjects: []),
        TimetableDay(day: 'Wednesday', subjects: []),
        TimetableDay(day: 'Thursday', subjects: []),
        TimetableDay(day: 'Friday', subjects: []),
        TimetableDay(day: 'Saturday', subjects: []),
        TimetableDay(day: 'Sunday', subjects: []),
      ];
    }

    // Convert response to TimetableDay list
    final timetableMap = <String, List<String>>{};
    for (var row in response) {
      final day = row['day_of_week'] as String;
      final subjects = List<String>.from(row['subjects'] as List);
      timetableMap[day] = subjects;
    }

    // Ensure all days are present
    final allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return allDays.map((day) {
      return TimetableDay(
        day: day,
        subjects: timetableMap[day] ?? [],
      );
    }).toList();
  }

  // Get today's timetable
  Future<TimetableDay?> getTodayTimetable() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .rpc('get_today_timetable', params: {'p_user_id': _userId});

    if (response == null || response.isEmpty) {
      return null;
    }

    final row = response[0];
    return TimetableDay(
      day: row['day_of_week'] as String,
      subjects: List<String>.from(row['subjects'] as List),
    );
  }

  // Update day timetable (add or update)
  Future<void> updateDayTimetable(String day, List<String> subjects) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _supabase.rpc('upsert_day_timetable', params: {
      'p_user_id': _userId,
      'p_day': day,
      'p_subjects': subjects,
    });
  }

  // Get subjects for a specific day
  Future<List<String>> getDaySubjects(String day) async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase.rpc('get_day_subjects', params: {
      'p_user_id': _userId,
      'p_day': day,
    });

    if (response == null) return [];

    return List<String>.from(response as List);
  }

  // Delete a day's timetable
  Future<void> deleteDayTimetable(String day) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('timetable')
        .delete()
        .eq('user_id', _userId!)
        .eq('day_of_week', day);
  }

  // Get timetable summary
  Future<Map<String, dynamic>?> getTimetableSummary() async {
    if (_userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('timetable_summary')
        .select()
        .eq('user_id', _userId!)
        .maybeSingle();

    return response;
  }

  // Bulk update entire week timetable
  Future<void> updateWeekTimetable(List<TimetableDay> timetable) async {
    if (_userId == null) throw Exception('User not authenticated');

    // Update each day
    for (var day in timetable) {
      await updateDayTimetable(day.day, day.subjects);
    }
  }
}
