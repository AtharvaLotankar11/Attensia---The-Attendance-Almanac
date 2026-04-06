class AttendanceSummary {
  final int attendedLectures;
  final int totalLectures;
  final int totalSubjects;
  final double threshold;

  AttendanceSummary({
    required this.attendedLectures,
    required this.totalLectures,
    required this.totalSubjects,
    this.threshold = 75.0,
  });

  // Calculate overall attendance percentage
  double get percentage => 
      totalLectures == 0 ? 0 : (attendedLectures / totalLectures) * 100;

  // Calculate missed lectures
  int get missedLectures => totalLectures - attendedLectures;

  // Check if attendance meets threshold
  bool get meetsThreshold => percentage >= threshold;

  // Get attendance status
  AttendanceStatus get status {
    if (percentage >= threshold) {
      return AttendanceStatus.good;
    } else if (percentage >= threshold - 10) {
      return AttendanceStatus.moderate;
    } else {
      return AttendanceStatus.poor;
    }
  }

  // Get status message
  String get statusMessage {
    switch (status) {
      case AttendanceStatus.good:
        return '✅ Good Attendance';
      case AttendanceStatus.moderate:
        return '⚠️ Moderate Attendance';
      case AttendanceStatus.poor:
        return '❌ Poor Attendance';
    }
  }

  // Convert to Map (for future Supabase integration)
  Map<String, dynamic> toMap() {
    return {
      'attended_lectures': attendedLectures,
      'total_lectures': totalLectures,
      'total_subjects': totalSubjects,
      'threshold': threshold,
    };
  }

  // Create from Map (for future Supabase integration)
  factory AttendanceSummary.fromMap(Map<String, dynamic> map) {
    return AttendanceSummary(
      attendedLectures: map['attended_lectures'] ?? 0,
      totalLectures: map['total_lectures'] ?? 0,
      totalSubjects: map['total_subjects'] ?? 0,
      threshold: map['threshold']?.toDouble() ?? 75.0,
    );
  }

  // Copy with method
  AttendanceSummary copyWith({
    int? attendedLectures,
    int? totalLectures,
    int? totalSubjects,
    double? threshold,
  }) {
    return AttendanceSummary(
      attendedLectures: attendedLectures ?? this.attendedLectures,
      totalLectures: totalLectures ?? this.totalLectures,
      totalSubjects: totalSubjects ?? this.totalSubjects,
      threshold: threshold ?? this.threshold,
    );
  }
}

enum AttendanceStatus {
  good,
  moderate,
  poor,
}
