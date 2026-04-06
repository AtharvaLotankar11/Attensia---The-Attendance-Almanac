import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../theme.dart';

class NeoBrutalCurvedNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NeoBrutalCurvedNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 4),
        ),
      ),
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 65,
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: AppTheme.primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        onTap: onTap,
        items: [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.dashboard_rounded, 1),
          _buildNavItem(Icons.calendar_today_rounded, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.borderColor,
          width: isSelected ? 3 : 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 30,
        color: isSelected ? Colors.white : AppTheme.textColor,
      ),
    );
  }
}
