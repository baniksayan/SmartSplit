import 'package:flutter/material.dart';

/// Quick Tip Selector Widget
/// Row of buttons for common tip percentages (0%, 10%, 15%, 20%)
/// Highlights selected percentage
class QuickTipSelector extends StatelessWidget {
  final double? selectedPercentage;
  final ValueChanged<double> onSelected;
  final Color? color;

  const QuickTipSelector({
    Key? key,
    required this.selectedPercentage,
    required this.onSelected,
    this.color,
  }) : super(key: key);

  static const List<double> tipOptions = [0, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? const Color(0xFF00B4D8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Tip Selection',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2D3142).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: tipOptions.map((percentage) {
            final isSelected = selectedPercentage == percentage;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: percentage == tipOptions.last ? 0 : 8,
                ),
                child: _TipButton(
                  percentage: percentage,
                  isSelected: isSelected,
                  onTap: () => onSelected(percentage),
                  color: selectedColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Individual tip percentage button
class _TipButton extends StatelessWidget {
  final double percentage;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _TipButton({
    Key? key,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Emoji or icon
            Text(
              _getEmoji(percentage),
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 4),
            // Percentage text
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmoji(double percentage) {
    if (percentage == 0) return '🚫';
    if (percentage == 10) return '😊';
    if (percentage == 15) return '😄';
    if (percentage == 20) return '🤩';
    return '💰';
  }
}
