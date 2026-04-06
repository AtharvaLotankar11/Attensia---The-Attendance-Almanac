import 'package:flutter/material.dart';
import '../controllers/summary_controller.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/insight_card.dart';
import '../models/summary_model.dart';
import '../../../theme.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return const SummaryScreenContent();
  }
}

class SummaryScreenContent extends StatefulWidget {
  const SummaryScreenContent({super.key});

  @override
  State<SummaryScreenContent> createState() => _SummaryScreenContentState();
}

class _SummaryScreenContentState extends State<SummaryScreenContent> {
  final SummaryController _controller = SummaryController();

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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 4,
            ),
          );
        }

        if (_controller.summary == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: AppTheme.attendanceText.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.refreshSummary,
          color: AppTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainSummaryCard(),
                const SizedBox(height: 24),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildStatusBadge(),
                const SizedBox(height: 24),
                _buildInsightsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainSummaryCard() {
    final summary = _controller.summary!;
    final percentage = summary.percentage;
    
    Color percentageColor;
    if (summary.status == AttendanceStatus.good) {
      percentageColor = AppTheme.goodAttendance;
    } else if (summary.status == AttendanceStatus.moderate) {
      percentageColor = AppTheme.warningAttendance;
    } else {
      percentageColor = AppTheme.poorAttendance;
    }

    return Container(
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
              color: AppTheme.secondaryColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.dashboard_rounded, color: AppTheme.textColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'ATTENDANCE SUMMARY',
                  style: AppTheme.dialogTitle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'OVERALL ATTENDANCE',
                  style: AppTheme.labelText.copyWith(
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: percentageColor.withValues(alpha: 0.1),
                    border: Border.all(color: percentageColor, width: 4),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(2)}%',
                    style: AppTheme.percentageText.copyWith(
                      fontSize: 56,
                      color: percentageColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${summary.totalSubjects} Subjects Tracked',
                  style: AppTheme.attendanceText.copyWith(
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

  Widget _buildStatsGrid() {
    final summary = _controller.summary!;

    return Row(
      children: [
        Expanded(
          child: SummaryStatCard(
            label: 'Attended',
            value: '${summary.attendedLectures}',
            icon: Icons.check_circle_rounded,
            color: AppTheme.goodAttendance,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryStatCard(
            label: 'Total',
            value: '${summary.totalLectures}',
            icon: Icons.calendar_today_rounded,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final summary = _controller.summary!;

    return Center(
      child: StatusBadge(
        status: summary.status,
        message: summary.statusMessage,
      ),
    );
  }

  Widget _buildInsightsSection() {
    final lecturesNeeded = _controller.lecturesNeededForThreshold();
    final lecturesCanMiss = _controller.lecturesCanMiss();
    final summary = _controller.summary!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'INSIGHTS',
          style: AppTheme.dialogTitle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (summary.percentage < _controller.threshold)
          InsightCard(
            title: 'To Reach ${_controller.threshold.toStringAsFixed(0)}%',
            value: '$lecturesNeeded',
            description: 'consecutive lectures needed to attend',
            color: AppTheme.warningAttendance,
          )
        else
          InsightCard(
            title: 'Safe Zone',
            value: '$lecturesCanMiss',
            description: 'lectures you can miss while staying above ${_controller.threshold.toStringAsFixed(0)}%',
            color: AppTheme.goodAttendance,
          ),
      ],
    );
  }

  void _showSettingsDialog() {
    double tempThreshold = _controller.threshold;

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
                                  onTap: () {
                                    setState(() {
                                      _controller.updateThreshold(tempThreshold);
                                    });
                                    Navigator.pop(context);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
