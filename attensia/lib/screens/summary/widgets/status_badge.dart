import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/summary_model.dart';

class StatusBadge extends StatelessWidget {
  final AttendanceStatus status;
  final String message;

  const StatusBadge({
    super.key,
    required this.status,
    required this.message,
  });

  Color get badgeColor {
    switch (status) {
      case AttendanceStatus.good:
        return AppTheme.goodAttendance;
      case AttendanceStatus.moderate:
        return AppTheme.warningAttendance;
      case AttendanceStatus.poor:
        return AppTheme.poorAttendance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: badgeColor,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTheme.attendanceText.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
