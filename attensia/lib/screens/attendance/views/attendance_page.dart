import 'package:flutter/material.dart';
import '../controllers/attendance_controller.dart';
import '../../../theme.dart';
import '../../profile/profile_screen.dart';
import '../../../services/profile_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return AttendancePageContent(controller: AttendanceController());
  }
}

class AttendancePageContent extends StatefulWidget {
  final AttendanceController controller;

  const AttendancePageContent({
    super.key,
    required this.controller,
  });

  @override
  State<AttendancePageContent> createState() => _AttendancePageContentState();
}

class _AttendancePageContentState extends State<AttendancePageContent> {
  final _profileService = ProfileService();
  
  @override
  Widget build(BuildContext context) {
    final profilePhotoUrl = _profileService.getProfilePhotoUrl();
    
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.borderColor,
                          offset: const Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profilePhotoUrl != null
                          ? Image.network(
                              profilePhotoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
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
                    icon: Icon(Icons.settings, color: AppTheme.textColor, size: 24),
                    onPressed: _showSettingsDialog,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildSubjectList(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderColor, width: 3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.borderColor,
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddSubjectModal,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildSubjectList() {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        // Show loading indicator
        if (widget.controller.isLoading && widget.controller.subjects.isEmpty) {
          return Center(
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
                    'Loading subjects...',
                    style: AppTheme.attendanceText.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        // Show error if exists
        if (widget.controller.error != null) {
          return Center(
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
                    widget.controller.error!,
                    style: AppTheme.attendanceText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    label: 'RETRY',
                    icon: Icons.refresh,
                    color: AppTheme.primaryColor,
                    onPressed: () {
                      widget.controller.clearError();
                      widget.controller.refresh();
                    },
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state
        if (widget.controller.subjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No subjects added yet',
                  style: AppTheme.attendanceText.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first subject',
                  style: AppTheme.labelText.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        // Show subjects list
        return RefreshIndicator(
          onRefresh: () => widget.controller.refresh(),
          color: AppTheme.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.controller.subjects.length,
            itemBuilder: (context, index) {
              final subject = widget.controller.subjects[index];
              return _buildSubjectCard(subject);
            },
          ),
        );
      },
    );
  }

  Widget _buildSubjectCard(dynamic subject) {
    final percentage = subject.percentage;
    final meetsThreshold = subject.meetsThreshold(widget.controller.minAttendanceThreshold);
    final cardColor = meetsThreshold ? AppTheme.goodAttendance : AppTheme.poorAttendance;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
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
          // Header with color indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: AppTheme.subjectName.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: AppTheme.percentageText.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          // Body with attendance info
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ATTENDED',
                            style: AppTheme.labelText.copyWith(
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${subject.attended}',
                            style: AppTheme.percentageText.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 40,
                      color: AppTheme.borderColor,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'TOTAL',
                            style: AppTheme.labelText.copyWith(
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${subject.total}',
                            style: AppTheme.percentageText.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 40,
                      color: AppTheme.borderColor,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'MISSED',
                            style: AppTheme.labelText.copyWith(
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${subject.total - subject.attended}',
                            style: AppTheme.percentageText.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'PRESENT',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.goodAttendance,
                        onPressed: () => _markPresent(subject.id),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        label: 'ABSENT',
                        icon: Icons.cancel_rounded,
                        color: AppTheme.poorAttendance,
                        onPressed: () => _markAbsent(subject.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
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
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.buttonText.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markPresent(String subjectId) async {
    await widget.controller.markPresent(subjectId);
  }

  void _markAbsent(String subjectId) async {
    await widget.controller.markAbsent(subjectId);
  }

  void _showSettingsDialog() {
    double tempThreshold = widget.controller.minAttendanceThreshold;

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
                          Icon(Icons.settings, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'SETTINGS',
                            style: AppTheme.dialogTitle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MINIMUM ATTENDANCE THRESHOLD',
                            style: AppTheme.labelText.copyWith(
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              border: Border.all(color: AppTheme.borderColor, width: 3),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${tempThreshold.toStringAsFixed(0)}%',
                                  style: AppTheme.percentageText.copyWith(fontSize: 48),
                                ),
                                const SizedBox(height: 12),
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppTheme.primaryColor,
                                    inactiveTrackColor: Colors.grey.shade300,
                                    thumbColor: AppTheme.primaryColor,
                                    overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                                    trackHeight: 8,
                                  ),
                                  child: Slider(
                                    value: tempThreshold,
                                    min: 0,
                                    max: 100,
                                    divisions: 20,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        tempThreshold = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await widget.controller.updateThreshold(tempThreshold);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
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

  void _showAddSubjectModal() {
    final nameController = TextEditingController();
    final attendedController = TextEditingController();
    final totalController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
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
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
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
                        Icon(Icons.add_circle, color: AppTheme.textColor, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'ADD NEW SUBJECT',
                          style: AppTheme.dialogTitle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildNeoBrutalTextField(
                          controller: nameController,
                          label: 'SUBJECT NAME',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter subject name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildNeoBrutalTextField(
                          controller: attendedController,
                          label: 'ATTENDED LECTURES',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter attended lectures';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildNeoBrutalTextField(
                          controller: totalController,
                          label: 'TOTAL LECTURES',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter total lectures';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            final total = int.parse(value);
                            final attended = int.tryParse(attendedController.text) ?? 0;
                            if (total < attended) {
                              return 'Total must be >= attended';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              await widget.controller.addSubject(
                                nameController.text,
                                int.parse(attendedController.text),
                                int.parse(totalController.text),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
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
                            child: Text(
                              'ADD SUBJECT',
                              textAlign: TextAlign.center,
                              style: AppTheme.buttonText.copyWith(
                                color: Colors.white,
                                fontSize: 16,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildNeoBrutalTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            keyboardType: keyboardType,
            style: AppTheme.attendanceText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              errorStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
