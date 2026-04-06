import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/timetable_day.dart';

class TodayScheduleCard extends StatelessWidget {
  final TimetableDay todaySchedule;
  final VoidCallback onMarkAttendance;

  const TodayScheduleCard({
    super.key,
    required this.todaySchedule,
    required this.onMarkAttendance,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubjects = todaySchedule.subjects.where((s) => s.isNotEmpty).isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.borderColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderColor,
            offset: const Offset(8, 8),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.today_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  "TODAY'S SCHEDULE",
                  style: AppTheme.dialogTitle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todaySchedule.day.toUpperCase(),
                  style: AppTheme.labelText.copyWith(
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                if (!hasSubjects)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No classes today',
                            style: AppTheme.attendanceText.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...todaySchedule.subjects
                      .asMap()
                      .entries
                      .where((entry) => entry.value.isNotEmpty)
                      .map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        border: Border.all(color: AppTheme.borderColor, width: 3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              border: Border.all(color: AppTheme.borderColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: AppTheme.attendanceText.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: AppTheme.subjectName.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                if (hasSubjects) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: onMarkAttendance,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.goodAttendance,
                        border: Border.all(color: AppTheme.borderColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.borderColor,
                            offset: const Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'MARK ATTENDANCE',
                            style: AppTheme.buttonText.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
