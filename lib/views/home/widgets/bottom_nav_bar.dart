import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom Navigation Bar Widget
/// 
/// Reusable bottom navigation for the main app screens.
/// Features: Home, Groups, Reports, Settings
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.group,
                label: 'Groups',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.assessment,
                label: 'Reports',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.settings,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? const Color(0xFF00B4D8) : Colors.grey[600];

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: color,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                // Active indicator dot
                if (isActive)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00B4D8),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
