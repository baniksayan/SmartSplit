import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/activity/activity_model.dart';

/// Recent Activity Card Widget
/// 
/// Displays activity information with type-specific styling.
/// Supports restaurant splits, expenses, and settlements.
class RecentActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const RecentActivityCard({
    Key? key,
    required this.activity,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activity Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getActivityTypeLabel(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: iconColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        activity.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Subtitle (amount, participants, etc.)
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Timestamp
                      Text(
                        timestamp,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getActivityTypeLabel() {
    switch (activity.activityType) {
      case ActivityType.restaurant:
        return 'RESTAURANT SPLIT';
      case ActivityType.expense:
        return activity.groupName?.toUpperCase() ?? 'EXPENSE';
      case ActivityType.settlement:
        return 'SETTLEMENT';
      default:
        return 'ACTIVITY';
    }
  }
}
