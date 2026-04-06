import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../controllers/timetable_controller.dart';
import '../widgets/today_schedule_card.dart';
import '../widgets/day_expansion_tile.dart';
import '../views/edit_day_dialog.dart';
import '../views/create_timetable_screen.dart';
import '../../attendance/controllers/attendance_controller.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This should not be used directly - use TimetableScreenContent instead
    final attendanceController = AttendanceController();
    return TimetableScreenContent(
      attendanceController: attendanceController,
      timetableController: TimetableController(attendanceController),
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
  void _showEditDayDialog(String day) async {
    final dayData = widget.timetableController.timetable.firstWhere((d) => d.day == day);
    await showDialog(
      context: context,
      builder: (context) {
        return EditDayDialog(
          day: day,
          currentSubjects: dayData.subjects,
          availableSubjects: widget.timetableController.availableSubjects,
          onSave: (subjects) async {
            await widget.timetableController.updateDaySubjects(day, subjects);
          },
        );
      },
    );
  }

  void _navigateToCreateTimetable() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTimetableScreen(controller: widget.timetableController),
      ),
    );
    // Just trigger a rebuild - the controller already has the updated data
    if (mounted) {
      setState(() {});
    }
  }

  void _markTodayAttendance() async {
    await widget.timetableController.markTodayAttendance();
    if (!mounted) return;
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
      backgroundColor: Colors.white,
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
          // Show loading indicator
          if (widget.timetableController.isLoading) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderColor, width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading timetable...',
                        style: AppTheme.attendanceText.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Show error if exists
          if (widget.timetableController.error != null) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.borderColor,
                        offset: const Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: AppTheme.poorAttendance),
                      const SizedBox(height: 16),
                      Text('Error', style: AppTheme.dialogTitle),
                      const SizedBox(height: 8),
                      Text(
                        widget.timetableController.error!,
                        style: AppTheme.attendanceText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          widget.timetableController.clearError();
                          widget.timetableController.refresh();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            border: Border.all(color: AppTheme.borderColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.borderColor,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'RETRY',
                                style: AppTheme.buttonText.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Main content
          try {
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
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
              ),
            );
          } catch (e) {
            // Fallback if rendering fails
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppTheme.poorAttendance),
                    const SizedBox(height: 16),
                    Text('Rendering Error', style: AppTheme.dialogTitle),
                    const SizedBox(height: 8),
                    Text(
                      'Error: $e',
                      style: AppTheme.attendanceText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
