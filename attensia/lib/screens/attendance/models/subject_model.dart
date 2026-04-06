class Subject {
  final String id;
  final String name;
  int attended;
  int total;

  Subject({
    required this.id,
    required this.name,
    required this.attended,
    required this.total,
  });

  // Calculate attendance percentage
  double get percentage {
    if (total == 0) return 0.0;
    return (attended / total) * 100;
  }

  // Check if attendance meets threshold
  bool meetsThreshold(double threshold) {
    return percentage >= threshold;
  }

  // Increment attended and total (for ✅ button)
  void markPresent() {
    attended++;
    total++;
  }

  // Increment only total (for ❌ button)
  void markAbsent() {
    total++;
  }

  // Convert to Map (for future Supabase integration)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'attended': attended,
      'total': total,
    };
  }

  // Create from Map (for future Supabase integration)
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      attended: map['attended'] ?? 0,
      total: map['total'] ?? 0,
    );
  }

  // Copy with method for immutability
  Subject copyWith({
    String? id,
    String? name,
    int? attended,
    int? total,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      attended: attended ?? this.attended,
      total: total ?? this.total,
    );
  }
}
