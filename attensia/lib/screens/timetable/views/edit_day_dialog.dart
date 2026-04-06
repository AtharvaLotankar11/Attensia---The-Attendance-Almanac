import 'package:flutter/material.dart';
import '../../../theme.dart';

class EditDayDialog extends StatefulWidget {
  final String day;
  final List<String> currentSubjects;
  final List<String> availableSubjects;
  final Function(List<String>) onSave;

  const EditDayDialog({
    super.key,
    required this.day,
    required this.currentSubjects,
    required this.availableSubjects,
    required this.onSave,
  });

  @override
  State<EditDayDialog> createState() => _EditDayDialogState();
}

class _EditDayDialogState extends State<EditDayDialog> {
  late TextEditingController _lectureCountController;
  late int _lectureCount;
  late List<String> _selectedSubjects;

  @override
  void initState() {
    super.initState();
    _lectureCount = widget.currentSubjects.isEmpty ? 0 : widget.currentSubjects.length;
    _lectureCountController = TextEditingController(
      text: _lectureCount > 0 ? _lectureCount.toString() : '',
    );
    _selectedSubjects = List.from(widget.currentSubjects);
  }

  @override
  void dispose() {
    _lectureCountController.dispose();
    super.dispose();
  }

  void _updateLectureCount() {
    final count = int.tryParse(_lectureCountController.text) ?? 0;
    if (count >= 0 && count <= 10) {
      setState(() {
        _lectureCount = count;
        if (_selectedSubjects.length < count) {
          _selectedSubjects.addAll(
            List.filled(count - _selectedSubjects.length, ''),
          );
        } else if (_selectedSubjects.length > count) {
          _selectedSubjects = _selectedSubjects.sublist(0, count);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'EDIT ${widget.day.toUpperCase()}',
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
                        controller: _lectureCountController,
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
                        onChanged: (value) => _updateLectureCount(),
                      ),
                    ),
                    if (_lectureCount > 0) ...[
                      const SizedBox(height: 24),
                      Text(
                        'ASSIGN SUBJECTS',
                        style: AppTheme.labelText.copyWith(
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_lectureCount, (index) {
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
                                  initialValue: _selectedSubjects[index].isEmpty
                                      ? null
                                      : _selectedSubjects[index],
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
                                    ...widget.availableSubjects.map((subject) {
                                      return DropdownMenuItem<String>(
                                        value: subject,
                                        child: Text(subject),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSubjects[index] = value ?? '';
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
                        widget.onSave(_selectedSubjects);
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
  }
}
