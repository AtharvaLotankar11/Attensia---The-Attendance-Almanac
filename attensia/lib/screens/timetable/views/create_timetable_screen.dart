import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/timetable_day.dart';
import '../controllers/timetable_controller.dart';

class CreateTimetableScreen extends StatefulWidget {
  final TimetableController controller;

  const CreateTimetableScreen({
    super.key,
    required this.controller,
  });

  @override
  State<CreateTimetableScreen> createState() => _CreateTimetableScreenState();
}

class _CreateTimetableScreenState extends State<CreateTimetableScreen> {
  final Map<String, List<String>> _weekSchedule = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  @override
  void initState() {
    super.initState();
    for (var day in widget.controller.timetable) {
      _weekSchedule[day.day] = List.from(day.subjects);
    }
  }

  void _showEditDayDialog(String day) {
    final lectureCountController = TextEditingController(
      text: _weekSchedule[day]!.isEmpty ? '' : _weekSchedule[day]!.length.toString(),
    );
    int lectureCount = _weekSchedule[day]!.length;
    List<String> selectedSubjects = List.from(_weekSchedule[day]!);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: AppTheme.borderColor, width: 4),
              ),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        border: Border(
                          bottom: BorderSide(color: AppTheme.borderColor, width: 4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit_calendar, color: AppTheme.textColor, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'EDIT ${day.toUpperCase()}',
                              style: AppTheme.dialogTitle.copyWith(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NUMBER OF LECTURES',
                              style: AppTheme.labelText.copyWith(
                                fontSize: 11,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.borderColor, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.borderColor,
                                    offset: const Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: lectureCountController,
                                keyboardType: TextInputType.number,
                                style: AppTheme.attendanceText,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Enter number (0-10)',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onChanged: (value) {
                                  final count = int.tryParse(value) ?? 0;
                                  if (count >= 0 && count <= 10) {
                                    setDialogState(() {
                                      lectureCount = count;
                                      if (selectedSubjects.length < count) {
                                        selectedSubjects.addAll(
                                          List.filled(count - selectedSubjects.length, ''),
                                        );
                                      } else if (selectedSubjects.length > count) {
                                        selectedSubjects = selectedSubjects.sublist(0, count);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            if (lectureCount > 0) ...[
                              const SizedBox(height: 24),
                              Text(
                                'ASSIGN SUBJECTS',
                                style: AppTheme.labelText.copyWith(
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...List.generate(lectureCount, (index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'LECTURE ${index + 1}',
                                        style: AppTheme.labelText.copyWith(
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.borderColor,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.borderColor,
                                              offset: const Offset(3, 3),
                                              blurRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          initialValue: selectedSubjects[index].isEmpty
                                              ? null
                                              : selectedSubjects[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                          ),
                                          hint: Text(
                                            'Select Subject',
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: AppTheme.attendanceText,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: AppTheme.textColor,
                                          ),
                                          items: [
                                            DropdownMenuItem<String>(
                                              value: null,
                                              child: Text(
                                                'Free Period',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            ...widget.controller.availableSubjects.map((subject) {
                                              return DropdownMenuItem<String>(
                                                value: subject,
                                                child: Text(subject),
                                              );
                                            }),
                                          ],
                                          onChanged: (value) {
                                            setDialogState(() {
                                              selectedSubjects[index] = value ?? '';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.borderColor, width: 4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: AppTheme.borderColor, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.borderColor,
                                      offset: const Offset(4, 4),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'CANCEL',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.buttonText.copyWith(
                                    color: AppTheme.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _weekSchedule[day] = List.from(selectedSubjects);
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  border: Border.all(color: AppTheme.borderColor, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.borderColor,
                                      offset: const Offset(4, 4),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'SAVE',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.buttonText.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveTimetable() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.borderColor,
                offset: const Offset(6, 6),
                blurRadius: 0,
              ),
            ],
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
                'Saving timetable...',
                style: AppTheme.attendanceText.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final timetable = _weekSchedule.entries
          .map((entry) => TimetableDay(day: entry.key, subjects: entry.value))
          .toList();
      
      await widget.controller.setFullTimetable(timetable);
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Close the create timetable screen
      Navigator.of(context).pop();
      
      // Show success message after navigation
      await Future.delayed(const Duration(milliseconds: 100));
      
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
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Timetable saved successfully!',
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
    } catch (e) {
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.poorAttendance,
              border: Border.all(color: AppTheme.borderColor, width: 3),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to save timetable: $e',
                    style: AppTheme.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.borderColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.borderColor,
                    offset: const Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppTheme.textColor),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            title: const Text('Create Timetable'),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.accentColor, width: 3),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.accentColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tap on any day to configure lectures',
                          style: AppTheme.attendanceText.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                ..._weekSchedule.keys.map((day) {
                  final subjects = _weekSchedule[day]!;
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
                    child: InkWell(
                      onTap: () => _showEditDayDialog(day),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                border: Border.all(color: AppTheme.borderColor, width: 2),
                              ),
                              child: Text(
                                day.substring(0, 3).toUpperCase(),
                                style: AppTheme.labelText.copyWith(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day,
                                    style: AppTheme.subjectName.copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subjects.isEmpty
                                        ? 'No lectures'
                                        : '${subjects.length} lecture${subjects.length > 1 ? 's' : ''}',
                                    style: AppTheme.attendanceText.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.edit, color: AppTheme.textColor, size: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppTheme.borderColor, width: 4),
              ),
            ),
            child: InkWell(
              onTap: _saveTimetable,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  border: Border.all(color: AppTheme.borderColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.borderColor,
                      offset: const Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'SAVE TIMETABLE',
                      style: AppTheme.buttonText.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
