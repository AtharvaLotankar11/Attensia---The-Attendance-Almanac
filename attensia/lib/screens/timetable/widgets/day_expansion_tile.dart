import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/timetable_day.dart';

class DayExpansionTile extends StatelessWidget {
  final TimetableDay day;
  final List<String> availableSubjects;
  final Function(String day) onEdit;

  const DayExpansionTile({
    super.key,
    required this.day,
    required this.availableSubjects,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubjects = day.subjects.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.borderColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderColor,
            offset: const Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Text(
                  day.day.substring(0, 3).toUpperCase(),
                  style: AppTheme.labelText.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day.day,
                  style: AppTheme.subjectName.copyWith(fontSize: 18),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit, color: AppTheme.textColor, size: 20),
                  onPressed: () => onEdit(day.day),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          children: [
            if (!hasSubjects)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No lectures scheduled',
                    style: AppTheme.attendanceText.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              )
            else
              ...day.subjects.asMap().entries.map((entry) {
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.cyanDark,
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: AppTheme.attendanceText.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          entry.value.isEmpty ? 'Free Period' : entry.value,
                          style: AppTheme.attendanceText.copyWith(
                            fontSize: 15,
                            color: entry.value.isEmpty
                                ? Colors.grey.shade600
                                : AppTheme.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
