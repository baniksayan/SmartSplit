import 'package:flutter/material.dart';

/// Tax/Tip Toggle Widget
/// Radio selector for switching between Percentage and Fixed Amount
/// Clears the opposite field when toggled
class TaxTipToggle extends StatelessWidget {
  final bool isPercentage;
  final ValueChanged<bool> onChanged;
  final Color? color;
  final String label;

  const TaxTipToggle({
    Key? key,
    required this.isPercentage,
    required this.onChanged,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? const Color(0xFF00B4D8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Percentage option
              Expanded(
                child: _ToggleOption(
                  label: 'Percentage (%)',
                  icon: Icons.percent_rounded,
                  isSelected: isPercentage,
                  onTap: () => onChanged(true),
                  color: selectedColor,
                ),
              ),
              const SizedBox(width: 4),
              
              // Fixed amount option
              Expanded(
                child: _ToggleOption(
                  label: 'Fixed Amount',
                  icon: Icons.attach_money_rounded,
                  isSelected: !isPercentage,
                  onTap: () => onChanged(false),
                  color: selectedColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual toggle option
class _ToggleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _ToggleOption({
    Key? key,
    required this.label,
    required this.icon,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF2D3142).withOpacity(0.5),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF2D3142).withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
