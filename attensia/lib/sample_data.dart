import 'screens/attendance/models/subject_model.dart';

// Hardcoded sample data for subjects
List<Subject> getSampleSubjects() {
  return [
    Subject(
      id: '1',
      name: 'Mathematics',
      attended: 18,
      total: 20,
    ),
    Subject(
      id: '2',
      name: 'Physics',
      attended: 14,
      total: 22,
    ),
    Subject(
      id: '3',
      name: 'Chemistry',
      attended: 16,
      total: 18,
    ),
    Subject(
      id: '4',
      name: 'Computer Science',
      attended: 20,
      total: 22,
    ),
    Subject(
      id: '5',
      name: 'English',
      attended: 12,
      total: 20,
    ),
  ];
}
