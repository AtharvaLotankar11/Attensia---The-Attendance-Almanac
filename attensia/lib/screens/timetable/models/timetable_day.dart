class TimetableDay {
  final String day;
  final List<String> subjects;

  TimetableDay({
    required this.day,
    required this.subjects,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'subjects': subjects,
    };
  }

  factory TimetableDay.fromJson(Map<String, dynamic> json) {
    return TimetableDay(
      day: json['day'] as String,
      subjects: List<String>.from(json['subjects'] as List),
    );
  }

  TimetableDay copyWith({
    String? day,
    List<String>? subjects,
  }) {
    return TimetableDay(
      day: day ?? this.day,
      subjects: subjects ?? this.subjects,
    );
  }
}
