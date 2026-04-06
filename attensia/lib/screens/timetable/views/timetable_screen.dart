import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../controllers/timetable_controller.dart';
import '../widgets/today_schedule_card.dart';
import '../widgets/day_expansion_tile.dart';
import '../views/edit_day_dialog.dart';
import '../views/create_timetable_screen.dart';
import '../../attendance/controllers/attendance_controller.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return TimetableScreenContent(
      attendanceController: AttendanceController(),
      timetableController: TimetableController(AttendanceController()),
    );
  }
}

class TimetableScreenContent extends StatefulWidget {
  final AttendanceController attendanceController;
  final TimetableController timetableController;

  const TimetableScreenContent({
    super.key,
    required this.attendanceController,
    required this.timetableController,
  });

  @override
  State<TimetableScreenContent> createState() => _TimetableScreenContentState();
}

class _TimetableScreenContentState extends State<TimetableScreenContent> {
  void _showEditDayDialog(String day) {
    final dayData = widget.timetableController.timetable.firstWhere((d) => d.day == day);
    showDialog(
      context: context,
      builder: (context) {
        return EditDayDialog(
          day: day,
          currentSubjects: dayData.subjects,
          availableSubjects: widget.timetableController.availableSubjects,
          onSave: (subjects) {
            setState(() {
              widget.timetableController.updateDaySubjects(day, subjects);
            });
          },
        );
      },
    );
  }

  void _navigateToCreateTimetable() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTimetableScreen(controller: widget.timetableController),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _markTodayAttendance() {
    widget.timetableController.markTodayAttendance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.goodAttendance,
            border: Border.all(color: AppTheme.borderColor, width: 3),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Attendance marked for today!',
                  style: AppTheme.buttonText.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.cyanLight, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: AppTheme.borderColor, width: 4),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Attensia'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.borderColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.borderColor,
                        offset: const Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit_calendar, color: AppTheme.textColor, size: 24),
                    onPressed: _navigateToCreateTimetable,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.timetableController,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TodayScheduleCard(
                  todaySchedule: widget.timetableController.todaySchedule,
                  onMarkAttendance: _markTodayAttendance,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WEEKLY SCHEDULE',
                        style: AppTheme.dialogTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ...widget.timetableController.timetable.map((day) {
                        return DayExpansionTile(
                          day: day,
                          availableSubjects: widget.timetableController.availableSubjects,
                          onEdit: _showEditDayDialog,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
