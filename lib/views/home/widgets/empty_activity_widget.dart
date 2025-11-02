import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Empty Activity Widget
/// 
/// Displayed when user has no recent activities.
/// Provides a friendly message and call-to-action button.
class EmptyActivityWidget extends StatelessWidget {
  final VoidCallback onSplitBillTap;

  const EmptyActivityWidget({
    Key? key,
    required this.onSplitBillTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: const Color(0xFF00B4D8).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'No activity yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Start by splitting a bill with\nyour friends or tracking expenses!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onSplitBillTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4D8),
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0xFF00B4D8).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: Text(
                'Split Bill Now',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
