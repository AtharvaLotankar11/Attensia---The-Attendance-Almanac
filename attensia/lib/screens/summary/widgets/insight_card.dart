import 'package:flutter/material.dart';
import '../../../theme.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final Color color;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 3),
              ),
            ),
            child: Text(
              title.toUpperCase(),
              style: AppTheme.labelText.copyWith(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTheme.percentageText.copyWith(
                    fontSize: 36,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTheme.attendanceText.copyWith(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
